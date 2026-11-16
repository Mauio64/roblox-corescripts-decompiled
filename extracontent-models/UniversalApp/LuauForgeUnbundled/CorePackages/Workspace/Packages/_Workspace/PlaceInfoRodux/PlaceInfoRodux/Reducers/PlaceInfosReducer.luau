local receivedMultiplePlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Actions").ReceivedMultiplePlaceInfos

local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/AppCommonLib").Immutable

return function(options, p2)
	local v5 = options or {}

	if p2.type ~= receivedMultiplePlaceInfos.name then
		return v5
	end

	local placeInfosByPlaceId = {}

	for i, placeInfo in ipairs(p2.placeInfos) do
		placeInfosByPlaceId[placeInfo.placeId] = placeInfo
	end

	v5 = immutable.JoinDictionaries(v5, placeInfosByPlaceId)

	return v5
end
