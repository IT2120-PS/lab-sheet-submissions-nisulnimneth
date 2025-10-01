CREATE DATABASE Lab07

create table Movie (
title char(25) primary key,
year int,
length float,
language char(15),
type char(1),
directorName char (30)
);

insert into Movie values ('Avengers', 2018, 3 , 'English', 'F', 'Anthony Russo');
insert into Movie values ('Black Panther', 2018, 3, 'English', 'F', 'Ryan Coogler');
insert into Movie values ('Ghost in Shell', 2017, 2.5, 'English', 'D' ,'Rupert Sanders');
insert into Movie values ('Jurrasic World', 2018, 2.75, 'English', 'D', 'Colin Trevorrow');
insert into Movie values ('Passengers', 2016, 2.75, 'English', 'F', 'Morten Tyldum');
insert into Movie values ('Spider-man',2018, 2.5, 'English ','F', 'Jon Watts');

create table MovieStar
(
name char(30) primary key,
country varchar(40),
gender char(1),
birthdate date
);

insert into MovieStar values('Bryce Howard','America', 'F','3/2/1981');
insert into MovieStar values('Chadwick Boseman', 'America', 'M','11/29/1977');
insert into MovieStar values('Chris Pratt', 'England', 'M', '6/21/1979');
insert into MovieStar values('Jennifer Lawrence', 'America', 'F', '8/15/1990');
insert into MovieStar values('Robert Downey', 'America', 'M', '4/4/1963');
insert into MovieStar values('Scarlett Johansson', 'America', 'F', '11/22/1984');
insert into MovieStar values('Tom Holland', 'England', 'M', '6/1/1996');


create table StarsIn (
movieTitle char(25) foreign key references movie(title) ,
movieYear int ,
starname char (30) foreign key references movieStar(name),
role varchar (15),
Primary key(movieTitle,movieYear,starname)
)
insert into StarsIn values('Avengers',2018, 'Chadwick Boseman', 'lead');
insert into StarsIn values('Avengers', 2018, 'Robert Downey', 'lead');
insert into StarsIn values('Avengers ',2018, 'Scarlett Johansson' , 'lead');
insert into StarsIn values('Black Panther', 2018, 'Chadwick Boseman' , 'lead');
insert into StarsIn values('Black Panther ',2018, 'Robert Downey' , 'support');
insert into StarsIn values('Ghost in Shell', 2017, 'Scarlett Johansson' , 'lead');
insert into StarsIn values('Jurrasic World', 2018, 'Bryce Howard', ' lead');
insert into StarsIn values('Jurrasic World ',2018, 'Chris Pratt' , 'lead');
insert into StarsIn values('Passengers', 2016, 'Chris Pratt', ' lead');
insert into StarsIn values('Passengers', 2016, 'Jennifer Lawrence', ' lead');
insert into StarsIn values('Spider-man', 2018, 'Robert Downey', ' support');
insert into StarsIn values('Spider-man', 2018, 'Tom Holland' , 'lead');

create table Theater(
theaterName char(20) primary key,
country varchar(40),
city varchar(20),
capacity int
)

insert into Theater values ('Beverly', 'America', 'LA', 300);
insert into Theater values ('Cinnemaworld', 'Australia', 'Melbourne', 250);
insert into Theater values ('Electric', 'England', 'London', 275);
insert into Theater values ('Grand Rex', 'France', 'Paris', 300);
insert into Theater values ('Nitehawk', 'America', 'New York', 200);

create table Show(
showId int,
movieTitle char(25) foreign key references movie(title),
theaterName char(20) foreign key references Theater(theaterName),
datetime datetime,
ticketPrice real,
spectators int,
primary key(showId)
)

insert into Show values(1,'Spider-man', 'Electric', '1-Jan-2018',200, 275);
insert into Show values(2,'Spider-man', 'Grand Rex', '1-Jan-2018', 200, 200);
insert into Show values(3,'Avengers', 'Grand Rex', '1-Apr-2018', 200, 98);
insert into Show values(4,'Black Panther', 'Beverly', '1-Jan-2018', 200, 205);
insert into Show values(5,'Black Panther', 'Grand Rex', '1-Jan-2018',300, 300);
insert into Show values(6,'Passengers', 'Nitehawk', '1-Jan-2018', 200, 219);
insert into Show values(7,'Ghost in Shell', 'Cinnemaworld', '1-Jan-2018', 200, 101);
insert into Show values(8,'Black Panther', 'Grand Rex', '1-Jan-2018', 200, 200);
insert into Show values(9,'Jurrasic World', 'Cinnemaworld', '1-Jan-2018', 200, 188);
insert into Show values(10,'Black Panther', 'Nitehawk', '1-Jan-2018', 200, 219);
insert into Show values(11,'Jurrasic World','Nitehawk', '1-Jan-2018', 200, 176);

create table Booking (
ShowId int foreign key references Show(ShowId), 
CustName Char (50), 
numTickets int
primary key(ShowId,CustName)
)

insert into Booking values(1,'John Wicks',4);
insert into Booking values(1,'Anne Mary',2);

--Exercises 2

-- Add the rank attribute to the MovieStar table
ALTER TABLE MovieStar
ADD rank INT DEFAULT 0;

--a. Create a procedure to update a rank attribute based on the number of lead roles

CREATE PROCEDURE UpdateStarRanks
AS
BEGIN
    UPDATE MovieStar
    SET rank = (
        SELECT COUNT(*)
        FROM StarsIn
        WHERE StarsIn.starname = MovieStar.name
        AND LTRIM(role) = 'lead'
    );
END;

EXEC UpdateStarRanks

SELECT name, rank FROM MovieStar;

--b. Create a trigger to update the rank when a movie star appears in a new movie

CREATE TRIGGER UpdateRankOnNewRole
ON StarsIn
FOR INSERT
AS
BEGIN
    UPDATE ms
    SET rank = (
        SELECT COUNT(*)
        FROM StarsIn si
        WHERE si.starname = ms.name
        AND LTRIM(si.role) = 'lead'
    )
    FROM MovieStar ms
    INNER JOIN inserted i ON ms.name = i.starname;
END;

INSERT INTO StarsIn (movieTitle, movieYear, starname, role)
VALUES ('Avengers', 2018, 'Tom Holland', 'lead');

SELECT name, rank FROM MovieStar WHERE name = 'Tom Holland';