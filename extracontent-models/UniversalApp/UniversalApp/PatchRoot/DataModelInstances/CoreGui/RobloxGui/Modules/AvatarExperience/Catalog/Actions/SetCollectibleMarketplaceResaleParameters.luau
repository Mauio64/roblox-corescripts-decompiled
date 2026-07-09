local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "SetCollectibleMarketplaceResaleParameters action expects collectibleItemId to be a string")
	ArgCheck.isType(p2, "table", "SetCollectibleMarketplaceResaleParameters action expects resaleParametersInfo to be a table")

	return {
		collectibleItemId = p1,
		resaleParametersInfo = p2,
		itemSubTypeNameString = p3
	}
end)
