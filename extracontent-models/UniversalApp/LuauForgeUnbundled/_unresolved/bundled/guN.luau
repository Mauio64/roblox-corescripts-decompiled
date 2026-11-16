local module = require("@luauforge/bundled/dwL")
return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetNativeRobuxProducts", function(p2)
	module.isType(p2, "table", "SetNativeRobuxProducts: nativeRobuxProducts")
	return { nativeRobuxProducts = p2 }
end)
