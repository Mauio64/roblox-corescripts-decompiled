local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 14
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "assetId")
	ArgCheck.isType(p2, "table", "assetResaleData")

	return {
		assetId = p1,
		assetResaleData = p2
	}
end)
