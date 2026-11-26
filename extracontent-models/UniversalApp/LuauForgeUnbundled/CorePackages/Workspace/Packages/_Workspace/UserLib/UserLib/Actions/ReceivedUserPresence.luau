local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Rodux").makeActionCreator

local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Time").DateTime

return makeActionCreator("ReceivedUserPresence", function(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	local v5 = 0

	if p8 ~= nil then
		local v6 = dateTime.fromIsoDate(p8)

		if v6 ~= nil then
			v5 = v6:GetUnixTimestamp()
		end
	end

	return {
		userId = p2,
		presence = p3,
		lastLocation = p4,
		placeId = p5,
		rootPlaceId = p6,
		gameInstanceId = p7,
		lastOnline = v5,
		universeId = p9,
		previousUniverseId = p10
	}
end)
