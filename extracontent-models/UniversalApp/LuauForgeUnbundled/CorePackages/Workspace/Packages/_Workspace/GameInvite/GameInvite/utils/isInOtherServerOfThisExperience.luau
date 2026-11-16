local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/DataHydration")

local isInThisServer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/isInThisServer")

local inGame = DataHydration.Presence.PresenceEnums.PresenceType.InGame

local function isInThisUniverse(p2, p3): boolean
	return p3 ~= "" and p3 ~= "0" and p2.universeId == p3
end

local function isInAnotherServer(p2, p3): boolean
	return p3 ~= "" and p2.gameId ~= "" and not isInThisServer(p2, p3)
end

local function isInOtherServerOfThisExperience(data, p2, p3)
	local v5

	if data == nil or data.userPresenceType ~= inGame then
		v5 = false
	else
		v5 = not (p2 == "" or p2 == "0") and data.universeId == p2

		if v5 then
			v5 = not (p3 == "" or data.gameId == "") and not isInThisServer(data, p3)
		end
	end

	return v5
end

return isInOtherServerOfThisExperience
