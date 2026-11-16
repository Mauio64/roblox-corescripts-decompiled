local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

require("@luauforge/bundled/dPH")

local function useDoesCatalogCategoryExist(p2, p3, p4)
	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p5): boolean
			local categoriesMap = p2.getCategoriesMap(p5)

			if not p3 then
				return false
			end

			local category = categoriesMap[p3]

			if not category then
				return false
			end

			if not p4 then
				return true
			end

			return category.SubcategoriesMap ~= nil and category.SubcategoriesMap[p4] ~= nil
		end)
	end, { p3, p4 })

	return SignalsReact.useSignalState(v5)
end

return useDoesCatalogCategoryExist
