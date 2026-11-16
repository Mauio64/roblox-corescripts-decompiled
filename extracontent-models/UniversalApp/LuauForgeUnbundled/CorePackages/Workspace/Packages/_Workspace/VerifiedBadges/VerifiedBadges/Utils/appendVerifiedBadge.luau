local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/constants")

local function appendVerifiedBadge(p2)
	return p2 .. constants.VERIFIED_EMOJI
end

return appendVerifiedBadge
