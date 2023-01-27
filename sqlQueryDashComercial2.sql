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
	dCliente.DateFirstPurchase AS 'PrimeiraCompra',
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
	CONCAT(dGeografia.StateProvinceName, ', ', dGeografia.RegionCountryName) AS 'Estado',
	CONCAT(dGeografia.CityName, ', ', dGeografia.StateProvinceName, ', ', dGeografia.RegionCountryName) AS 'Cidade',
	dGeografia.StateProvinceName AS 'Estado-Provincia',
	dGeografia.CityName AS 'Municipio'
	
  FROM [dbo].[DimCustomer] AS dCliente
  LEFT JOIN DimGeography AS dGeografia ON dCliente.GeographyKey = dGeografia.GeographyKey
  WHERE CONCAT(dCliente.FirstName, ' ', dCliente.MiddleName, ' ', dCliente.LastName) <> ''

-- Criar tabela URLs 
-- Tabela utilizada para incluir foto de cada categoria na tabela dProdutos
-- Os links são URLs do google Drive contendo a respectiva foto de cada categoria


CREATE TABLE dImagem (
	[IdCategoria] int,
	[Url] varchar(800)
	)

INSERT INTO dImagem 
	([IdCategoria], [Url])
VALUES(1, 'link1'),
(2, 'link2'),
(3, 'link3'),
(4, 'link3'),
(5, 'link4'),
(6, 'link5'),
(7, 'link6'),
(8, 'link7')


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


--  VIEW TABELA dProduto

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

CREATE VIEW VwfVendas AS
 SELECT 
	fVendas.DateKey AS 'DataVenda',
	fVendas.StoreKey AS 'IdLoja',
	fVendas.ProductKey AS 'IdProduto',
	fVendas.CustomerKey AS 'IdCliente',
	fVendas.SalesOrderNumber AS 'OrdemServico',
	fVendas.SalesQuantity AS 'QtdVendida',
	fVendas.ReturnQuantity AS 'QtdDevolvida'

 FROM FactOnlineSales AS fVendas
 LEFT JOIN DimCustomer AS dCliente ON fVendas.CustomerKey = dCliente.CustomerKey
 WHERE CONCAT(dCliente.FirstName, ' ', dCliente.MiddleName, ' ', dCliente.LastName) <> ''


