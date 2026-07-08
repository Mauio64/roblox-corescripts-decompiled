local Parent = script:FindFirstAncestor("ApolloPresence").Parent
local Cryo = require(Parent.Cryo)
local PresenceType = require(Parent.GraphQLServer).types.PresenceType
local t1 = {
	[PresenceType.Offline] = 0,
	[PresenceType.Online] = 1,
	[PresenceType.InGame] = 2,
	[PresenceType.InStudio] = 3
}
local v5 = Cryo.List.foldLeft(Cryo.Dictionary.keys(t1), function(p1, p2) -- line: 18
	-- upvalues: t1 (copy)
	p1[tostring(t1[p2])] = p2

	return p1
end, {})

local function convertToStringWithDefault(p3) -- line: 23
	if p3 then
		return (tostring(p3))
	end

	return ""
end

return {
	formatNumberToPresenceType = function(p4) -- line: 27
		-- upvalues: v5 (copy), PresenceType (copy)
		return p4 and v5[tostring(p4)] or PresenceType.Offline
	end,
	formatPresenceTypeToNumber = function(p5) -- line: 31
		-- upvalues: t1 (copy), PresenceType (copy)
		return p5 and t1[p5] or t1[PresenceType.Offline]
	end,
	formatUserPresence = function(t2: {[any]: any}) -- line: 58
		-- upvalues: v5 (copy), PresenceType (copy)
		local t3 = {
			id = t2.id
		}
		local userPresenceType

		if t2.userPresenceType then
			userPresenceType = t2.userPresenceType
		else
			local userPresenceNumber = t2.userPresenceNumber

			userPresenceType = userPresenceNumber and v5[tostring(userPresenceNumber)] or PresenceType.Offline
		end

		t3.userPresenceType = userPresenceType
		t3.lastLocation = t2.lastLocation or ""
		t3.lastOnline = t2.lastOnline or ""

		local gameId = t2.gameId

		t3.gameId = not gameId and "" or tostring(gameId)

		local placeId = t2.placeId

		t3.placeId = not placeId and "" or tostring(placeId)

		local rootPlaceId = t2.rootPlaceId

		t3.rootPlaceId = not rootPlaceId and "" or tostring(rootPlaceId)

		local universeId = t2.universeId

		t3.universeId = not universeId and "" or tostring(universeId)

		return t3
	end
}
