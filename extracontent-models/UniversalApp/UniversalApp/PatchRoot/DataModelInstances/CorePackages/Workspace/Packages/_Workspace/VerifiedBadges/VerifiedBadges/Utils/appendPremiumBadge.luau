local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local constants = require(VerifiedBadges.constants)

local function appendPremiumBadge(s1: string) -- line: 9
	-- upvalues: constants (copy)
	return s1 .. constants.PREMIUM_EMOJI
end

return appendPremiumBadge
