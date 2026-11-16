local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")

local constants = require(VerifiedBadges.constants)

local function appendVerifiedBadge(p: string)
	return p .. constants.VERIFIED_EMOJI
end

return appendVerifiedBadge
