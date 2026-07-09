local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(Modules.LuaApp.ArgCheck)

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "SetNativeRobuxProducts: nativeRobuxProducts")

	return {
		nativeRobuxProducts = p1
	}
end)
