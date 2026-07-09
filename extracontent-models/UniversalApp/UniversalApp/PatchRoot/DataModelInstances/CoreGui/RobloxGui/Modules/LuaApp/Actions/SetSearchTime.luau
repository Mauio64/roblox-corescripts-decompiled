local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(Modules.LuaApp.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 7
	-- upvalues: ArgCheck (copy)
	ArgCheck.isNonEmptyString(p1, "SetSearchTime: searchUuid")
	ArgCheck.isNonNegativeNumber(p2, "SetSearchTime: searchTime")

	return {
		searchUuid = p1,
		searchTime = p2
	}
end)
