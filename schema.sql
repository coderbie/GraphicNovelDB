
--Represents author of the graphic novel
CREATE TABLE "authors" (
    "id" INTEGER,
    "name" TEXT,
    "birth" NUMERIC,
    "death" NUMERIC,
    PRIMARY KEY("id")
);

--Represents illustrator of the graphic novel
CREATE TABLE "illustrators" (
    "id" INTEGER,
    "name" TEXT,
    "birth" NUMERIC,
    "death" NUMERIC,
    PRIMARY KEY("id")
);

--Represents information about a graphic novel
CREATE TABLE "titles" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "chapters" INTEGER NOT NULL CHECK("chapters" > 0),
    "status" TEXT NOT NULL CHECK("status" IN ('ongoing', 'finished')),
    "type" TEXT CHECK("type" IN ('western comic', 'manga', 'manhwa')),
    "start_date" NUMERIC NOT NULL,
    "end_date" NUMERIC,
    PRIMARY KEY("id")
);

--Tells which author wrote which graphic novel
CREATE TABLE "authored" (
    "author_id" INTEGER,
    "title_id" INTEGER,
    PRIMARY KEY("author_id", "title_id"),
    FOREIGN KEY("author_id") REFERENCES "authors"("id"),
    FOREIGN KEY("title_id") REFERENCES "titles"("id")
);

--Tells which illustrator illustrated which graphic novel
CREATE TABLE "illustrated" (
    "illustrator_id" INTEGER,
    "title_id" INTEGER,
    PRIMARY KEY("illustrator_id", "title_id"),
    FOREIGN KEY("illustrator_id") REFERENCES "illustrators"("id"),
    FOREIGN KEY("title_id") REFERENCES "titles"("id")
);

--Shows all the ratings a graphic novel have
CREATE TABLE "ratings" (
    "title_id" INTEGER,
    "rated" INTEGER NOT NULL CHECK("rated" >= 0),
    FOREIGN KEY("title_id") REFERENCES "titles"("id")
);

--Tells which graphic novel is of which genre
CREATE TABLE "genres" (
    "title_id" INTEGER,
    "genre" TEXT NOT NULL,
    FOREIGN KEY("title_id") REFERENCES "titles"("id")
);

--Represents all the graphic novels which are currently ongoing
CREATE VIEW "ongoing" AS
SELECT "id", "title", "chapters", "type", "start_date"
FROM "titles"
WHERE "status" = 'ongoing';

--Represents all the graphic novels which is finished
CREATE VIEW "finished" AS
SELECT "id", "title", "chapters", "type", "start_date", "end_date"
FROM "titles"
WHERE "status" = 'finished';

--Tells the average rating a title have
CREATE VIEW "average_title_ratings" AS
SELECT "title_id", "title", "chapters", "status", ROUND(AVG("rated"), 2) AS "avg_rated"
FROM "titles"
JOIN "ratings" ON "ratings"."title_id" = "titles"."id"
GROUP BY "title_id";

--Indexes for optimized search
CREATE INDEX "search_titles_by_title" ON "titles"("title");
CREATE INDEX "search_authors_by_name" ON "authors"("name");
CREATE INDEX "search_by_genre" ON "genres"("genre");
CREATE INDEX "search_illustrators_by_name" ON "illustrators"("name");
