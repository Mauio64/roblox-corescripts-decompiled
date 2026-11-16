local VoiceChatCore = script:FindFirstAncestor("VoiceChatCore")
local Constants = require(VoiceChatCore.Constants)

return function(callback, value: string, p: string, p2: number?)
	assert(type(value) == "string", "GetShowPhoneVerificationUpsell request expects universeId to be a string")

	local v = string.format(
		"%s/v1/phone-verification/configuration?layerName=%s&experienceId=%s",
		Constants.UPSELL_CARD_URL,
		p,
		value
	)

	if p2 and p2 > 0 then
		v ..= "&sessionStartTime=" .. p2
	end

	return callback(v, "GET")
end
