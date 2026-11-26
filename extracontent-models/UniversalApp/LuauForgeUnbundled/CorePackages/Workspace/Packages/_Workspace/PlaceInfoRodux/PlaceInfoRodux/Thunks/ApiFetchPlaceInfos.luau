local functional = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/AppCommonLib").Functional
local getPlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Requests").GetPlaceInfos

local placeInfoModel = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Models").PlaceInfoModel
local receivedMultiplePlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Actions").ReceivedMultiplePlaceInfos

return function(p2, p3)
	return function(object)
		return getPlaceInfos(p2, p3):andThen(function(p4)
			local responseBody = p4.responseBody

			local mapped = functional.Map(responseBody, function(p5)
				return placeInfoModel.fromWeb(p5)
			end)

			object:dispatch(receivedMultiplePlaceInfos(mapped))

			return mapped
		end):catch(function(p4)
			warn("ApiFetchlaceInfos failed with error code " .. tostring(p4.HttpError))
		end)
	end
end
