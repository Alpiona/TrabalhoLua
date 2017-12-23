Alunos = {}
Alunos._index = Alunos

function Alunos:novo (linha)
  local novoAluno = {}
  setmetatable(novoAluno, Aluno)
  local matricula, nome, disciplina, tipo, curso = linha:match("^([^;]*);([^;]*);([^;]*);([^;]*);([^;]*)$")
  novoAluno.matricula = matricula
  novoAluno.nome = nome
  novoAluno.disciplina = disciplina
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
      tabelaAlunos[cont-1] = {}
      tabelaAlunos[cont-1] = Alunos:novo(linha)
    end
    cont = cont+1
  end
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
  novaAvaliacao.data = data
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
  return tabelaDisciplinas
end


Notas = {}
Notas._index = notas

function Notas:novo(linha)
  local novaNota = {}
  setmetatable (novaNota, Notas)
  local avalicao, matricula, nota = linha:match("^([^;]*);([^;]*);([^;]*)$")
  novaNota.avaliacao = avaliacao
  novaNota.matricula = matricula
  novaNota.nota = nota
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
  return tabelaNotas
end


function organizaTabelaAlunos (tabelaAlunos, tabelaCursos, tabelaDisciplinas)
cont =1
  for i, aluno in ipairs(tabelaAlunos) do
    local disciplinas = {}
    for j, disciplina in ipairs (tabelaDisciplinas) do
      for discip in aluno.disciplina:gmatch("(%w+)") do
        if (discip == disciplina.codigo) then
          disciplinas[cont] = disciplina
          cont = cont +1
        end
      end
    end
    aluno.disciplina = disciplinas
    cont = 1
    for j, curso in ipairs(tabelaCursos) do
      if (curso.codigo == aluno.curso) then
        aluno.curso = curso
      end
    end
  end
end

function organizaTabelas(tabelaAlunos, tabelaAvaliacoes, tabelaCursos, tabelaDisciplinas, tabelaNotas)
  organizaTabelaAlunos (tabelaAlunos, tabelaCursos, tabelaDisciplinas)
end
