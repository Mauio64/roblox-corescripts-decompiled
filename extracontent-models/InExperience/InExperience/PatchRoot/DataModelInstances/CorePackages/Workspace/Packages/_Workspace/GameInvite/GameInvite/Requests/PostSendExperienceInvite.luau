local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("GameInvite").Parent
local Url = require(Parent.Http).Url

game:DefineFastFlag("LuaAppExperienceJoinIdempotencyKey", false)

return function(p1, s1: string, s2: string, s3: string, s4: string?, s5: string?) -- line: 9
	-- upvalues: HttpService (copy), Url (copy)
	local json = HttpService:JSONEncode({
		recipientUserId = s1,
		inviteMessageId = s4,
		placeId = s2,
		launchData = s5,
		trigger = s3,
		idempotencyKey = if not game:GetFastFlag("LuaAppExperienceJoinIdempotencyKey") then nil else HttpService:GenerateGUID(false)
	})

	return p1(string.format("%snotifications/v1/send-experience-invite", Url.APIS_URL), "POST", {
		postBody = json
	})
end
