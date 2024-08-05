--Some example queries for the DATABASE
--Add an author to database
INSERT INTO "authors"("name", "birth", "death")
VALUES ('Akira Toriyama', NULL, '1955-04-01', '2024-03-01');

--Add title to database
INSERT INTO "titles"("title", "chapters", "status", "type", "start_date", "end_date")
VALUES ('Dragon ball Z', 519, 'finished', 'manga', '1984-11-15', '1995-05-25');

--Find all the titles that includes given term
SELECT * FROM "titles"
WHERE "title" LIKE '%dragon ball%';

--Find all the titles having given genre
SELECT * FROM "titles"
WHERE "id" IN (
    SELECT "title_id" FROM "genres"
    WHERE "genre" = 'action'
);

--Find all the titles having average rating over given one and given genre
SELECT "id", "title", "chapters", "type", "start_date"
FROM "finished"
WHERE "id" IN (
    SELECT "average_title_ratings"."title_id" FROM "average_title_ratings"
    JOIN "genres" ON "genres"."title_id" = "average_title_ratings"."title_id"
    WHERE "avg_rated" > 6 AND "genre" = 'action'
);

--FInd all the titles written by a given author
SELECT * FROM "titles"
WHERE "id" IN (
    SELECT "title_id" FROM "authored" WHERE "author_id" = (
        SELECT "id" FROM "authors" WHERE "name" = 'Akira Toriyama'
    )
);


