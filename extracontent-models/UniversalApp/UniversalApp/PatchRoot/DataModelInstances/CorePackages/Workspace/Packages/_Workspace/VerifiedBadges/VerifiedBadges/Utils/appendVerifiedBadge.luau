local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local constants = require(VerifiedBadges.constants)

local function appendVerifiedBadge(s1: string) -- line: 10
	-- upvalues: constants (copy)
	return s1 .. constants.VERIFIED_EMOJI
end

return appendVerifiedBadge
