local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local parent = GameDetailRodux.Parent

local DataHydration = require(parent.DataHydration)
local AppCommonLib = require(parent.AppCommonLib)
local Functional = AppCommonLib.Functional
local GamesMultigetPlaceDetails = require(GameDetailRodux.GamesByPlaceId.GamesMultigetPlaceDetails)
local PlaceInfoRodux = require(parent.PlaceInfoRodux)
local PlaceInfoModel = PlaceInfoRodux.Models.PlaceInfoModel
local PlaceInfoRodux2 = require(parent.PlaceInfoRodux)
local ReceivedPlacesInfos = PlaceInfoRodux2.Actions.ReceivedPlacesInfos

local SharedFlags = require(parent.SharedFlags)
local ConvertUniverseIdToString = SharedFlags.ConvertUniverseIdToString

return function(p, list)
	return function(object)
		if list and #list ~= 0 then
			return GamesMultigetPlaceDetails(p, list):andThen(function(p2)
				local responseBody = p2.responseBody

				local v = {}
				local mapped = Functional.Map(responseBody, function(p3)
					local v2 = PlaceInfoModel.fromWeb(p3)
					local convertUniverseIdToString = ConvertUniverseIdToString(v2.universeId)
					table.insert(v, convertUniverseIdToString)
					return v2
				end)

				object:dispatch(ReceivedPlacesInfos(mapped))

				if #v > 0 then
					DataHydration.Game.getGameIconStore(false).getAndFetchGameIcons(v)
				end

				return mapped
			end)
		end
	end
end
