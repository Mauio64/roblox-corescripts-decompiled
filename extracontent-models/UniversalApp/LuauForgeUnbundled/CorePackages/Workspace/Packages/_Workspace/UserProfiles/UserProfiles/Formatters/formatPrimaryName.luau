local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/VerifiedBadges")

return function(p2, p3)
	if p3.hasVerifiedBadge then
		return `{p2}{module.emoji.verified}`
	end

	if p3.hasPremiumMembership then
		return `{p2}{module.emoji.premium}`
	end

	return p2
end
