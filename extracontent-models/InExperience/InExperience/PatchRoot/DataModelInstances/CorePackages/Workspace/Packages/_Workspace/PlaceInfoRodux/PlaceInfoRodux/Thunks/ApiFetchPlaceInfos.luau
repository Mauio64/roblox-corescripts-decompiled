local PlaceInfoRodux = script:FindFirstAncestor("PlaceInfoRodux")
local parent = PlaceInfoRodux.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Functional = AppCommonLib.Functional
local Requests = require(PlaceInfoRodux.Requests)
local GetPlaceInfos = Requests.GetPlaceInfos

local Models = require(PlaceInfoRodux.Models)
local PlaceInfoModel = Models.PlaceInfoModel
local Actions = require(PlaceInfoRodux.Actions)
local ReceivedMultiplePlaceInfos = Actions.ReceivedMultiplePlaceInfos

return function(p, p2)
	return function(object)
		return GetPlaceInfos(p, p2):andThen(function(p3)
			local responseBody = p3.responseBody

			local mapped = Functional.Map(responseBody, function(p4)
				return PlaceInfoModel.fromWeb(p4)
			end)

			object:dispatch(ReceivedMultiplePlaceInfos(mapped))

			return mapped
		end):catch(function(p3)
			warn("ApiFetchlaceInfos failed with error code " .. tostring(p3.HttpError))
		end)
	end
end
