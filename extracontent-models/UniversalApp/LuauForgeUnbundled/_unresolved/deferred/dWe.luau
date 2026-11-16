local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Rodux")

local module2 = require("@luauforge/deferred/dWf")
local module3 = require("@luauforge/deferred/dWj")

return function()
	return Rodux.combineReducers({ Inspect = module2, ItemAssets = module3 })
end
