% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update_games.R
\name{update_games}
\alias{update_games}
\title{Update Games wiki page(s)}
\usage{
update_games(
  update = FALSE,
  minor = FALSE,
  summary = "Update Games page",
  username = getOption("ppwicker_username"),
  password = getOption("ppwicker_password"),
  games = NULL
)
}
\arguments{
\item{update}{If already downloaded previously, should we download again?}

\item{minor}{Is this a \sQuote{minor} wiki edit?}

\item{summary}{Summary for wiki edit}

\item{username}{Piecepack wiki username}

\item{password}{Piecepack wiki password}

\item{games}{If \code{NULL} (default) we update the "Games" wiki page.
Otherwise we update the wiki page for each game in \code{games}
using the wiki markup in the \code{txt} subdirectory of
\code{tools::R_user_dir("ppwicker", "cache")}.
Name needs to be the same as the wiki article URL.}
}
\description{
\code{update_games()} updates piecepack wiki Games page(s) using \code{wikiput.pl}.
}
\details{
You may need a wiki admin password to use this function,
any attempt at using this function with a \code{NULL} password failed.
}
