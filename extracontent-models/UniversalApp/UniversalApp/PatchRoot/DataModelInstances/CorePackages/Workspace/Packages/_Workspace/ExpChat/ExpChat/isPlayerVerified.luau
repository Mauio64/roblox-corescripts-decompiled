local ExpChat = script:FindFirstAncestor("ExpChat")
local getFFlagOverridePlayerVerifiedBadge = require(ExpChat.Flags.getFFlagOverridePlayerVerifiedBadge)
local getFStringWhitelistVerifiedUserId = require(ExpChat.Flags.getFStringWhitelistVerifiedUserId)

local function isPlayerVerified(p1) -- line: 16
	-- upvalues: getFFlagOverridePlayerVerifiedBadge (copy), getFStringWhitelistVerifiedUserId (copy)
	if getFFlagOverridePlayerVerifiedBadge() then
		return true
	end

	if tostring(p1.UserId) == getFStringWhitelistVerifiedUserId() then
		return true
	end

	return p1.HasVerifiedBadge
end

return isPlayerVerified
