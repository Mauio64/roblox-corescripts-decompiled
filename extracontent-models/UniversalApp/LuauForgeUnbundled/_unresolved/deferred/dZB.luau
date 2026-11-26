local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Rodux")

local module2 = require("@luauforge/deferred/dZC")
local module3 = require("@luauforge/deferred/dZG")

return function()
	return Rodux.combineReducers({ Inspect = module2, ItemAssets = module3 })
end
