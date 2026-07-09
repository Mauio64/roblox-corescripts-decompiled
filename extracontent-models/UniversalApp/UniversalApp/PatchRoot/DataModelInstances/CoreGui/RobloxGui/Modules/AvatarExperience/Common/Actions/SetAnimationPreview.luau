local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(s1: string, s2: string) -- line: 11
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(s1, "string", "SetAnimationPreview: assetId")
	ArgCheck.isType(s2, "string", "SetAnimationPreview: assetTypeIdString")

	return {
		assetId = s1,
		assetTypeIdString = s2
	}
end)
