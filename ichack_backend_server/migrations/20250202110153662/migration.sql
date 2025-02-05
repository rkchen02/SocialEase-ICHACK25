BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sentence" (
    "id" bigserial PRIMARY KEY,
    "convoId" bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "sentence" text NOT NULL,
    "emotion" text NOT NULL
);


--
-- MIGRATION VERSION FOR ichack_backend
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('ichack_backend', '20250202110153662', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250202110153662', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
