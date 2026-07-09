local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(Modules.LuaApp.ArgCheck)

return require(Modules.Common.Action)(script.Name, function(p1, p2, p3) -- line: 6
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "SetIAPProducts: robuxProducts")
	ArgCheck.isType(p2, "table", "SetIAPProducts: robuxPremiumProducts")
	ArgCheck.isType(p3, "table", "SetIAPProducts: subscriptionProducts")

	return {
		robux = p1,
		premiumRobux = p2,
		subscriptions = p3
	}
end)
