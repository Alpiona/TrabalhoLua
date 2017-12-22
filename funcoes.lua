Alunos = {}
Alunos ._index = Alunos

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
    print(linha)
    tabelaAlunos[cont] = {}
    tabelaAlunos[cont] = Alunos:novo(linha)
    cont = cont+1
  end
  for i,aluno in ipairs(tabelaAlunos) do
    print (aluno.nome)
  end
  return tabelaAlunos

end
