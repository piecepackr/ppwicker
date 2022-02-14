ppwicker
========

``{ppwicker}`` is an R package to interact with the `piecepack wiki <https://ludism.org/ppwiki/>`_.

It has the following public functions:

1) ``download_game_metadata()`` downloads game metadata from the piecepack wiki
2) ``build_games()`` builds a candidate replacement for https://ludism.org/ppwiki/Games
3) ``update_games()`` updates https://ludism.org/ppwiki/Games

Installation
------------

.. code:: r

   install.packages("remotes")
   remotes::install_github("piecepackr/ppwicker")

License
-------

GPL Version 3
