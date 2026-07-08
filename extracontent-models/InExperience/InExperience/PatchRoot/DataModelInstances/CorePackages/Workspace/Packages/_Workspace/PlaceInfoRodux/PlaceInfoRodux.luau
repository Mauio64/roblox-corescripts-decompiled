local t1 = {
	FFlagUsePlaceInfoController = game:DefineFastFlag("UsePlaceInfoController2", false),
	FFlagUseUniverseVotesController = game:DefineFastFlag("UseUniverseVotesController", false)
}

return {
	Actions = require(script.Actions),
	Flags = t1,
	Models = require(script.Models),
	PlaceInfoController = if not t1.FFlagUsePlaceInfoController then nil else require(script.PlaceInfoController),
	UniverseVotesController = if not t1.FFlagUseUniverseVotesController then nil else require(script.UniverseVotesController),
	Reducers = require(script.Reducers),
	Thunks = require(script.Thunks)
}
