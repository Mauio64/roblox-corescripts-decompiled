local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentSliderType)

return Rodux.makeActionCreator(script.Name, function(p1, p2, p3, p4) -- line: 18
	return {
		position = p1,
		rotation = p2,
		scale = p3,
		itemId = p4
	}
end)
