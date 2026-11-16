local flags = {
	FFlagUsePlaceInfoController = game:DefineFastFlag("UsePlaceInfoController2", false),
	FFlagUseUniverseVotesController = game:DefineFastFlag("UseUniverseVotesController", false)
}

local PlaceInfoRodux = {
	Actions = require(script.Actions),
	Flags = flags,
	Models = require(script.Models),
	PlaceInfoController = 0,
	UniverseVotesController = 0,
	Reducers = 0,
	Thunks = 0
}
local placeInfoController

if flags.FFlagUsePlaceInfoController then
	placeInfoController = require(script.PlaceInfoController)
end

PlaceInfoRodux.PlaceInfoController = placeInfoController
local universeVotesController

if flags.FFlagUseUniverseVotesController then
	universeVotesController = require(script.UniverseVotesController)
end

PlaceInfoRodux.UniverseVotesController = universeVotesController

PlaceInfoRodux.Reducers = require(script.Reducers)
PlaceInfoRodux.Thunks = require(script.Thunks)
return PlaceInfoRodux
