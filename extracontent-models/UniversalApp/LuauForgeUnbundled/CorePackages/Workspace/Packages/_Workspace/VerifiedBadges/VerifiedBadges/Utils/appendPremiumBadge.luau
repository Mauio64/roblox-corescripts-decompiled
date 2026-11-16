local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/constants")

local function appendPremiumBadge(p2)
	return p2 .. constants.PREMIUM_EMOJI
end

return appendPremiumBadge
