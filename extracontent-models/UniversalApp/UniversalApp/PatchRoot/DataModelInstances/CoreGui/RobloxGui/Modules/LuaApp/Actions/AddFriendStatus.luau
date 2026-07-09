local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return makeActionCreator(script.Name, function(p1, p2) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "Actions.AddFriendStatus.id")
	ArgCheck.isType(p2, "EnumItem", "Actions.AddFriendStatus.status")

	return {
		id = p1,
		status = p2
	}
end)
