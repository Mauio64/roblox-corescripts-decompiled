local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/AppCommonLib").Immutable
local receivedPlacesInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/PlaceInfoRodux/Actions").ReceivedPlacesInfos

local convertUniverseIdToString = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/SharedFlags").ConvertUniverseIdToString

return function(options, p2)
	local v5 = options or {}

	if p2.type == receivedPlacesInfos.name then
		for k, placesInfo in pairs(p2.placesInfos) do
			local v6 = convertUniverseIdToString(placesInfo.universeId)

			v5 = immutable.Set(v5, v6, placesInfo)
		end
	end

	return v5
end
