local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Http").Url

game:DefineFastFlag("LuaAppExperienceJoinIdempotencyKey", false)

return function(callback, p2, p3, p4, p5, p6)
	local v7 = if game:GetFastFlag("LuaAppExperienceJoinIdempotencyKey") then HttpService:GenerateGUID(false) else nil
	local jsonEncode = HttpService:JSONEncode({
		recipientUserId = p2,
		inviteMessageId = p5,
		placeId = p3,
		launchData = p6,
		trigger = p4,
		idempotencyKey = v7
	})

	return callback(string.format("%snotifications/v1/send-experience-invite", url.APIS_URL), "POST", {
		postBody = jsonEncode
	})
end
