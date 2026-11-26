local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dWN")
local module2 = require("@luauforge/bundled/dWQ")

local fFlagAXUseSignalsForAdjustmentTypeSelected = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForAdjustmentTypeSelected

local combineReducers = Rodux.combineReducers

if fFlagAXUseSignalsForAdjustmentTypeSelected then
	module = nil
end

return combineReducers({ AdjustmentTypeSelected = module, SelectedAccessory = module2 })
