local parent = script:FindFirstAncestor("PhoneUpsell").Parent
local Cryo = require(parent.Cryo)

local function mergeProps(p, p2)
	return Cryo.Dictionary.join(p, p2)
end

return mergeProps
