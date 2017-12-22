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
  local arquivo = io.open(nomeArquivo)
  local cont = 1
  local tabelaAlunos = {}
  for linha in arquivo:lines() do
    if (cont > 1) then
      tabelaAlunos[cont-1] = {}
      tabelaAlunos[cont-1] = Alunos:novo(linha)
    end
    cont = cont+1
  end
  for i,aluno in ipairs(tabelaAlunos) do
    print (aluno.nome)
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
  local arquivo = io.open(nomeArquivo)
  local cont = 1
  local tabelaAvaliacoes = {}
  for linha in arquivo:lines() do
    if (cont>1) then
      tabelaAvaliacoes[cont-1] = {}
      tabelaAvaliacoes[cont-1] = Avaliacoes:novo(linha)
    end
    cont = cont+1
  end
  for i,avaliacao in ipairs(tabelaAvaliacoes) do
    print (avaliacao.disciplina)
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
  local arquivo = io.open(nomeArquivo)
  local cont = 1
  local tabelaCursos = {}
  for linha in arquivo:lines() do
    if (cont>1) then
      tabelaCursos[cont-1] = {}
      tabelaCursos[cont-1] = Cursos:novo(linha)
    end
    cont = cont +1
  end
  for i,curso in ipairs(tabelaCursos) do
    print (curso.nome)
  end
  return tabelaCursos
end
