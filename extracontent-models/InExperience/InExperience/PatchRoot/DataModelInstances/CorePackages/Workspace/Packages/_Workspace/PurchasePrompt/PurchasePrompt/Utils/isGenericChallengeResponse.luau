local ParentParent = script.Parent.Parent
local GetFFlagEnablePerformPurchaseGCSHandling = require(ParentParent.Flags.GetFFlagEnablePerformPurchaseGCSHandling)

function isGenericChallengeResponse(p1) -- line: 5
	-- upvalues: GetFFlagEnablePerformPurchaseGCSHandling (copy)
	if type(p1) ~= "string" then
		return false
	end

	return GetFFlagEnablePerformPurchaseGCSHandling() and (p1:match("rblx%-challenge%-response") ~= nil and (p1:match("rblx%-challenge%-id") ~= nil and (p1:match("rblx%-challenge%-metadata") ~= nil and p1:match("rblx%-challenge%-type") ~= nil)))
end

return isGenericChallengeResponse
