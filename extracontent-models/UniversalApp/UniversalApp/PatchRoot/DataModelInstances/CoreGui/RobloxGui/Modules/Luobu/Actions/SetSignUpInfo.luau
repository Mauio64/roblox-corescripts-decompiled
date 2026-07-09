local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Action = require(Modules.Common.Action)
local ArgCheck = require(Modules.LuaApp.ArgCheck)

return Action(script.Name, function(p1, p2, p3, p4) -- line: 5
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "displayName")
	ArgCheck.isType(p2, "string", "voucher")
	ArgCheck.isType(p3, "string", "authMethod")
	ArgCheck.isType(p4, "string", "channelId")

	return {
		prefilledDisplayName = p1,
		signUpVoucher = p2,
		authMethod = p3,
		channelId = p4
	}
end)
