local module = require("@luauforge/deferred/dWg")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Rodux")

local module3 = require("@luauforge/deferred/dWh")
local module4 = require("@luauforge/deferred/dWi")

return Rodux.createReducer({ IsOpen = false, AssetIds = {} }, {
	[module3.name] = function(p2, p3)
		return module.Dictionary.join(p2, { IsOpen = false })
	end,
	[module4.name] = function(p2, p3)
		return module.Dictionary.join(p2, { IsOpen = true, AssetIds = p3.assetIds })
	end
})
