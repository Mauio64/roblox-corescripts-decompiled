local GetFFlagEnablePerformPurchaseGCSHandling = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnablePerformPurchaseGCSHandling")

function LUAUFORGE_MODULE_GLOBALS_bdr_isGenericChallengeResponse(value)
	if type(value) ~= "string" then
		return false
	end

	local v5 = GetFFlagEnablePerformPurchaseGCSHandling()

	if v5 then
		if
			value:match("rblx%-challenge%-response") == nil
			or value:match("rblx%-challenge%-id") == nil
			or value:match("rblx%-challenge%-metadata") == nil
		then
			v5 = false
		else
			v5 = value:match("rblx%-challenge%-type") ~= nil
		end
	end

	return v5
end

return LUAUFORGE_MODULE_GLOBALS_bdr_isGenericChallengeResponse
