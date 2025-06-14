CREATE DATABASE library;
USE library;

CREATE TABLE tbl_book_authors
(
	book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT NOT NULL,
    book_authors_AuthorName VARCHAR(100) NOT NULL,
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(100) PRIMARY KEY,
    publisher_PublisherAddress VARCHAR(255),
    publisher_PublisherPhone VARCHAR(15)
);

CREATE TABLE tbl_book (
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(255) NOT NULL,
    book_PublisherName VARCHAR(100),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE tbl_book_copies (
    book_copies_CopyID INT AUTO_INCREMENT PRIMARY KEY,
    book_copies_BookID INT NOT NULL,
    book_copies_BranchID INT NOT NULL,
    book_copies_No_Of_Copies INT NOT NULL,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE tbl_borrower (
    borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    borrower_BorrowName VARCHAR(100) NOT NULL,
    borrower_BorrowAddress VARCHAR(255),
    borrower_BorrowPhone VARCHAR(15)
);

CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT NOT NULL,
    book_loans_BranchID INT NOT NULL,
    book_loans_CardNo INT NOT NULL,
    book_loans_DateOut DATE NOT NULL,
    book_loans_DueDate DATE NOT NULL,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(100) NOT NULL,
    library_branch_BranchAddress VARCHAR(255)
);

-- 1.How many copies of the book titles "The lost tribe" are owned by the library branch whose name is "Sharpstown"? --
SELECT SUM(book_copies_No_Of_Copies) AS Total_Copies
FROM tbl_book_copies
JOIN tbl_book ON tbl_book_copies.book_copies_BookID = tbl_book.book_BookID
JOIN tbl_library_branch ON tbl_book_copies.book_copies_BranchID = tbl_library_branch.library_branch_BranchID
WHERE tbl_book.book_Title = 'The Lost Tribe'
  AND tbl_library_branch.library_branch_BranchName = 'Sharpstown';
  
-- 2.How many copies of the book titled "The lost tribe" are owned by each library branch? --
SELECT 
    tbl_library_branch.library_branch_BranchName AS Branch_Name,
    SUM(tbl_book_copies.book_copies_No_Of_Copies) AS Total_Copies
FROM tbl_book_copies
JOIN tbl_book 
    ON tbl_book_copies.book_copies_BookID = tbl_book.book_BookID
JOIN tbl_library_branch 
    ON tbl_book_copies.book_copies_BranchID = tbl_library_branch.library_branch_BranchID
WHERE tbl_book.book_Title = 'The Lost Tribe'
GROUP BY tbl_library_branch.library_branch_BranchName;

-- 3.Retrieve the names of all borrowers who do not have any books checked out.--
SELECT 
    tbl_borrower.borrower_BorrowName AS Borrower_Name
FROM tbl_borrower
LEFT JOIN tbl_book_loans 
    ON tbl_borrower.borrower_CardNo = tbl_book_loans.book_loans_CardNo
WHERE tbl_book_loans.book_loans_LoansID IS NULL;

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18,retrieve the book title,the borrower's name,and the borrower's address. --
SELECT 
    tbl_book.book_Title AS Book_Title,
    tbl_borrower.borrower_BorrowName AS Borrower_Name,
    tbl_borrower.borrower_BorrowAddress AS Borrower_Address
FROM tbl_book_loans
JOIN tbl_book 
    ON tbl_book_loans.book_loans_BookID = tbl_book.book_BookID
JOIN tbl_borrower 
    ON tbl_book_loans.book_loans_CardNo = tbl_borrower.borrower_CardNo
JOIN tbl_library_branch 
    ON tbl_book_loans.book_loans_BranchID = tbl_library_branch.library_branch_BranchID
WHERE tbl_library_branch.library_branch_BranchName = 'Sharpstown'
  AND tbl_book_loans.book_loans_DueDate = '2018-02-03';
  
-- 5.For each library branch,retrieve the branch name and the total number of books loaned out from that branch.--
SELECT 
    tbl_library_branch.library_branch_BranchName AS BranchName,
    COUNT(tbl_book_loans.book_loans_LoansID) AS TotalBooksLoaned
FROM 
    tbl_library_branch
LEFT JOIN 
    tbl_book_loans ON tbl_library_branch.library_branch_BranchID = tbl_book_loans.book_loans_BranchID
GROUP BY 
    tbl_library_branch.library_branch_BranchID, tbl_library_branch.library_branch_BranchName;
    
-- 6.Retrieve the names,addresses,and number of books checked out for all borrowers who have more than five books checked out. --
SELECT 
    br.borrower_BorrowName AS Borrower_Name,
    br.borrower_BorrowAddress AS Borrower_Address,
    COUNT(bl.book_loans_LoansID) AS Books_Checked_Out
FROM tbl_borrower br
JOIN tbl_book_loans bl 
    ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_CardNo
HAVING COUNT(bl.book_loans_LoansID) > 5;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central". --
SELECT 
    b.book_Title AS Book_Title,
    bc.book_copies_No_Of_Copies AS Copies_Owned
FROM tbl_book_authors ba
JOIN tbl_book b 
    ON ba.book_authors_BookID = b.book_BookID
JOIN tbl_book_copies bc 
    ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE ba.book_authors_AuthorName = 'Stephen King'
  AND lb.library_branch_BranchName = 'Central';







