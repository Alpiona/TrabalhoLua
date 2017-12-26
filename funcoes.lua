Alunos = {}
Alunos._index = Alunos

function Alunos:novo (linha)
  local novoAluno = {}
  local cont = 1
  setmetatable(novoAluno, Aluno)
  local matricula, nome, disciplinas, tipo, curso = linha:match("^([^;]*);([^;]*);([^;]*);([^;]*);([^;]*)$")
  novoAluno.disciplinas = {}
  for disciplina in disciplinas:gmatch("(%w+)") do
    novoAluno.disciplinas[cont] = disciplina
    cont = cont +1
  end
  novoAluno.matricula = matricula
  novoAluno.nome = nome
  novoAluno.tipo = tipo
  novoAluno.curso = curso
  return novoAluno
end

function Alunos:criaTabela (nomeArquivo)
  local arquivo = io.open(nomeArquivo,"r")
  local cont = 1
  local tabelaAlunos = {}
  for linha in arquivo:lines() do
    if (cont > 1) then
      tabelaAlunos[cont-1] = Alunos:novo(linha)
    end
    cont = cont+1
  end
  arquivo:close()
  return tabelaAlunos
end


Avaliacoes = {}
Avaliacoes._index = Avaliacoes

function Avaliacoes:novo (linha)
  local novaAvaliacao = {}
  setmetatable(novaAvaliacao, Avaliacao)
  local disciplina, codigo, nome, peso, tipo, data, tamgrupo  = linha:match("^([^;]*);([^;]*);([^;]*);([^;]*);([^;]*);([^;]*);?([^;]*)$")
  novaAvaliacao.disciplina = disciplina
  novaAvaliacao.codigo = codigo
  novaAvaliacao.nome = nome
  novaAvaliacao.peso = peso
  novaAvaliacao.tipo = tipo
  local dataAux = {}
  dataAux.dia, dataAux.mes , dataAux.ano = data:match("(%d+)/(%d+)/(%d+)")
  novaAvaliacao.data = dataAux
  novaAvaliacao.tamgrupo = tamgrupo
  return novaAvaliacao
end

function Avaliacoes:criaTabela (nomeArquivo)
  local arquivo = io.open(nomeArquivo,"r")
  local cont = 1
  local tabelaAvaliacoes = {}
  for linha in arquivo:lines() do
    if (cont>1) then
      tabelaAvaliacoes[cont-1] = {}
      tabelaAvaliacoes[cont-1] = Avaliacoes:novo(linha)
    end
    cont = cont+1
  end
  arquivo:close()
  return tabelaAvaliacoes
end


Cursos = {}
Cursos._index = Cursos

function Cursos:novo (linha)
  local novoCurso = {}
  setmetatable(novoCurso, Cursos)
  local codigo, nome = linha:match("^([^;]*);([^;]*)$")
  novoCurso.codigo = codigo
  novoCurso.nome = nome
  return novoCurso
end

function Cursos:criaTabela (nomeArquivo)
  local arquivo = io.open(nomeArquivo,"r")
  local cont = 1
  local tabelaCursos = {}
  for linha in arquivo:lines() do
    if (cont>1) then
      tabelaCursos[cont-1] = {}
      tabelaCursos[cont-1] = Cursos:novo(linha)
    end
    cont = cont +1
  end
  arquivo:close()
  return tabelaCursos
end


Disciplinas = {}
Disciplinas._index = disciplinas

function Disciplinas:novo (linha)
  local novaDisciplina = {}
  setmetatable(novaDisciplina, Disciplinas)
  local codigo, nome = linha:match("^([^;]*);([^;]*)$")
  novaDisciplina.codigo = codigo
  novaDisciplina.nome = nome
  return novaDisciplina
end

function Disciplinas:criaTabela (nomeArquivo)
  local arquivo = io.open(nomeArquivo,"r")
  local cont = 1
  local tabelaDisciplinas = {}
  for linha in arquivo:lines() do
    if (cont>1) then
      tabelaDisciplinas[cont-1] = {}
      tabelaDisciplinas[cont-1] = Disciplinas:novo(linha)
    end
    cont = cont+1
  end
  arquivo:close()
  return tabelaDisciplinas
end


Notas = {}
Notas._index = notas

function Notas:novo(linha)
  local cont =1
  local novaNota = {}
  setmetatable (novaNota, Notas)
  local avaliacao, matriculas, nota = linha:match("^([^;]*);([^;]*);([^;]*)$")
  novaNota.avaliacao = avaliacao
  novaNota.matriculas = {}
  for matricula in matriculas:gmatch("(%w+)") do
    novaNota.matriculas[cont] = matricula
    cont = cont + 1
  end
  novaNota.nota = string.gsub(nota, ",", ".")
  formatnumeros = string.format("%.2f",novaNota.nota)
  novaNota.nota = formatnumeros
  return novaNota
