local parent = script:FindFirstAncestor("UserProfiles").Parent

local VerifiedBadges = require(parent.VerifiedBadges)

return function(p: string, p2)
	if p2.hasVerifiedBadge then
		return `{p}{VerifiedBadges.emoji.verified}`
	end

	if p2.hasPremiumMembership then
		return `{p}{VerifiedBadges.emoji.premium}`
	end

	return p
end
