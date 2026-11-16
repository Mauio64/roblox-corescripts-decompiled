local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/AppCommonLib").Immutable

local requestMultiplePlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Actions").RequestMultiplePlaceInfos
local failedToFetchMultiplePlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Actions").FailedToFetchMultiplePlaceInfos
local receivedMultiplePlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Actions").ReceivedMultiplePlaceInfos

return function(options, data)
	local v5 = options or {}

	if data.type == requestMultiplePlaceInfos.name then
		local placeIdSet = {}

		for i, placeId in ipairs(data.placeIds) do
			placeIdSet[placeId] = true
		end

		return immutable.JoinDictionaries(v5, placeIdSet)
	elseif data.type == receivedMultiplePlaceInfos.name then
		local v6 = {}

		for i, placeInfo in ipairs(data.placeInfos) do
			v6[placeInfo.placeId] = false
		end

		return immutable.JoinDictionaries(v5, v6)
	else
		if data.type ~= failedToFetchMultiplePlaceInfos.name then
			return v5
		end

		local v6 = {}

		for i, placeId in ipairs(data.placeIds) do
			v6[placeId] = false
		end

		return immutable.JoinDictionaries(v5, v6)
	end
end
