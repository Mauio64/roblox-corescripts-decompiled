local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "marketplaceFeeInfo")

	return {
		marketplaceFeeInfo = p1
	}
end)
