local parent = script:FindFirstAncestor("GameInvite").Parent

require(parent.DataHydration)

local function isInThisServer(p, p2: string): boolean
	return p ~= nil and p2 ~= "" and p.gameId == p2
end

return isInThisServer
