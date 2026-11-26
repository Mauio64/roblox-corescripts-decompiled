require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/ExperienceService/GameProtocolTypes")

local v5 = {}

function v5.new()
	return { referralPage = "LuaChat" }
end

function v5.fromPlaceId(placeId, isTeamTest)
	local v6 = v5.new()

	v6.placeId = placeId
	v6.isTeamTest = isTeamTest

	return v6
end

function v5.fromUserId(userId, placeId)
	local v6 = v5.new()
	v6.userId = userId
	v6.placeId = placeId
	return v6
end

function v5.fromPlaceInstance(placeId, gameInstanceId)
	local v6 = v5.new()

	v6.placeId = placeId
	v6.gameInstanceId = gameInstanceId

	return v6
end

function v5.fromConversationId(placeId, conversationId)
	local v6 = v5.new()

	v6.placeId = placeId
	v6.conversationId = conversationId

	return v6
end

function v5.fromParams(items)
	local result = v5.new()

	for k, item in pairs(items) do
		result[k] = item
	end

	return result
end

return v5
