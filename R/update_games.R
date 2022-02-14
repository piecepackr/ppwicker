#' Update Games wiki page
#'
#' `update_games()` updates piecepack wiki Games page.
#'
#' @inheritParams build_games
#' @param minor Is this a \sQuote{minor} wiki edit?
#' @param summary Summary for wiki edit
#' @param username Piecepack wiki username
#' @param password Piecepack wiki password (optional)
#'
#' @export
update_games <- function(update = FALSE,
                         minor = FALSE,
                         summary = "Update Games page",
                         username = getOption("ppwicker_username"),
                         password = getOption("ppwicker_password")) {

    stopifnot(!is.null(username))

    text <- build_games(update = update)
    wikiput(text, "https://ludism.org/ppwiki/GamesAlpha",
            minor = minor, summary = summary,
            username = username, password = password)
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
