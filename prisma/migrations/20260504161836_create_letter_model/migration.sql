-- CreateEnum
CREATE TYPE "LetterStatus" AS ENUM ('DRAFT', 'PUBLISHED');

-- CreateEnum
CREATE TYPE "AnimationStyle" AS ENUM ('SEAL', 'TEAR', 'DELIVERY', 'BLUR');

-- CreateEnum
CREATE TYPE "ContentType" AS ENUM ('MAIN', 'HIDDEN', 'DELAYED', 'SECOND');

-- CreateEnum
CREATE TYPE "MusicSource" AS ENUM ('YOUTUBE', 'SPOTIFY', 'UPLOAD');

-- CreateEnum
CREATE TYPE "EffectType" AS ENUM ('CONFETTI', 'PETALS', 'STARS', 'RAIN');

-- CreateEnum
CREATE TYPE "EffectTrigger" AS ENUM ('END', 'DELAY');

-- CreateEnum
CREATE TYPE "MoodTag" AS ENUM ('LOVE', 'APOLOGY', 'GRATITUDE', 'CONFESSION', 'CELEBRATION');

-- CreateTable
CREATE TABLE "Letter" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "title" TEXT,
    "status" "LetterStatus" NOT NULL DEFAULT 'DRAFT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "editToken" TEXT NOT NULL,
    "viewToken" TEXT,
    "animationStyle" "AnimationStyle" NOT NULL,
    "themeId" TEXT,
    "isOneTimeOpen" BOOLEAN NOT NULL DEFAULT false,
    "unlockAt" TIMESTAMP(3),
    "moodTag" "MoodTag",

    CONSTRAINT "Letter_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LetterContent" (
    "id" TEXT NOT NULL,
    "letterId" TEXT NOT NULL,
    "type" "ContentType" NOT NULL,
    "content" TEXT NOT NULL,
    "delay" INTEGER,
    "orderIndex" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "LetterContent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Music" (
    "id" TEXT NOT NULL,
    "letterId" TEXT NOT NULL,
    "source" "MusicSource" NOT NULL,
    "url" TEXT NOT NULL,

    CONSTRAINT "Music_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Effect" (
    "id" TEXT NOT NULL,
    "letterId" TEXT NOT NULL,
    "type" "EffectType" NOT NULL,
    "trigger" "EffectTrigger" NOT NULL,

    CONSTRAINT "Effect_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QRCode" (
    "id" TEXT NOT NULL,
    "letterId" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "QRCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Theme" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "config" JSONB,

    CONSTRAINT "Theme_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Letter_slug_key" ON "Letter"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Letter_editToken_key" ON "Letter"("editToken");

-- CreateIndex
CREATE UNIQUE INDEX "Letter_viewToken_key" ON "Letter"("viewToken");

-- CreateIndex
CREATE UNIQUE INDEX "Music_letterId_key" ON "Music"("letterId");

-- CreateIndex
CREATE UNIQUE INDEX "QRCode_code_key" ON "QRCode"("code");

-- AddForeignKey
ALTER TABLE "Letter" ADD CONSTRAINT "Letter_themeId_fkey" FOREIGN KEY ("themeId") REFERENCES "Theme"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LetterContent" ADD CONSTRAINT "LetterContent_letterId_fkey" FOREIGN KEY ("letterId") REFERENCES "Letter"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Music" ADD CONSTRAINT "Music_letterId_fkey" FOREIGN KEY ("letterId") REFERENCES "Letter"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Effect" ADD CONSTRAINT "Effect_letterId_fkey" FOREIGN KEY ("letterId") REFERENCES "Letter"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QRCode" ADD CONSTRAINT "QRCode_letterId_fkey" FOREIGN KEY ("letterId") REFERENCES "Letter"("id") ON DELETE CASCADE ON UPDATE CASCADE;
