local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 20
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "expect assetId to be a string")
	ArgCheck.isType(p2, "table", "expect assetVersionData to be a table")

	return {
		assetId = p1,
		assetVersionData = p2
	}
end)
