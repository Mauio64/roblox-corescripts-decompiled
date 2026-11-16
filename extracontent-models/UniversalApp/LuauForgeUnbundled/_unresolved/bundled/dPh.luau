local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dHL")

local module = require("@luauforge/bundled/dMx")
local module2 = require("@luauforge/bundled/dPi")
local module3 = require("@luauforge/bundled/dPj")
local module4 = require("@luauforge/bundled/dPk")
local module5 = require("@luauforge/bundled/dPl")

local module6 = require("@luauforge/bundled/dOc")

return Rodux.createReducer({}, {
	[module2.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { [p3.assetTypeId] = true })
	end,
	[module3.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { [p3.assetTypeId] = false })
	end,
	[module4.name] = function(p2, p3)
		if module6() then
			return Cryo.Dictionary.join(p2, { [p3.outfitType] = true })
		elseif p3.outfitType == module.OutfitTypes.DynamicHead then
			return Cryo.Dictionary.join(p2, {
				[module.NewDHOutfitNotificationKey] = true
			})
		else
			return Cryo.Dictionary.join(p2, { [module.NewOutfitNotificationKey] = true })
		end
	end,
	[module5.name] = function(p2, p3)
		if module6() then
			return Cryo.Dictionary.join(p2, { [p3.outfitType] = false })
		elseif p3.outfitType == module.OutfitTypes.DynamicHead then
			return Cryo.Dictionary.join(p2, {
				[module.NewDHOutfitNotificationKey] = false
			})
		else
			return Cryo.Dictionary.join(p2, {
				[module.NewOutfitNotificationKey] = false
			})
		end
	end
})
