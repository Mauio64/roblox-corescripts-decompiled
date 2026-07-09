local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 10
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "SetLookFavorite expects lookId")
	ArgCheck.isType(p2, "boolean", "SetLookFavorite expects isFavorited")

	return {
		lookId = p1,
		isFavorited = p2
	}
end)
