#' Download piecepack wiki game metadata
#'
#' `download_game_metadata()` downloads piecepack wiki game metadata.
#'
#' @param update If already downloaded previously, should we download again?
#' @param games Which games to download metadata for.
#'              If `NULL` (the default) download all of them.
#' @return Returns a (tibble) data frame of piecepack wiki game metadata.
#'         If no previous download or `update = TRUE` as a side effect
#'         we download piecepack wiki game metadata to `tools::R_user_dir("ppwicker", "cache")`.
#' @export
download_game_metadata <- function(update = FALSE, games = NULL) {
    cache_dir <- tools::R_user_dir("ppwicker", "cache")
    if (update) unlink(cache_dir)
    dir.create(cache_dir, showWarnings = FALSE)

    txt_dir <- file.path(cache_dir, "txt")
    dir.create(txt_dir, showWarnings = FALSE)

    games_file <- file.path(cache_dir, "games.html")
    if (update) {
        download.file("https://ludism.org/ppwiki/CategoryGame", games_file)
    }
    doc <- xml2::read_html(games_file)
    games_list <- xml2::xml_find_all(doc, "//li/a")
    links <- xml2::xml_attr(games_list, "href")
    links <- links[-grep("GameTemplate", links)]
    raw_links <- gsub("ppwiki", "ppwiki/raw", links)
    targets <- paste0(cache_dir, "/txt/", basename(raw_links))

    if (update) {
        for (i in seq_along(raw_links)) {
            if (!is.null(games) &&
                !(utils::URLdecode(basename(raw_links[i])) %in% utils::URLdecode(games)))
                next
            Sys.sleep(1) # don't hit ludism.org too hard all at once
            download.file(raw_links[i], targets[i])
        }
    }

    texts <- lapply(targets, readLines)
    names(texts) <- utils::URLdecode(basename(raw_links))

    extract <- function(x, pattern) {
        x <- str_flatten(x, " ")
        link_pipe_token <- "MMMMMMMMM" # Something that shouldn't exist in text naturally
        x <- str_replace(x,
                         "(\\[\\[[^|]*)[|]([^|]*\\]\\])",
                         paste0("\\1", link_pipe_token, "\\2"))
        pat <- str_glue("[|] *{pattern} *[|][^|]*[|]", pattern = pattern)
        str <- as.character(na.omit(str_extract(x, pattern = pat)))
        if (length(str) == 0) return(NA_character_)
        str <- str_split(str, "\\|")[[1]][3]
        str <- str_trim(str)
        str <- str_replace(str, link_pipe_token, "|")
        str
    }

    df <- tibble::tibble(name = names(texts), url=links)
    df$players <- sapply(texts, extract, pattern = "Players")
    df$length <- sapply(texts, extract, pattern = "Length")
    df$designer <- sapply(texts, extract, pattern = "Designer[s]*")
    df$version <- sapply(texts, extract, pattern = "Version")
    df$version_date <- sapply(texts, extract, pattern = "Version Date")
    df$license <- sapply(texts, extract, pattern = "Licen[cs]e")
    equipment <- sapply(texts, extract, pattern = "Equipment Required")
    bits <- sapply(texts, extract, pattern = "Required Bits")
    df$bits <- ifelse(is.na(equipment), bits, equipment)

    df <- df[order(tolower(df$name)), ]

    csv_file <- file.path(cache_dir, "games.csv")
    write.csv(df, csv_file, na = "", row.names = FALSE)

    df
}
