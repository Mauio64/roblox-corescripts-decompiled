local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloPresence/Cryo")

local presenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloPresence/GraphQLServer").types.PresenceType

local v5 = {
	[presenceType.Offline] = 0,
	[presenceType.Online] = 1,
	[presenceType.InGame] = 2,
	[presenceType.InStudio] = 3
}

local foldLeft = Cryo.List.foldLeft(Cryo.Dictionary.keys(v5), function(p2, p3)
	p2[tostring(v5[p3])] = p3
	return p2
end, {})

local function convertToStringWithDefault(p2)
	if p2 then
		return (tostring(p2))
	end

	return ""
end

return {
	formatNumberToPresenceType = function(p2)
		return p2 and foldLeft[tostring(p2)] or presenceType.Offline
	end,
	formatPresenceTypeToNumber = function(p2)
		return p2 and v5[p2] or v5[presenceType.Offline]
	end,
	formatUserPresence = function(data)
		local v6 = {
			id = data.id,
			userPresenceType = 0,
			lastLocation = 0,
			lastOnline = 0,
			gameId = 0,
			placeId = 0,
			rootPlaceId = 0,
			universeId = 0
		}
		local v7

		if data.userPresenceType then
			v7 = data.userPresenceType
		else
			local userPresenceNumber = data.userPresenceNumber
			v7 = userPresenceNumber and foldLeft[tostring(userPresenceNumber)] or presenceType.Offline
		end

		v6.userPresenceType = v7

		v6.lastLocation = data.lastLocation or ""
		v6.lastOnline = data.lastOnline or ""
		local gameId = data.gameId
		v6.gameId = not gameId and "" or tostring(gameId)
		local placeId = data.placeId
		v6.placeId = not placeId and "" or tostring(placeId)
		local rootPlaceId = data.rootPlaceId
		v6.rootPlaceId = not rootPlaceId and "" or tostring(rootPlaceId)
		local universeId = data.universeId
		v6.universeId = not universeId and "" or tostring(universeId)
		return v6
	end
}
