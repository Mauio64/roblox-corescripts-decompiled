local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local Cryo = require(Parent.Cryo)

local function mergeProps(p1, p2) -- line: 9
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.join(p1, p2)
end

return mergeProps
