local VoiceChatCore = script:FindFirstAncestor("VoiceChatCore")
local Constants = require(VoiceChatCore.Constants)

return function(p1, s1: string, s2: string, n1: number?) -- line: 4
	-- upvalues: Constants (copy)
	assert(type(s1) == "string", "GetShowPhoneVerificationUpsell request expects universeId to be a string")

	local v7 = string.format("%s/v1/phone-verification/configuration?layerName=%s&experienceId=%s", Constants.UPSELL_CARD_URL, s2, s1)

	if n1 and n1 > 0 then
		v7 ..= "&sessionStartTime=" .. n1
	end

	return p1(v7, "GET")
end
