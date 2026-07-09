local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Action = require(Modules.Common.Action)
local ArgCheck = require(Modules.LuaApp.ArgCheck)

return Action(script.Name, function(p1) -- line: 5
	-- upvalues: ArgCheck (copy)
	return {
		disabled = ArgCheck.isType(p1, "boolean", "disabled")
	}
end)
