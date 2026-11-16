local parent = script:FindFirstAncestor("ExpChat").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagExpChatGuacChatDisabledReason = SharedFlags.GetFFlagExpChatGuacChatDisabledReason
local UniversalAppPolicy

if GetFFlagExpChatGuacChatDisabledReason() then
	UniversalAppPolicy = require(parent.UniversalAppPolicy)
else
	UniversalAppPolicy = nil
end

return function(): boolean
	if GetFFlagExpChatGuacChatDisabledReason() then
		return UniversalAppPolicy.getAppFeaturePolicies().getExperienceChatAvailability() == "regionLocked"
	end

	return false
end