end

function Notas:criaTabela(nomeArquivo)
  local arquivo = io.open(nomeArquivo,"r")
  local cont = 1
  local tabelaNotas = {}
  for linha in arquivo:lines() do
    if (cont>1) then
      tabelaNotas[cont-1] = {}
      tabelaNotas[cont-1] = Notas:novo(linha)
    end
    cont = cont+1
  end
  arquivo:close()
  return tabelaNotas
end

function ordenaAlunos (tabelaA, tabelaB)
  return tabelaA.nome < tabelaB.nome
end

function ordenaAvaliacoes (tabelaA, tabelaB)
  if tabelaA.disciplina == tabelaB.disciplina then
    if tabelaA.data.mes == tabelaB.data.mes then
      return tabelaA.data.dia < tabelaB.data.dia
    else
      return tabelaA.data.mes < tabelaB.data.mes
    end
  else
    return tabelaA.disciplina < tabelaB.disciplina
  end
end

function arquivoPauta (tabelaAvaliacoes, disciplina)
  local colunas = "Matrícula;Aluno;"
  local arquivoSaida = "1-pauta-"..disciplina.codigo..".csv"
  local relatorioSaida = io.open(arquivoSaida, "w+")
  local cont = 0
  local pesoAvaliacoes = {}
  for j, avaliacao in ipairs(tabelaAvaliacoes) do
    if avaliacao.disciplina == disciplina.codigo then
      cont = cont + 1
    end
  end
  qntAvaliacoes = cont
  for j, avaliacao in ipairs(tabelaAvaliacoes) do
    if avaliacao.disciplina == disciplina.codigo and cont > 1 then
      colunas = colunas..avaliacao.codigo..";"
      cont = cont -1
      pesoAvaliacoes[qntAvaliacoes-cont] = avaliacao.peso
    end
  end
  colunas = colunas.."Média Parcial;Prova Final;Média Final"
  relatorioSaida:write(colunas.."\n")
  return pesoAvaliacoes, relatorioSaida
end

