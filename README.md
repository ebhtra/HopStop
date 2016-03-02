# HopStop

Beer info app for Udacity's iOS Development with Swift nanodegree

HopStop provides its user with the ability to search for beers by name or by brewery,
to save and delete selected beers to/from a watchlist, and to rate any of them.
The user can also view the brewer's notes/details on the beer, when provided,
and enter his/her own notes/details. All of these edits, ratings, and watchlist
changes are persisted onto the user's device using the patterns taught in Udacity's
iOS Persistence with Swift course.  The user can also browse interesting details
about the brewers of these beers, where provided.  All data is provided through
REST API calls to the BreweryDB (BreweryDB.com).

# User Experience

The initial screen consists of a search bar and an empty watchlist.  The user enters
search text and results are displayed in a table.  Selection of a search table row allows
the user the chance to save that beer to the watchlist.  Swiping a watchlist row allows 
for deletion. Selection of a watchlist row pushes a BeerDetail ViewController onto the 
navigation stack. On that second screen, the user can read and edit notes about the beer,
and rate it with a slider.  If the user wants to read about the brewer of the beer,
he/she can tap a button which pushes a third ViewController onto the stack.  

