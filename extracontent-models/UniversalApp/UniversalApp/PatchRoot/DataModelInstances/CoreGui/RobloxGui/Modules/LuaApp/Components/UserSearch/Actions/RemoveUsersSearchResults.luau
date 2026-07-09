local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return makeActionCreator(script.Name, function(s1: string) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(s1, "string", "Actions.RemoveUsersSearchResults.keyword")

	return {
		searchUuid = s1,
		keyword = s1
	}
end)
