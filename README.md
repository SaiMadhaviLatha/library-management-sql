# Library Management System (SQL)

## Project Overview
This project implements a **Library Management System** using SQL. It models a library’s operations including managing books, authors, publishers, borrowers, library branches, and book loans. The system uses relational database design principles and advanced SQL queries to maintain data integrity and provide insights into library activities.

## Technologies Used
- MySQL (or any SQL-based relational database)
- SQL (DDL and DML statements)
- Foreign key constraints and relational design

## Features
- Creation of multiple tables representing books, authors, publishers, borrowers, branches, and loans
- Enforcement of data integrity through foreign key constraints
- Complex queries to analyze:
  - Number of copies of books in each branch
  - Borrowers with and without active book loans
  - Book loan details by branch and due date
  - Borrower activity (number of books checked out)
- Scalable design suitable for real-world library management

## How to Use
1. Create the database and tables by running the provided SQL scripts.
2. Populate the tables with sample or real data.
3. Execute the sample queries included to retrieve meaningful information such as book availability and borrower activity.

## Sample Queries
- Count copies of a book in a specific branch
- List borrowers who currently have no books checked out
- Retrieve loan details for books due on a particular date

## Future Enhancements
- Add stored procedures and triggers for automated tasks
- Integrate with a front-end interface for easier interaction
- Implement user roles and permissions for security

## Acknowledgments
Special thanks to my mentors for their guidance and support throughout this project.
