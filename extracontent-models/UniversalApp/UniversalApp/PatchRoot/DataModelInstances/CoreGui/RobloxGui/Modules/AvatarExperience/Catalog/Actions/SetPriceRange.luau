local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 9
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "number", "SetPriceRange expects minPrice")
	ArgCheck.isType(p2, "number", "SetPriceRange expects maxPrice")

	return {
		priceRange = {
			minPrice = p1,
			maxPrice = p2
		}
	}
end)
