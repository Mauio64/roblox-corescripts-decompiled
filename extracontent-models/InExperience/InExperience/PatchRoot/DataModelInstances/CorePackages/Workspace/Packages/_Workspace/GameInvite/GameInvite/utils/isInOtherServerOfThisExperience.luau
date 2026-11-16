local parent = script:FindFirstAncestor("GameInvite").Parent

local DataHydration = require(parent.DataHydration)

local isInThisServer = require(script.Parent.isInThisServer)

local InGame = DataHydration.Presence.PresenceEnums.PresenceType.InGame

local function isInThisUniverse(p, p2: string): boolean -- 1 equivalent call inferred from this helper
	return p2 ~= "" and p2 ~= "0" and p.universeId == p2
end

local function isInAnotherServer(p, p2: string): boolean -- 1 equivalent call inferred from this helper
	return p2 ~= "" and p.gameId ~= "" and not isInThisServer(p, p2)
end

local function isInOtherServerOfThisExperience(p, p2: string, p3: string)
	return p ~= nil and p.userPresenceType == InGame and isInThisUniverse(p, p2) and isInAnotherServer(p, p3) -- inferred equivalent call
end

return isInOtherServerOfThisExperience
