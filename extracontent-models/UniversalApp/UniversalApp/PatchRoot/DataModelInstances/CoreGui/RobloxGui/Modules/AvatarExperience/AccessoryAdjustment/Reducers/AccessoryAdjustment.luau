local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local scriptParent = script.Parent
local AdjustmentTypeSelected = require(scriptParent.AdjustmentTypeSelected)
local SelectedAccessory = require(scriptParent.SelectedAccessory)

return Rodux.combineReducers({
	AdjustmentTypeSelected = AdjustmentTypeSelected,
	SelectedAccessory = SelectedAccessory
})