function linhaAlunoPauta(pesoAvaliacoes, aluno,tabelaAvaliacoes, tabelaNotas, codigo)
  local cont = 1
  local mediaP = 0
  local mediaF = 0
  local pesoTotal = 0
  aluno.mediaF ={}
  aluno.aprovado={}
  local linha = aluno.matricula..";"..aluno.nome..";"
  for j, avaliacao in ipairs (tabelaAvaliacoes) do
    if avaliacao.disciplina == codigo then
      for i, nota in ipairs(tabelaNotas) do
        if (nota.avaliacao == avaliacao.codigo) then
          for k, matricula in ipairs(nota.matriculas) do
            if (matricula == aluno.matricula) and (cont <= #pesoAvaliacoes) then
              linha = linha..nota.nota..";"
              mediaP = mediaP + (nota.nota*pesoAvaliacoes[cont])
              pesoTotal = pesoTotal + pesoAvaliacoes[cont]
              if (cont == #pesoAvaliacoes) and (mediaP/pesoTotal) >= 7 then
<<<<<<< HEAD
                local formatMediaP = string.format("%.2f",(math.floor(mediaP/pesoTotal*100+0.5)/100))
                linha = linha..(formatMediaP)..";-;"..(formatMediaP).."\n"
                print(linha)
                -- linha = linha..(mediaP/pesoTotal)..";-;"..(mediaP/pesoTotal).."\n"
                aluno.mediaF[codigo] = mediaP/pesoTotal
                aluno.aprovado[codigo] = true
=======
                formatMediaP = string.format("%.2f",(math.floor(mediaP/pesoTotal*100+0.5)/100))
                linha = linha..(formatMediaP)..";-;"..(formatMediaP).."\n"
>>>>>>> 8433ab8cd2afe130d85b6b759d151b9e4b869e84
                return linha
              end
              cont = cont+1
            elseif (matricula == aluno.matricula) and (cont > #pesoAvaliacoes) then
<<<<<<< HEAD
              -- linha = linha..(mediaP/pesoTotal)..";"..nota.nota..";"..(((mediaP/pesoTotal)+nota.nota)/2).."\n"
              local formatMediaP = string.format("%.2f",(math.floor(mediaP/pesoTotal*100+0.5)/100))
              local formatMediaF = string.format("%.2f",(math.floor((formatMediaP+nota.nota)/2*100+0.5)/100))
              linha = linha..(formatMediaP)..";"..nota.nota..";"..(formatMediaF).."\n"
              aluno.mediaF[codigo] = ((mediaP/pesoTotal)+nota.nota)/2
              if aluno.mediaF[codigo] >= 5 then
                aluno.aprovado[codigo] = true
              else
                aluno.aprovado[codigo] = false
              end
=======
              formatMediaP = string.format("%.2f",(math.floor(mediaP/pesoTotal*100+0.5)/100))
              formatMediaF = string.format("%.2f",(math.floor((formatMediaP+nota.nota)/2*100+0.5)/100))
              linha = linha..(formatMediaP)..";"..nota.nota..";"..(formatMediaF).."\n"
>>>>>>> 8433ab8cd2afe130d85b6b759d151b9e4b869e84
              return linha
            end
          end
        end
      end
    end
  end
end

function imprimePautas (tabelaAlunos, tabelaAvaliacoes, tabelaNotas, tabelaDisciplinas)
  for i, disciplina in ipairs (tabelaDisciplinas) do
    local pesoAvaliacoes, arquivoSaida = arquivoPauta(tabelaAvaliacoes, disciplina)
    for j, aluno in ipairs (tabelaAlunos) do
      for k,disciplinaPresente in ipairs (aluno.disciplinas) do
        if (disciplina.codigo == disciplinaPresente) then
          arquivoSaida:write(linhaAlunoPauta (pesoAvaliacoes, aluno, tabelaAvaliacoes, tabelaNotas, disciplinaPresente))
        end
      end
    end
  end
end

function criaDisciplinaRelatorio (codigo, nome, curso)
  novaDisciplina = {}
  novaDisciplina.codigo = codigo
  novaDisciplina.nome = nome
  novaDisciplina.turma = curso
  return novaDisciplina
end

function organizaEstatistica(relatorioDisciplinas, tabelaAlunos)
  for i, disciplina in ipairs(relatorioDisciplinas) do
    local aprovados = 0
    local reprovados = 0
    local media = 0
    for j, aluno in ipairs(tabelaAlunos) do
      if aluno.curso == disciplina.turma then
        for k, disciplinaAluno in ipairs(aluno.disciplinas) do
          print(aluno.disciplinaAluno, disciplina.codigo)
          if aluno.disciplinaAluno == disciplina.codigo then
            media = media + aluno.mediaF[disciplina.codigo]
            print(aluno.aprovado[disciplina.codigo], disciplina.codigo)
            if aluno.aprovado[disciplina.codigo] then
              aprovados = aprovados + 1
              print (aprovados)
            else
              reprovados = reprovados +1
            end
          end
        end
      end
    end
    print(aprovados, media, alunos)
    disciplina.aprovacao = 100* (aprovados/(aprovados+reprovados))
    disciplina.media = media/(aprovados+reprovados)
  end
  for i, disciplina in ipairs(relatorioDisciplinas) do
    print (disciplina.codigo, disciplina.nome, disciplina.media, disciplina.aprovacao)
  end
end

function imprimeEstatisticas (tabelaAlunos, tabelaCursos, tabelaDisciplinas)
  local colunas = "Código;Disciplina;Curso;Média;% Aprovados"
  local cont = 1
  local relatorioDisciplinas = {}
  local precisaCriar = false
  for i, disciplina in ipairs(tabelaDisciplinas) do
    for j, aluno in ipairs(tabelaAlunos) do
      for k, disciplinaAluno in ipairs(aluno.disciplinas) do
        precisaCriar = false
        if disciplina.codigo == disciplinaAluno then
          precisaCriar = true
          if type(relatorioDisciplinas) == "table" then
            for y, disciplinaRelatorio in ipairs(relatorioDisciplinas) do
              if disciplinaRelatorio.codigo == disciplinaAluno and disciplinaRelatorio.turma == aluno.curso then
                precisaCriar = false
              end
            end
          end
        end
        if precisaCriar then
          relatorioDisciplinas[cont] = criaDisciplinaRelatorio(disciplina.codigo, disciplina.nome, aluno.curso)
          cont = cont + 1
        end
      end
    end
  end
  print (colunas)
  organizaEstatistica(relatorioDisciplinas, tabelaAlunos)
  for y,disciplinaRelatorio in ipairs(relatorioDisciplinas) do

  end
end

function imprimeSaidas(tabelaAlunos, tabelaAvaliacoes, tabelaCursos, tabelaDisciplinas, tabelaNotas)
  table.sort(tabelaAlunos, ordenaAlunos)
  table.sort(tabelaAvaliacoes, ordenaAvaliacoes)
  imprimePautas(tabelaAlunos, tabelaAvaliacoes, tabelaNotas, tabelaDisciplinas)
  imprimeEstatisticas(tabelaAlunos, tabelaCursos, tabelaDisciplinas)
end
