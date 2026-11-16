local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("GameInvite").Parent

local Http = require(parent.Http)
local Url = Http.Url

game:DefineFastFlag("LuaAppExperienceJoinIdempotencyKey", false)

return function(callback, recipientUserId: string, placeId: string, trigger: string, inviteMessageId: string?, launchData: string?)
	local idempotencyKey

	if game:GetFastFlag("LuaAppExperienceJoinIdempotencyKey") then
		idempotencyKey = HttpService:GenerateGUID(false)
	end

	local jsonEncode = HttpService:JSONEncode({
		recipientUserId = recipientUserId,
		inviteMessageId = inviteMessageId,
		placeId = placeId,
		launchData = launchData,
		trigger = trigger,
		idempotencyKey = idempotencyKey
	})

	return callback(string.format("%snotifications/v1/send-experience-invite", Url.APIS_URL), "POST", {
		postBody = jsonEncode
	})
end
