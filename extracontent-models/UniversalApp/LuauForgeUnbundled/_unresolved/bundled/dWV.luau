local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dWW")
local module2 = require("@luauforge/bundled/dWX")
local module3 = require("@luauforge/bundled/dWY")
local module4 = require("@luauforge/bundled/dWZ")

return Rodux.createReducer({ OrderedList = {}, RemovedList = {} }, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { OrderedList = p3.currentSort })
	end,
	[module2.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { OrderedList = {}, RemovedList = {} })
	end,
	[module3.name] = function(p2, p3)
		local removedList = p2.RemovedList or {}
		return Cryo.Dictionary.join(p2, {
			RemovedList = Cryo.Dictionary.join(removedList, {
				[p3.removedAssetId] = p3.removedAssetTypeId
			})
		})
	end,
	[module4.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { RemovedList = {} })
	end
})
