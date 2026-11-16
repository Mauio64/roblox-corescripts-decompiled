local parent = script.Parent.Parent
local GetFFlagEnablePerformPurchaseGCSHandling = require(parent.Flags.GetFFlagEnablePerformPurchaseGCSHandling)

function isGenericChallengeResponse(value)
	if type(value) ~= "string" then
		return false
	end

	local fFlagEnablePerformPurchaseGCSHandling = GetFFlagEnablePerformPurchaseGCSHandling()

	if fFlagEnablePerformPurchaseGCSHandling then
		if
			value:match("rblx%-challenge%-response") == nil
			or value:match("rblx%-challenge%-id") == nil
			or value:match("rblx%-challenge%-metadata") == nil
		then
			return false
		end

		return value:match("rblx%-challenge%-type") ~= nil
	end

	return fFlagEnablePerformPurchaseGCSHandling
end

return isGenericChallengeResponse
