local PlaceInfoRodux = script:FindFirstAncestor("PlaceInfoRodux")
local PlaceInfoRoduxParent = PlaceInfoRodux.Parent
local Immutable = require(PlaceInfoRoduxParent.AppCommonLib).Immutable
local RequestMultiplePlaceInfos = require(PlaceInfoRodux.Actions).RequestMultiplePlaceInfos
local FailedToFetchMultiplePlaceInfos = require(PlaceInfoRodux.Actions).FailedToFetchMultiplePlaceInfos
local ReceivedMultiplePlaceInfos = require(PlaceInfoRodux.Actions).ReceivedMultiplePlaceInfos

return function(p1, p2) -- line: 10
	-- upvalues: RequestMultiplePlaceInfos (copy), Immutable (copy), ReceivedMultiplePlaceInfos (copy), FailedToFetchMultiplePlaceInfos (copy)
	local v9 = p1 or {}

	if p2.type == RequestMultiplePlaceInfos.name then
		local t1 = {}

		for _, v in ipairs(p2.placeIds) do
			t1[v] = true
		end

		return Immutable.JoinDictionaries(v9, t1)
	end

	if p2.type == ReceivedMultiplePlaceInfos.name then
		local t2 = {}

		for _, v in ipairs(p2.placeInfos) do
			t2[v.placeId] = false
		end

		return Immutable.JoinDictionaries(v9, t2)
	end

	if p2.type == FailedToFetchMultiplePlaceInfos.name then
		local t3 = {}

		for _, v in ipairs(p2.placeIds) do
			t3[v] = false
		end

		return Immutable.JoinDictionaries(v9, t3)
	end

	return v9
end
