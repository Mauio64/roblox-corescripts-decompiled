local PlaceInfoRodux = script:FindFirstAncestor("PlaceInfoRodux")
local PlaceInfoRoduxParent = PlaceInfoRodux.Parent
local Immutable = require(PlaceInfoRoduxParent.AppCommonLib).Immutable
local ReceivedPlacesInfos = require(PlaceInfoRodux.Actions).ReceivedPlacesInfos
local ConvertUniverseIdToString = require(PlaceInfoRoduxParent.SharedFlags).ConvertUniverseIdToString

return function(p1, p2) -- line: 9
	-- upvalues: ReceivedPlacesInfos (copy), ConvertUniverseIdToString (copy), Immutable (copy)
	local v8 = p1 or {}

	if p2.type == ReceivedPlacesInfos.name then
		for _, v in pairs(p2.placesInfos) do
			local v11 = ConvertUniverseIdToString(v.universeId)

			v8 = Immutable.Set(v8, v11, v)
		end
	end

	return v8
end
