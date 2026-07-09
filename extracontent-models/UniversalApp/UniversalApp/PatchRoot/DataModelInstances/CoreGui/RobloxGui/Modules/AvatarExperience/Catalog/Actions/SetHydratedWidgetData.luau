local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 13
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "payload")

	return {
		payload = p1
	}
end)
