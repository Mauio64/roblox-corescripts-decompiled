local parent = script:FindFirstAncestor("UserLib").Parent

local SharedFlags = require(parent.SharedFlags)

local getFFlagOverridePlayerVerifiedBadge = SharedFlags.getFFlagOverridePlayerVerifiedBadge
local getFStringWhitelistVerifiedUserId = SharedFlags.getFStringWhitelistVerifiedUserId

local function isPlayerVerified(p)
	if getFFlagOverridePlayerVerifiedBadge() or tostring(p.UserId) == getFStringWhitelistVerifiedUserId() then
		return true
	end

	return p.HasVerifiedBadge ~= nil and p.HasVerifiedBadge
end

return isPlayerVerified
