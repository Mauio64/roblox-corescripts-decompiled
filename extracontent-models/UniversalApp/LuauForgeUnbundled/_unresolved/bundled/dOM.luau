local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dMc")

local module = require("@luauforge/bundled/dON")
local module2 = require("@luauforge/bundled/dNQ")
local module3 = require("@luauforge/bundled/dMZ")
local module4 = require("@luauforge/bundled/dNa")
require("@luauforge/bundled/dHL")

return Rodux.createReducer({}, {
	[module.name] = function(options, p2)
		local itemType = p2.itemType
		local itemTypesById = {}

		for k, id in p2.ids do
			itemTypesById[id] = itemType
		end

		return Cryo.Dictionary.join(options or {}, itemTypesById)
	end,
	[module3.name] = module4.isEnabled() and function(options, p2)
		local clone = table.clone(options or {})

		local outfit = module2.OutfitOrAsset.Outfit

		for k, outfit2 in p2.outfits do
			clone[k] = outfit
		end

		return clone
	end or nil
})
