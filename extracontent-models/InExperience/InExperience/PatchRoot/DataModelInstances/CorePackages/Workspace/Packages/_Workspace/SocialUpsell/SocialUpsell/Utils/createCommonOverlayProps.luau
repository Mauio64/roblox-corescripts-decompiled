local parent = script:FindFirstAncestor("SocialUpsell").Parent

local Cryo = require(parent.Cryo)

local v = {}

return function(p, p2)
	local join = Cryo.Dictionary.join
	local isInExperience = if p2 then p2.isInExperience else false
	return join(p or v, { isInExperience = isInExperience })
end
