local module = require("@luauforge/bundled/hGq")

local rodux = module.Rodux
local roduxNetworking = module.RoduxNetworking
local showContactImporterParams = module.ShowContactImporterParams

return function()
	return rodux.combineReducers({
		Users = require("@luauforge/bundled/hGy"),
		Friends = require("@luauforge/bundled/hGA"),
		Presence = require("@luauforge/bundled/hGB"),
		PremiumByUserId = require("@luauforge/bundled/hGC"),
		ShowContactImporterParams = showContactImporterParams,
		NetworkStatus = roduxNetworking.installReducer(),
		UnreadConversationCount = require("@luauforge/bundled/hGD")
	})
end
