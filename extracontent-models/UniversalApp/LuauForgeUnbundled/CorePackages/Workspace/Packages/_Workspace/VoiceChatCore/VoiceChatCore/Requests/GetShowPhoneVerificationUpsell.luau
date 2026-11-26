local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Constants")

return function(callback, value, p2, p3)
	assert(
		type(value) == "string",
		"GetShowPhoneVerificationUpsell request expects universeId to be a string"
	)

	local v5 = string.format(
		"%s/v1/phone-verification/configuration?layerName=%s&experienceId=%s",
		Constants.UPSELL_CARD_URL,
		p2,
		value
	)

	if p3 and p3 > 0 then
		v5 ..= "&sessionStartTime=" .. p3
	end

	return callback(v5, "GET")
end
