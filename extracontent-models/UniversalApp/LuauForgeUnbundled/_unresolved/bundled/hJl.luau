local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/gNN")
local module2 = require("@luauforge/bundled/gNZ")
local module3 = require("@luauforge/bundled/gNO")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local v6 = p2[p3.searchUuid]

		if v6 then
			local items = v6.items
			local joined = Cryo.List.join(items, p3.searchInCatalog.items)
			p3.searchInCatalog.items = joined

			return Cryo.Dictionary.join(p2, { [p3.searchUuid] = p3.searchInCatalog })
		end

		return Cryo.Dictionary.join(p2, { [p3.searchUuid] = p3.searchInCatalog })
	end,
	[module2.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { [p3.searchUuid] = Cryo.None })
	end,
	[module3.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { [p3.searchUuid] = p3.searchInCatalog })
	end
})
