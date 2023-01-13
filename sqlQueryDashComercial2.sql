 -- VIEW TABELA dClientes 
 -- Realizado Join na tabela de geografia para pegar informações de localidade
 
 CREATE VIEW VwdCliente AS

   SELECT 
    dCliente.CustomerKey AS 'IdCliente',
    dCliente.GeographyKey as 'IdLocalidade',
    CONCAT(dCliente.FirstName, ' ', dCliente.MiddleName, ' ', dCliente.LastName) AS 'NomeCompleto',
	FORMAT(dCliente.BirthDate, 'dd/MM/yyyy', 'pt-br') AS 'DataNascimento',
	dCliente.MaritalStatus AS 'EstadoCivil',
	dCliente.Gender AS 'Sexo',
	dCliente.YearlyIncome AS 'RendaAnual',
	dCliente.TotalChildren AS 'QtdFilhos',
	dCliente.Occupation AS 'Ocupacao',
	DATEDIFF(YEAR, dCliente.BirthDate, GETDATE()) AS 'Idade',
		CASE
			WHEN DATEDIFF(YEAR,dCliente.BirthDate, GETDATE()) > 70 THEN 'Acima de 70 anos'
			WHEN DATEDIFF(YEAR, dCliente.BirthDate, GETDATE()) > 60 THEN '61-70 anos'
			WHEN DATEDIFF(YEAR, dCliente.BirthDate, GETDATE()) > 50 THEN '51-60 anos'
			WHEN DATEDIFF(YEAR, dCliente.BirthDate, GETDATE()) > 40 THEN '41-50 anos'
			ELSE '31-40 anos'
		END AS 'CategoriaIdade',
	dGeografia.ContinentName  AS 'Continente',
	dGeografia.RegionCountryName AS 'Pais',
	dGeografia.StateProvinceName AS 'Estado',
	dGeografia.CityName AS 'Cidade'

  FROM [dbo].[DimCustomer] AS dCliente
  LEFT JOIN DimGeography AS dGeografia ON dCliente.GeographyKey = dGeografia.GeographyKey
  WHERE CONCAT(dCliente.FirstName, ' ', dCliente.MiddleName, ' ', dCliente.LastName) <> ''



-- VIEW TABELA dLoja
--Na análise do PBI é usado apenas 3 lojas, essas filtradas no Where
CREATE VIEW VwdLoja AS
SELECT 
	StoreKey AS 'IdLoja',
	dLoja.StoreName AS 'NomeLoja',
	dLoja.StoreType AS 'TipoLoja'
FROM DimStore AS dLoja
WHERE dLoja.StoreName IN (
						'Contoso North America Online Store',
						'Contoso Europe Online Store',
						'Contoso Asia Online Store'
						)

-- Criar tabela URLs 
-- Tabela utilizada para incluir foto de cada categoria na tabela dProdutos

CREATE TABLE dImagem (
	[IdCategoria] int,
	[Url] varchar(800)
	)

INSERT INTO dImagem 
	([IdCategoria], [Url])
VALUES(1, 'https://drive.google.com/uc?id=1DczZ1prOhx33FSZpukxWI6aeMNbtFWng'),
(2, 'https://drive.google.com/uc?id=1jDH0x1PFedn4pt_C9SJ43ENzZV7_foyF'),
(3, 'https://drive.google.com/uc?id=1-ZoN_CsbMJlseKCncLRUJzLaQXhOukdi'),
(4, 'https://drive.google.com/uc?id=10-A2bGs7bU3NmhZmfkf0IIVJJmvcPfx9'),
(5, 'https://drive.google.com/uc?id=1jEGHcPcH1qMmYFclD1K1tyuGjYzIXX_i'),
(6, 'https://drive.google.com/uc?id=1NoiGmvU0F3hYGs4kFsuk25jHzJQu8lpR'),
(7, 'https://drive.google.com/uc?id=1hHB9cdeu_UWh5cyn9rnYRGfCzKI_aSOp'),
(8, 'https://drive.google.com/uc?id=1yfHeNQ2kMcg6s8Pql2Caee935oVRldIT')

--  VIEW TABELA dProduto
--  Realizado Join com as tabelas de Categoria, Subcategoria e Imagem para obter o nome da categoria e subcategoria e URL com foto de cada categoria

CREATE VIEW VwdProduto AS
  SELECT 
	dProduto.ProductKey AS 'IdProduto',
	dProduto.ProductName AS 'NomeProduto',
	dProduto.BrandName AS 'Marca',
	dProduto.ColorName AS 'Cor',
	dProduto.UnitCost AS 'CustoUnitario',
	dProduto.UnitPrice AS 'PrecoUnitario',
	dSubCat.ProductSubcategoryName AS 'SubCategoria',
	dCategoria.ProductCategoryName AS 'Categoria',
	dImagem.[Url] AS 'Url'
  FROM DimProduct AS dProduto
  LEFT JOIN DimProductSubcategory AS dSubCat ON dProduto.ProductSubcategoryKey = dSubCat.ProductSubcategoryKey
  LEFT JOIN DimProductCategory AS dCategoria ON dSubCat.ProductCategoryKey = dCategoria.ProductCategoryKey
  LEFT JOIN dImagem ON dCategoria.ProductCategoryKey = dImagem.IdCategoria

  -- VIEW TABELA dLoja

CREATE VIEW fVendas AS
 SELECT 
	fVendas.DateKey AS 'DataVenda',
	fVendas.StoreKey AS 'IdLoja',
	fVendas.ProductKey AS 'IdProduto',
	fVendas.CustomerKey AS 'IdCliente',
	fVendas.SalesOrderNumber AS 'OrdemServico',
	fVendas.SalesQuantity AS 'QtdVendida',
	fVendas.ReturnQuantity AS 'QtdDevolvida'

 FROM FactOnlineSales AS fVendas

