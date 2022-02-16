#' Update Games wiki page(s)
#'
#' `update_games()` updates piecepack wiki Games page(s) using `wikiput.pl`.
#'
#' You may need a wiki admin password to use this function,
#' any attempt at using this function with a `NULL` password failed.
#'
#' @inheritParams build_games
#' @param minor Is this a \sQuote{minor} wiki edit?
#' @param summary Summary for wiki edit
#' @param username Piecepack wiki username
#' @param password Piecepack wiki password
#' @param games If `NULL` (default) we update the "Games" wiki page.
#'              Otherwise we update the wiki page for each game in `games`
#'              using the wiki markup in the `txt` subdirectory of
#'              `tools::R_user_dir("ppwicker", "cache")`.
#'              Name needs to be the same as the wiki article URL.
#'
#' @export
update_games <- function(update = FALSE,
                         minor = FALSE,
                         summary = "Update Games page",
                         username = getOption("ppwicker_username"),
                         password = getOption("ppwicker_password"),
                         games = NULL) {

    stopifnot(!is.null(username))

    if (is.null(games)) {
        target <- paste0("https://ludism.org/ppwiki/", "GamesAlpha")
        text <- build_games(update = update)
        wikiput(text, target,
                minor = minor, summary = summary,
                username = username, password = password)
    } else {
        for (game in games) {
            target <- paste0("https://ludism.org/ppwiki/", game)
            cache_dir <- tools::R_user_dir("ppwicker", "cache")
            file <- file.path(cache_dir, "txt", game)
            text <- readLines(file)
            wikiput(text, target,
                    minor = minor, summary = summary,
                    username = username, password = password)
        }
    }
}

wikiput <- function(text, target, minor = FALSE, summary = NULL, username = NULL, password = NULL) {
    stopifnot(!missing(text) && !missing(target))
    command <- Sys.which("perl")
    args <- system.file("exec/wikiput.pl", package = "ppwicker")
    if (minor) args <- c(args, "-m")
    if (!is.null(summary)) args <- c(args, "-s", shQuote(summary))
    if (!is.null(username)) args <- c(args, "-u", username)
    if (!is.null(password)) args <- c(args, "-p", password)
    args <- c(args, target)
    system2(command, args, input = text)
}
