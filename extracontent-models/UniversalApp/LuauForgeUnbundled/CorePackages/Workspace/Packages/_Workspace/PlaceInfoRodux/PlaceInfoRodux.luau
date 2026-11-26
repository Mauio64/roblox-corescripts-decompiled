local v5 = {
	FFlagUsePlaceInfoController = game:DefineFastFlag("UsePlaceInfoController2", false),
	FFlagUseUniverseVotesController = game:DefineFastFlag("UseUniverseVotesController", false)
}

local v6 = {
	Actions = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Actions"),
	Flags = v5,
	Models = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Models"),
	PlaceInfoController = 0,
	UniverseVotesController = 0,
	Reducers = 0,
	Thunks = 0
}
local v7 = if v5.FFlagUsePlaceInfoController then require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/PlaceInfoController") else nil
v6.PlaceInfoController = v7

local v8 = if v5.FFlagUseUniverseVotesController then require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/UniverseVotesController") else nil
v6.UniverseVotesController = v8

v6.Reducers = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Reducers")
v6.Thunks = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Thunks")
return v6
