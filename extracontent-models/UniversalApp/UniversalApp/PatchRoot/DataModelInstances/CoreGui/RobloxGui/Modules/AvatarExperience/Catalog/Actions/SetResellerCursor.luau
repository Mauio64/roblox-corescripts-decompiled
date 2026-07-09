local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isTypeOrNil(p1, "string", "cursor")

	return {
		cursor = p1
	}
end)
