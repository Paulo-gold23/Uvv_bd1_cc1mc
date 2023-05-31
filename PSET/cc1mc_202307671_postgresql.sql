-- Apagando o banco de dados (se existir)


DROP DATABASE IF EXISTS uvv;

-- Apagando o usuario (se existir)


DROP USER IF EXISTS paulo_gold;


-- Criação de usuario

CREATE USER paulo_gold WITH
        superuser
        createdb 
        encrypted password 'jotinha'
        ;


-- Criação passo a passo do banco de dados uvv

CREATE DATABASE uvv with
    OWNER=      paulo_gold
    ENCODING=   template0
    TEMPLATE=   template0
    LC_COLLATE= 'pt_BR.UTF-8'
    LC_CTYPE=   'pt_BR.UTF-8'
    CONNECTION LIMIT=   -1;

-- Criação do esquema lojas

CREATE SCHEMA lojas AUTHORIZATION paulo_gold 

-- Confirgurando o esquema lojas como esquema padrão

SET SEARCH_PATH TO lojas, "$user", public;

ALTER USER paulo_gold 

SET SEARCH_PATH TO lojas, "$user", public;

-- Conexão com o banco de dados uvv

\c "host=localhost dbname=uvv user=paulo_gold password='jotinha'"

-- processo de criação das tabelas

-- Criando a tabela produtos

CREATE TABLE produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),   CONSTRAINT check_preço CHECK (preco_unitario >=0)
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);

ALTER TABLE produtos 

--Comentários sobre a tabela produtos

COMMENT ON TABLE  lojas.produtos                            IS  A tabela que na qual armazenaremos informações sobre os produtos
COMMENT ON COLUMN lojas.produtos.produto_id                 IS  A PK da tabela contendo a identidificação dos produtos      
COMMENT ON COLUMN lojas.produtos.nome                       IS  Coluna contendo o nome de cada produto, nao pode ser nula 
COMMENT ON COLUMN lojas.produtos.preco_unitario             IS  Coluna contendo o preço de cada unidade do produto
COMMENT ON COLUMN lojas.produtos.detalhes                   IS  Coluna contendo os detalhes dos produtos
COMMENT ON COLUMN lojas.produtos.imagem                     IS  Coluna que armazena as imagens dos produtos
COMMENT ON COLUMN lojas.produtos.imagem_mime_type           IS  Coluna que irá armazenar o mime type das imagens 
COMMENT ON COLUMN lojas.produtos.imagem_arquivo             IS  coluna que armazena o arquivo das imagens 
COMMENT ON COLUMN lojas.produtos.imagem_charset             IS  coluna que receberá o charset do arquivo das imagens do produto 
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao  IS


CREATE TABLE lojas (
                loja_id NUMERIC NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo LONGBLOB,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                PRIMARY KEY (loja_id)
);

ALTER TABLE lojas COMMENT 'criando a tabela onde armazenaremos nas colunas informações sobre as lojas da empresa que fará relacionamentos com as tabelas envios,pedidos e estoques';


CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                loja_id NUMERIC NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                PRIMARY KEY (estoque_id)
);

ALTER TABLE estoques COMMENT 'criando a tabela onde armazenaremos nas colunas informações sobre a situação dos estoques que faz conexão com as tabelas lojas e produtos';


CREATE TABLE clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                PRIMARY KEY (cliente_id)
);

ALTER TABLE clientes COMMENT 'criando a tabela onde armazenaremos nas colunas informações sobre os clientes onde faremos relações com os pedidos e os envios.';


CREATE TABLE pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora DATETIME NOT NULL,
                status VARCHAR(15) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC NOT NULL,
                PRIMARY KEY (pedido_id)
);

ALTER TABLE pedidos COMMENT 'criando a tabela onde armazenaremos nas colunas informações sobre os pedidos que faz conexão com as tabelas lojas,pedidos e clientes';


CREATE TABLE envios (
                envio_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC NOT NULL,
                PRIMARY KEY (envio_id)
);

ALTER TABLE envios COMMENT 'criando a tabela onde armazenaremos nas colunas informações sobre os envios da empresa onde fará relações com as tabelas clientes,lojas e pedidos_itens';


CREATE TABLE pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha VARCHAR(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38) NOT NULL,
                PRIMARY KEY (pedido_id, produto_id)
);

ALTER TABLE pedidos_itens COMMENT 'criando a tabela onde armazenaremos nas colunas informações sobre os itens que foram pedidos que faz conexão con a tabela envios, produtos e pedidos';


ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;











