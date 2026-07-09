local Parent = script:FindFirstAncestor("ExpChat").Parent
local GetFFlagExpChatGuacChatDisabledReason = require(Parent.SharedFlags).GetFFlagExpChatGuacChatDisabledReason
local UniversalAppPolicy = nil

if GetFFlagExpChatGuacChatDisabledReason() then
	UniversalAppPolicy = require(Parent.UniversalAppPolicy)
end

return function() -- line: 12
	-- upvalues: GetFFlagExpChatGuacChatDisabledReason (copy), UniversalAppPolicy (ref)
	if not GetFFlagExpChatGuacChatDisabledReason() then
		return false
	end

	return UniversalAppPolicy.getAppFeaturePolicies().getExperienceChatAvailability() == "regionLocked"
end
