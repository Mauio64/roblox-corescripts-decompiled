local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Action = require(Modules.Common.Action)
local ArgCheck = require(Modules.LuaApp.ArgCheck)

return Action(script.Name, function(p1, p2, p3, p4) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isNonNegativeNumber(p1, "SetGlobalContextMenuInset: left")
	ArgCheck.isNonNegativeNumber(p2, "SetGlobalContextMenuInset: top")
	ArgCheck.isNonNegativeNumber(p3, "SetGlobalContextMenuInset: right")
	ArgCheck.isNonNegativeNumber(p4, "SetGlobalContextMenuInset: bottom")

	return {
		left = p1,
		top = p2,
		right = p3,
		bottom = p4
	}
end)
