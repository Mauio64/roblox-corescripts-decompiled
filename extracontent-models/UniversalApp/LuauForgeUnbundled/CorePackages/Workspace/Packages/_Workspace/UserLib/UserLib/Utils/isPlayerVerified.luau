local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SharedFlags")

local getFFlagOverridePlayerVerifiedBadge = SharedFlags.getFFlagOverridePlayerVerifiedBadge
local getFStringWhitelistVerifiedUserId = SharedFlags.getFStringWhitelistVerifiedUserId

local function isPlayerVerified(p2)
	if
		getFFlagOverridePlayerVerifiedBadge()
		or tostring(p2.UserId) == getFStringWhitelistVerifiedUserId()
	then
		return true
	end

	if p2.HasVerifiedBadge == nil then
		return false
	end

	return p2.HasVerifiedBadge
end

return isPlayerVerified
