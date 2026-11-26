local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Http")

local v5 = {
	ABUSE_TYPE_PROFANITY = "ABUSE_CATEGORY_SWEARING",
	ABUSE_TYPE_PRIVACY_ASKING_FOR_PII = "ABUSE_CATEGORY_PERSONAL_QUESTION",
	ABUSE_TYPE_HARASSMENT = "ABUSE_CATEGORY_BULLYING",
	ABUSE_TYPE_DATING_AND_ROMANTIC_CONTENT = "ABUSE_CATEGORY_DATING",
	ABUSE_TYPE_CHEAT_AND_EXPLOITS = "ABUSE_CATEGORY_CHEATING",
	ABUSE_TYPE_SCAMMING = "ABUSE_CATEGORY_SCAMMING",
	ABUSE_TYPE_SEXUAL_CONTENT = "ABUSE_CATEGORY_INAPT_CONTENT",
	ABUSE_TYPE_REAL_LIFE_THREATS = "ABUSE_CATEGORY_REAL_LIFE_THREATS_AND_SUICIDE_THREATS",
	ABUSE_TYPE_OTHER = "ABUSE_CATEGORY_OTHER"
}
return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/AppChatNetworking/rodux/RoduxNetworking").POST("SubmitAppChatAbuseReport", function(callback, data)
	return callback(Http.Url.APIS_URL):path("abuse-reporting"):path("v1"):path("abuse-report"):body({
		abuseVector = "web_chat",
		category = v5[data.reportCategory] or "ABUSE_CATEGORY_OTHER",
		comment = not (string.len(data.comment) > 0) and " " or data.comment,
		custom = { COMMUNICATION_CHANNEL_ID = data.conversationId },
		submitterId = data.submitterUserId,
		targetIdStr = data.reportedUserId,
		targetType = "user"
	})
end)
