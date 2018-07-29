# iTunesSearchApp
Interface for iTunesSearch app.

## Application base
Application is based on iTunes Search API: https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/

## Requirements for this project

### Main screen

#### Search block:
Search input (term parameter). Functionality:
- On click keyboard shows up. It’s possible to finish editing by enter.
- Encoded before search
- On click keyboard shows up. It’s possible to finish editing by enter. Starts search with default options. After search is complete opens up “Search results screen”. If error occurred, then error shown in popup menu.
Advanced search. Open ups “advanced search screen” with prefilled default search options and search input.

#### Results block:
- If stored results exist:
  - 10 previous results. Click on result opens up prefilled “Search results screen”. If error occurred, then error shown in popup menu.
- Else:
  - no previous results.

### Search screen:
#### Search input 
Functionality:
(term parameter).
On click keyboard shows up. It’s possible to finish editing by enter.
Encoded before search
#### Params controls:
Show error message if required search options are not filled.
Options:
- Country (list of countries (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)). Required: yes. Default is US.
- Limit (integer). Required: No. Default value: 50. Range from 1 to 200. If request is out of bound it is replaced with valid value.
- Explicit (bool). Required: No.

#### Search button
starts search. After search is complete opens up “Search results screen”. If error occurred, then error shown in popup menu.

### Search results screen:
#### Sorting options:
- Sort by track name. Default option.
- Sort by artist name.
- Sort by price.

#### Results with scroll. Functionality:
- Preview:
  - Art preview. 60*60
  - Track (censored) name
  - Author (censored) name.
If item is clicked then “Song info screen opens up”
#### Return to search

### Song info:
#### Back.
Returns to results.
#### Track info:
- Artist name.
  - Open artist in itunes. Opens by view url.
- Collection name (censored). By tapping unreveal original name
  - Open collection in itunes. Opens by view url.
- Track name (censored). By tapping unreveal original name
  - Open track in itunes. Opens by view url.
- Prehear track.
- Artfork. Shows 100*100 artwork
- Price:
  - Collection price
  - Track price
- Explicit:
  - Collection explicitness
  - Track explicitness
- Disc info:
  - Disc count
  - Disc number
  - Track number
  - Track time
  - Country
  - Genre
