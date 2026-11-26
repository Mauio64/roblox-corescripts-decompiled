local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Loggers").Logger
local HttpService = game:GetService("HttpService")

return {
	debug = function(p2)
		logger:debug(HttpService:JSONEncode(p2))
	end,
	info = function(p2)
		logger:info(HttpService:JSONEncode(p2))
	end,
	warn = function(p2)
		logger:warn(HttpService:JSONEncode(p2))
	end,
	error = function(p2)
		logger:error(HttpService:JSONEncode(p2))
	end
}
