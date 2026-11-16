local ExpChat = script:FindFirstAncestor("ExpChat")

local getFFlagOverridePlayerVerifiedBadge = require(ExpChat.Flags.getFFlagOverridePlayerVerifiedBadge)
local getFStringWhitelistVerifiedUserId = require(ExpChat.Flags.getFStringWhitelistVerifiedUserId)

local function isPlayerVerified(p)
	if getFFlagOverridePlayerVerifiedBadge() then
		return true
	end

	return tostring(p.UserId) == getFStringWhitelistVerifiedUserId() or p.HasVerifiedBadge
end

return isPlayerVerified
