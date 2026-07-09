local PlaceInfoRodux = script:FindFirstAncestor("PlaceInfoRodux")
local PlaceInfoRoduxParent = PlaceInfoRodux.Parent
local Functional = require(PlaceInfoRoduxParent.AppCommonLib).Functional
local GetPlaceInfos = require(PlaceInfoRodux.Requests).GetPlaceInfos
local PlaceInfoModel = require(PlaceInfoRodux.Models).PlaceInfoModel
local ReceivedMultiplePlaceInfos = require(PlaceInfoRodux.Actions).ReceivedMultiplePlaceInfos

return function(p1, p2) -- line: 10
	-- upvalues: GetPlaceInfos (copy), Functional (copy), PlaceInfoModel (copy), ReceivedMultiplePlaceInfos (copy)
	return function(p3) -- line: 11
		-- upvalues: GetPlaceInfos (copy), p1 (copy), p2 (copy), Functional (copy), PlaceInfoModel (copy), ReceivedMultiplePlaceInfos (copy)
		return GetPlaceInfos(p1, p2):andThen(function(p4) -- line: 12
			-- upvalues: Functional (copy), PlaceInfoModel (copy), p3 (copy), ReceivedMultiplePlaceInfos (copy)
			local responseBody = p4.responseBody
			local v12 = Functional.Map(responseBody, function(p5) -- line: 15
				-- upvalues: PlaceInfoModel (copy)
				return PlaceInfoModel.fromWeb(p5)
			end)

			p3:dispatch(ReceivedMultiplePlaceInfos(v12))

			return v12
		end):catch(function(p6) -- line: 22
			warn("ApiFetchlaceInfos failed with error code " .. tostring(p6.HttpError))
		end)
	end
end
