CREATE DATABASE ESCOLA;
USE ESCOLA;

CREATE TABLE Local_(Codigo INT NOT NULL, Categoria VARCHAR(45) NOT NULL, Descricao VARCHAR(45), PRIMARY KEY(Codigo));

CREATE TABLE Departamento(Codigo INT NOT NULL, Nome VARCHAR(45) NOT NULL, PRIMARY KEY(Codigo));

CREATE TABLE Disciplina(Codigo INT NOT NULL, Nome VARCHAR(45) NOT NULL, CargaHoraria INT NOT NULL, 
						 PRIMARY KEY(Codigo)); -- lidar com isso dps ! (Fazer tabela livro?)
                        
CREATE TABLE Responsavel(CPF INT NOT NULL, NOME VARCHAR(45) NOT NULL, EstadoCivil VARCHAR(20), PRIMARY KEY(CPF));

CREATE TABLE Telefone(Fone INT NOT NULL, ResponsavelCPF INT NOT NULL, PRIMARY KEY(Fone),
				      FOREIGN KEY (ResponsavelCPF) REFERENCES Responsavel(CPF));

CREATE TABLE Professor(Matricula INT NOT NULL,Nome VARCHAR(45) NOT NULL,Salário FLOAT NOT NULL,DataContratacao DATE NOT NULL, 
					 DataNascimento DATE NOT NULL,Formacao VARCHAR(45) NOT NULL, FOTO BLOB,
                     DisciplinaCodigo INT, DepartamentoCodigo INT, PRIMARY KEY(MATRICULA),
                     FOREIGN KEY(DisciplinaCodigo) REFERENCES Disciplina(Codigo),
                     FOREIGN KEY(DepartamentoCodigo) REFERENCES Departamento(Codigo));
                     
CREATE TABLE AtividadeExtracurricular(Codigo INT NOT NULL, Descricao VARCHAR(60) NOT NULL, Horario TIME, 
									  Local_Codigo INT, ProfessorMatricula INT, PRIMARY KEY(Codigo),
                                      FOREIGN KEY (Local_Codigo) REFERENCES Local_(Codigo),
                                      FOREIGN KEY (ProfessorMatricula) REFERENCES Professor(Matricula));

CREATE TABLE Turma(Identificacao INT NOT NULL,Turno VARCHAR(20) NOT NULL,Local_Codigo INT NOT NULL,
				   PRIMARY KEY(Identificacao),
                   FOREIGN KEY (Local_Codigo) REFERENCES Local_(Codigo));

CREATE TABLE Estudante(Matricula INT NOT NULL,Nome VARCHAR(45) NOT NULL, Sexo char NOT NULL, DataNascimento DATE,Mensalidade FLOAT,  
					   Foto BLOB, TurmaIdentificacao INT, PRIMARY KEY(Matricula),
                       FOREIGN KEY (TurmaIdentificacao) REFERENCES Turma(Identificacao));
                     
CREATE TABLE Dependente(Nome VARCHAR(45) NOT NULL,Parentesco VARCHAR(45) NOT NULL, DataNascimento DATE NOT NULL,
						ProfessorMatricula INT NOT NULL, PRIMARY KEY(Nome),
                        FOREIGN KEY (ProfessorMatricula) REFERENCES Professor(Matricula));



CREATE TABLE Itens(Nome VARCHAR(45) NOT NULL,Quantidade INT NOT NULL,DescricaoAdicional VARCHAR(45), 
					Ilustracao BLOB NOT NULL, PRIMARY KEY(Nome)); -- Mudar Ilustracao para BLOB?

CREATE TABLE Despesas(Id INT NOT NULL,Descricao VARCHAR(60) NOT NULL,Valor FLOAT NOT NULL, Data_ DATE, 
					  DepartamentoCodigo INT, PRIMARY KEY(Id),
					  FOREIGN KEY (DepartamentoCodigo) REFERENCES Departamento(Codigo));
                      
CREATE TABLE HistoricoDespesas(MesAno DATE NOT NULL,GastoMensal FLOAT NOT NULL, -- Mesano eh um DATE que vai ser guardado por default como YYYY/MM/01, para acessar so o YM, usar funcao.
							   DepartamentoCodigo INT, PRIMARY KEY(MesAno), 
                               FOREIGN KEY (DepartamentoCodigo) REFERENCES Departamento(Codigo)); 
                                
CREATE TABLE ProfessorTurma(ProfessorMatricula INT NOT NULL, TurmaIdentificacao INT NOT NULL, 
							FOREIGN KEY(ProfessorMatricula) REFERENCES Professor(Matricula),
                            FOREIGN KEY(TurmaIdentificacao) REFERENCES Turma(Identificacao));
                            
CREATE TABLE ResponsavelEstudante(ResponsavelCPF INT NOT NULL, EstudanteMatricula INT NOT NULL, 
								 FOREIGN KEY (ResponsavelCPF) REFERENCES Responsavel(CPF),
                                 FOREIGN KEY (EstudanteMatricula) REFERENCES Estudante(Matricula));

CREATE TABLE Notas(Bimestre INT NOT NULL, Prova FLOAT NOT NULL, Teste FLOAT NOT NULL, 
					Projeto FLOAT NOT NULL, Atividades FLOAT NOT NULL,EstudanteMatricula INT NOT NULL, 
                    DisciplinaCodigo INT NOT NULL, PRIMARY KEY(Bimestre),
                    FOREIGN KEY (EstudanteMatricula) REFERENCES Estudante(Matricula),
                    FOREIGN KEY (DisciplinaCodigo) REFERENCES Disciplina(Codigo));
SHOW FIELDS from ESTUDANTE where Type like '%blob'