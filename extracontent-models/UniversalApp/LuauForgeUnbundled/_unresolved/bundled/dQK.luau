local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

local module2 = require("@luauforge/bundled/dQL")

local module3 = require("@luauforge/bundled/dQM")

return Rodux.createReducer({}, {
	[module2.name] = function(p2, data)
		module.isType(data.collectibleItemId, "string", "collectibleItemId must be a string.")
		module.isType(data.resaleParametersInfo, "table", "resaleParametersInfo must be a table.")

		local collectibleItemId = data.collectibleItemId

		local v6 = module3.fromGetCollectibleMarketplaceResaleParameters(
			data.resaleParametersInfo,
			data.itemSubTypeNameString
		)

		local v7 = p2[collectibleItemId]

		if not v7 then
			return (Cryo.Dictionary.join(p2, { [collectibleItemId] = v6 }))
		end

		local joined = Cryo.Dictionary.join(v7, v6)
		return (Cryo.Dictionary.join(p2, { [collectibleItemId] = joined }))
	end
})
