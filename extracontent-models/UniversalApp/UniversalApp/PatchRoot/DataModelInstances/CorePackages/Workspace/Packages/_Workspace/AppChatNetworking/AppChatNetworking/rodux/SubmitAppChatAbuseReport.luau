local Parent = script:FindFirstAncestor("AppChatNetworking").Parent
local Http = require(Parent.Http)
local RoduxNetworking = require(script.Parent.RoduxNetworking)
local t1 = {
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

return RoduxNetworking.POST(script.Name, function(p1, t2: {[any]: any}) -- line: 22
	-- upvalues: Http (copy), t1 (copy)
	return p1(Http.Url.APIS_URL):path("abuse-reporting"):path("v1"):path("abuse-report"):body({
		abuseVector = "web_chat",
		targetType = "user",
		category = t1[t2.reportCategory] or t1.ABUSE_TYPE_OTHER,
		comment = not (string.len(t2.comment) > 0) and " " or t2.comment,
		custom = {
			COMMUNICATION_CHANNEL_ID = t2.conversationId
		},
		submitterId = t2.submitterUserId,
		targetIdStr = t2.reportedUserId
	})
end)
