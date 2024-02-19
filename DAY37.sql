CREATE DATABASE Kitabxana

USE Kitabxana

CREATE TABLE Authors
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(25),
	Surname NVARCHAR(20)

)

CREATE TABLE Books
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(100) CHECK(LEN(Name) BETWEEN 2 AND 100),
	AuthorId INT FOREIGN KEY REFERENCES Authors(Id),
	PageCount INT CHECK(PageCount >= 10)
)

--Books ve Authors table-larınız olsun(one to many realtion)Id,Name,PageCount ve AuthorFullName columnlarının 
--valuelarını qaytaran bir view yaradın

CREATE VIEW VW_Books
AS
SELECT B.Id,B.Name,B.PageCount,CONCAT(A.Name,' ',A.Surname) AS AuthorFullName FROM Books AS B
JOIN Authors AS A ON B.AuthorId = A.Id

--Göndərilmiş axtarış dəyərinə görə həmin axtarış dəyəri name və ya authorFullName-lərində olan Book-ları
--Id,Name,PageCount,AuthorFullName columnları şəklində göstərən procedure yazın

CREATE PROCEDURE USP_Search
@SEARCH NVARCHAR(20)
AS
SELECT * FROM VW_Books 
WHERE Name LIKE CONCAT('%', @SEARCH, '%') OR AuthorFullName LIKE CONCAT('%', @SEARCH, '%')

EXEC USP_Search 'w'

--Book tabledaki verilmiş id-li datanın qiymıətini verilmiş yeni qiymətə update edən procedure yazın.
--Books'da qiymet datasi yox idi amma yenede yazmaga calisdim

CREATE PROCEDURE USP_Price_Update
@BOOKID INT,
@NEWPRICE MONEY
AS
UPDATE Books SET Price = @NEWPRICE WHERE Books.Id = @BOOKID

-- sonra queryler
--Authors-ları Id,FullName,BooksCount,MaxPageCount şəklində qaytaran view yaradırsınız
--Id-author id-si
--FullName - Name ve Surname birləşməsi
--BooksCount - Həmin authorun əlaqəli olduğu kitabların sayı
--MaxPageCount - həmin authorun əlaqəli olduğu kitabların içərisindəki max pagecount dəyəri


CREATE VIEW VW_Authors
AS
SELECT A.Id,CONCAT(A.Name,' ' ,A.Surname) AS FullName,COUNT(B.Id) AS BooksCount, MAX(B.PageCount) AS MaxPageCount
FROM Authors AS A
JOIN Books AS B ON A.Id = B.AuthorId
GROUP BY A.Id, CONCAT(A.Name, ' ', A.Surname)

SELECT * FROM VW_Authors