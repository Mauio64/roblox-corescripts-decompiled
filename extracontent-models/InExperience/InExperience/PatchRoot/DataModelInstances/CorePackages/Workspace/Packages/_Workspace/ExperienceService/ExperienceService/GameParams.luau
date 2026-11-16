require(script.Parent.GameProtocolTypes)

local GameParams = {}

function GameParams.new()
	return { referralPage = "LuaChat" }
end

function GameParams.fromPlaceId(placeId, isTeamTest: boolean?)
	local v = GameParams.new()

	v.placeId = placeId
	v.isTeamTest = isTeamTest

	return v
end

function GameParams.fromUserId(userId, placeId)
	local v = GameParams.new()
	v.userId = userId
	v.placeId = placeId
	return v
end

function GameParams.fromPlaceInstance(placeId, gameInstanceId: string)
	local v = GameParams.new()

	v.placeId = placeId
	v.gameInstanceId = gameInstanceId

	return v
end

function GameParams.fromConversationId(placeId, conversationId: string)
	local v = GameParams.new()

	v.placeId = placeId
	v.conversationId = conversationId

	return v
end

function GameParams.fromParams(items)
	local result = GameParams.new()

	for k, item in pairs(items) do
		result[k] = item
	end

	return result
end

return GameParams
