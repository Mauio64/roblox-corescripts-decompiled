local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")
local module2 = require("@luauforge/bundled/dPc")
local reducerUtils = require("@luauforge/bundled/dHL").Utils.ReducerUtils

local module3 = require("@luauforge/bundled/dOs")

return Rodux.createReducer({}, {
	[module2.name] = function(p2, data)
		if module3() then
			module.isType(data.recommendationsType, "string", "recommendationsType must be a string.")
			module.isType(data.itemTypeId, "string", "itemTypeId must be a string.")
			module.isType(data.items, "table", "items data must be a table.")

			local recommendedItemsKey = reducerUtils.generateRecommendedItemsKey(
				data.itemTypeId,
				data.recommendationsType
			)
			local v6 = {}

			for k, item in data.items do
				local id = item.id
				local itemType = item.itemType

				if id and itemType then
					table.insert(v6, { itemId = tostring(id), itemType = itemType })
				end
			end

			return Cryo.Dictionary.join(p2, { [recommendedItemsKey] = v6 })
		else
			module.isType(data.itemTypeId, "string", "itemTypeId must be a string.")
			module.isType(data.items, "table", "items data must be a table.")

			local itemTypeId = data.itemTypeId

			local v6 = {}

			for k, item in data.items do
				local id = item.id

				if id then
					v6[#v6 + 1] = tostring(id)
				end
			end

			return Cryo.Dictionary.join(p2, { [itemTypeId] = v6 })
		end
	end
})
