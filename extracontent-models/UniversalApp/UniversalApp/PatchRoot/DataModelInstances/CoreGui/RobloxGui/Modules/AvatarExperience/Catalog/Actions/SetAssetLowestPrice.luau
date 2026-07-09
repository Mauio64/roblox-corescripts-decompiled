local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.makeActionCreator(script.Name, function(p1, n1: number) -- line: 14
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "assetId")
	ArgCheck.isType(n1, "number", "priceInRobux")

	return {
		assetId = p1,
		priceInRobux = n1
	}
end)
