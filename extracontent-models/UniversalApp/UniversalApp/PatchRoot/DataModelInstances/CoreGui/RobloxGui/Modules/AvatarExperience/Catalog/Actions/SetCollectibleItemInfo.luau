local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "SetCollectibleItemInfo expects collectibleItemId")
	ArgCheck.isType(p2, "table", "SetCollectibleItemInfo expects collectibleItemData")

	return {
		collectibleItemId = p1,
		collectibleItemData = p2
	}
end)
