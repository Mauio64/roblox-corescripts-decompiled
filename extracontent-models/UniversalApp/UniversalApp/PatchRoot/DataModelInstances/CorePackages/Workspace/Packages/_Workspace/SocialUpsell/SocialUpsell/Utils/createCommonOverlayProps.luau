local Parent = script:FindFirstAncestor("SocialUpsell").Parent
local Cryo = require(Parent.Cryo)
local t1 = {}

return function(p1, p2) -- line: 8
	-- upvalues: Cryo (copy), t1 (copy)
	return Cryo.Dictionary.join(p1 or t1, {
		isInExperience = not not p2 and p2.isInExperience
	})
end
