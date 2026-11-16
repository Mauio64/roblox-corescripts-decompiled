local module = require("@luauforge/bundled/hvk")

local rodux = module.Rodux
local roduxNetworking = module.RoduxNetworking
local showContactImporterParams = module.ShowContactImporterParams

return function()
	return rodux.combineReducers({
		Users = require("@luauforge/bundled/hvs"),
		Friends = require("@luauforge/bundled/hvu"),
		Presence = require("@luauforge/bundled/hvv"),
		PremiumByUserId = require("@luauforge/bundled/hvw"),
		ShowContactImporterParams = showContactImporterParams,
		NetworkStatus = roduxNetworking.installReducer(),
		UnreadConversationCount = require("@luauforge/bundled/hvx")
	})
end
