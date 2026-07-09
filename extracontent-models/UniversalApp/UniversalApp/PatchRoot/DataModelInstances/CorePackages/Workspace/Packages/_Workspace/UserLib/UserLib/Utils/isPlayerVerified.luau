local Parent = script:FindFirstAncestor("UserLib").Parent
local SharedFlags = require(Parent.SharedFlags)
local getFFlagOverridePlayerVerifiedBadge = SharedFlags.getFFlagOverridePlayerVerifiedBadge
local getFStringWhitelistVerifiedUserId = SharedFlags.getFStringWhitelistVerifiedUserId

local function isPlayerVerified(t1: {[any]: any}) -- line: 27
	-- upvalues: getFFlagOverridePlayerVerifiedBadge (copy), getFStringWhitelistVerifiedUserId (copy)
	if getFFlagOverridePlayerVerifiedBadge() then
		return true
	end

	if tostring(t1.UserId) == getFStringWhitelistVerifiedUserId() then
		return true
	end

	if t1.HasVerifiedBadge ~= nil then
		return t1.HasVerifiedBadge
	end

	return false
end

return isPlayerVerified
