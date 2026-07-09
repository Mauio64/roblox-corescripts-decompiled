local Parent = script:FindFirstAncestor("UserProfiles").Parent
local VerifiedBadges = require(Parent.VerifiedBadges)

return function(s1: string, t1: {[any]: any}) -- line: 6
	-- upvalues: VerifiedBadges (copy)
	if t1.hasVerifiedBadge then
		return `{ s1 }{ VerifiedBadges.emoji.verified }`
	end

	if t1.hasPremiumMembership then
		return `{ s1 }{ VerifiedBadges.emoji.premium }`
	end

	return s1
end
