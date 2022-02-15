#' Build candidate replacement for Games wiki page
#'
#' `build_games()` builds a candidate replacement for Games piecepack wiki page
#'
#' @inheritParams download_game_metadata
#' @return A character vector with the text for the candidate replacement for Games wiki page.
#'         As a side effect also saves to
#'         `file.path(tools::R_user_dir("ppwicker", "cache"), "games.creole")`.
#'
#' @export
build_games <- function(update = FALSE) {
    df <- download_game_metadata(update = update)

    creole_file <- file.path(tools::R_user_dir("ppwicker", "cache"),
                             "games.creole")

    header <- "|=Games|=Designer / Adapter|=Required Bits|"
    rows <- purrr::pmap(df, games_row)

    text <- c(games_preamble, header, unlist(rows))

    writeLines(text, creole_file)

    invisible(text)
}

games_row <- function(name, designer, bits, ...) {
    str_glue('| ["{name}"] | {designer} | {bits} |')
}

games_preamble <- '
**Note:** This is an alpha test for a new computer-generated [[Games]] page.
This page will eventually be deleted.

**Note:** This page is computer-generated from individual game metadata and manually uploaded to the wiki.
If outdated or any errors please let me know and I\'ll take a look.  --TrevorLDavis

For a complete list of games on the wiki, check the CategoryGame page.
The GamesStatistics spreadsheet with all the games makes it easy to get various statistics on the games.

----

The below are the games that have a description page on this Wiki.
To keep up with the latest games, see NewGames.
For curated lists of good games to play, see [[Competitions]], RecommendedGames, GamersDozen, FreeCulcha, and ["The_Infinite_Board_Game"].
You can also view lists of games sorted by

* NumberOfPlayers required for play
* TimeToPlay each game
* RequiredEquipment
* GameThemes
* GameMechanics

Also see games sorted by ["License"].

For a categorised list of piecepack games see TaxonomyOfPiecepackGames.

For a list of abstract games that you can play with a piecepack see GenericAbstracts.

----

'
