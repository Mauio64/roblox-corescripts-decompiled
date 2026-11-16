local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/DataHydration")
local functional = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/AppCommonLib").Functional
local GamesMultigetPlaceDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GamesByPlaceId/GamesMultigetPlaceDetails")
local placeInfoModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/PlaceInfoRodux").Models.PlaceInfoModel
local receivedPlacesInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/PlaceInfoRodux").Actions.ReceivedPlacesInfos

local convertUniverseIdToString = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/SharedFlags").ConvertUniverseIdToString

return function(p2, list)
	return function(object)
		if list and #list ~= 0 then
			return GamesMultigetPlaceDetails(p2, list):andThen(function(p3)
				local responseBody = p3.responseBody

				local v5 = {}
				local mapped = functional.Map(responseBody, function(p4)
					local v6 = placeInfoModel.fromWeb(p4)
					local v7 = convertUniverseIdToString(v6.universeId)
					table.insert(v5, v7)
					return v6
				end)

				object:dispatch(receivedPlacesInfos(mapped))

				if #v5 > 0 then
					DataHydration.Game.getGameIconStore(false).getAndFetchGameIcons(v5)
				end

				return mapped
			end)
		end
	end
end
