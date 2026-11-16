local PlaceInfoRodux = script:FindFirstAncestor("PlaceInfoRodux")
local parent = PlaceInfoRodux.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable

local Actions = require(PlaceInfoRodux.Actions)
local RequestMultiplePlaceInfos = Actions.RequestMultiplePlaceInfos
local Actions2 = require(PlaceInfoRodux.Actions)
local FailedToFetchMultiplePlaceInfos = Actions2.FailedToFetchMultiplePlaceInfos
local Actions3 = require(PlaceInfoRodux.Actions)
local ReceivedMultiplePlaceInfos = Actions3.ReceivedMultiplePlaceInfos

return function(options, data)
	local v = options or {}

	if data.type == RequestMultiplePlaceInfos.name then
		local placeIdSet = {}

		for _, placeId in ipairs(data.placeIds) do
			placeIdSet[placeId] = true
		end

		return Immutable.JoinDictionaries(v, placeIdSet)
	elseif data.type == ReceivedMultiplePlaceInfos.name then
		local v2 = {}

		for _, placeInfo in ipairs(data.placeInfos) do
			v2[placeInfo.placeId] = false
		end

		return Immutable.JoinDictionaries(v, v2)
	else
		if data.type ~= FailedToFetchMultiplePlaceInfos.name then
			return v
		end

		local v2 = {}

		for _, placeId in ipairs(data.placeIds) do
			v2[placeId] = false
		end

		return Immutable.JoinDictionaries(v, v2)
	end
end
