local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetSignUpInfo", function(p2, p3, p4, p5)
	module2.isType(p2, "string", "displayName")
	module2.isType(p3, "string", "voucher")
	module2.isType(p4, "string", "authMethod")
	module2.isType(p5, "string", "channelId")

	return {
		prefilledDisplayName = p2,
		signUpVoucher = p3,
		authMethod = p4,
		channelId = p5
	}
end)
