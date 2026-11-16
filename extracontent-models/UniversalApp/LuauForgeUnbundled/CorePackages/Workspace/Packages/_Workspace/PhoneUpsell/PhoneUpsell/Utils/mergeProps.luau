local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Cryo")

local function mergeProps(p2, p3)
	return Cryo.Dictionary.join(p2, p3)
end

return mergeProps
