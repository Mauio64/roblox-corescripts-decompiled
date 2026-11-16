local FFlagPeoplePageEnablePersonSignalStore = require(script.Parent.FFlagPeoplePageEnablePersonSignalStore)

return not FFlagPeoplePageEnablePersonSignalStore() and game:DefineFastFlag("PeopleCardsEnableVirtualizedGrid", false)
