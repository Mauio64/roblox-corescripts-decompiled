local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local ArgCheck = require(Modules.LuaApp.ArgCheck)

return makeActionCreator(script.Name, function(p1, p2) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "universeId")
	ArgCheck.isType(p2, "table", "developerProductStatusesTable")

	return {
		universeId = p1,
		developerProductStatuses = p2
	}
end)
