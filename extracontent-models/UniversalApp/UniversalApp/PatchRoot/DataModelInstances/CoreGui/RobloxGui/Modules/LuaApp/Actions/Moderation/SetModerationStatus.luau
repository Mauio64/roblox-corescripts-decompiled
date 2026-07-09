local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Action = require(Modules.Common.Action)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return Action(script.Name, function(p1) -- line: 13
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "boolean", "SetModerationStatus action expects `modStatus` to be a boolean")

	return {
		userModerated = p1
	}
end)
