local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)
local RoduxNetworking = require(script.Parent.RoduxNetworking)
local t1 = {
	ABUSE_TYPE_PROFANITY = 3,
	ABUSE_TYPE_PRIVACY_ASKING_FOR_PII = 11,
	ABUSE_TYPE_HARASSMENT = 4,
	ABUSE_TYPE_DATING_AND_ROMANTIC_CONTENT = 7,
	ABUSE_TYPE_CHEAT_AND_EXPLOITS = 25,
	ABUSE_TYPE_SCAMMING = 6,
	ABUSE_TYPE_SEXUAL_CONTENT = 8,
	ABUSE_TYPE_REAL_LIFE_THREATS = 23,
	ABUSE_TYPE_OTHER = 2
}

return RoduxNetworking.POST(script.Name, function(p1, t2: {[any]: any}) -- line: 18
	-- upvalues: CHAT_PLATFORM_BASE_URL (copy), t1 (copy)
	return p1(CHAT_PLATFORM_BASE_URL):path("v1"):path("create-chat-abuse-report"):body({
		comment = not (string.len(t2.comment) > 0) and " " or t2.comment,
		reported_user_id = tonumber(t2.reportedUserId),
		report_category = t1[t2.reportCategory] or 1,
		conversation_id = t2.conversationId,
		entry_point = t2.entryPoint
	})
end)
