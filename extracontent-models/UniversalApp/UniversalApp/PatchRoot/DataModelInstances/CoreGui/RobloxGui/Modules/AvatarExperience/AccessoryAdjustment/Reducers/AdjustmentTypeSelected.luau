local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules
local SetAdjustmentType = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetAdjustmentType)
local AdjustmentType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentType)

return Rodux.createReducer(AdjustmentType.Position, {
	[SetAdjustmentType.name] = function(_, p2) -- line: 20
		return p2.adjustmentType
	end
})
