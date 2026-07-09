local PlaceInfoRodux = script:FindFirstAncestor("PlaceInfoRodux")
local PlaceInfoRoduxParent = PlaceInfoRodux.Parent
local ReceivedMultiplePlaceInfos = require(PlaceInfoRodux.Actions).ReceivedMultiplePlaceInfos
local Immutable = require(PlaceInfoRoduxParent.AppCommonLib).Immutable

return function(p1, p2) -- line: 9
	-- upvalues: ReceivedMultiplePlaceInfos (copy), Immutable (copy)
	local v7 = p1 or {}

	if p2.type == ReceivedMultiplePlaceInfos.name then
		local t1 = {}

		for _, v in ipairs(p2.placeInfos) do
			t1[v.placeId] = v
		end

		v7 = Immutable.JoinDictionaries(v7, t1)
	end

	return v7
end
