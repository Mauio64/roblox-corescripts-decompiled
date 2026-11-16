require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/DataHydration")

local function isInThisServer(p2, p3): boolean
	return p2 ~= nil and p3 ~= "" and p2.gameId == p3
end

return isInThisServer
