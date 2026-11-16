local PlaceInfoRodux = script:FindFirstAncestor("PlaceInfoRodux")
local parent = PlaceInfoRodux.Parent

local Actions = require(PlaceInfoRodux.Actions)
local ReceivedMultiplePlaceInfos = Actions.ReceivedMultiplePlaceInfos

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable

return function(options, p)
	local v = options or {}

	if p.type ~= ReceivedMultiplePlaceInfos.name then
		return v
	end

	local placeInfosByPlaceId = {}

	for _, placeInfo in ipairs(p.placeInfos) do
		placeInfosByPlaceId[placeInfo.placeId] = placeInfo
	end

	return (Immutable.JoinDictionaries(v, placeInfosByPlaceId))
end
