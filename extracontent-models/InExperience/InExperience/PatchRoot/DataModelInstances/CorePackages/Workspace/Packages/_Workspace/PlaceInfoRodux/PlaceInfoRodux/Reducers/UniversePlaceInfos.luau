local PlaceInfoRodux = script:FindFirstAncestor("PlaceInfoRodux")
local parent = PlaceInfoRodux.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local Actions = require(PlaceInfoRodux.Actions)
local ReceivedPlacesInfos = Actions.ReceivedPlacesInfos

local SharedFlags = require(parent.SharedFlags)
local ConvertUniverseIdToString = SharedFlags.ConvertUniverseIdToString

return function(options, p)
	local v = options or {}

	if p.type == ReceivedPlacesInfos.name then
		for _, placesInfo in pairs(p.placesInfos) do
			local convertUniverseIdToString = ConvertUniverseIdToString(placesInfo.universeId)

			v = Immutable.Set(v, convertUniverseIdToString, placesInfo)
		end
	end

	return v
end
