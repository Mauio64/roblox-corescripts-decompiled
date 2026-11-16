local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local HttpService = game:GetService("HttpService")
local RobloxSubscriptionLogger = {}

function RobloxSubscriptionLogger:debug()
	Logger:debug(HttpService:JSONEncode(self))
end
function RobloxSubscriptionLogger:info()
	Logger:info(HttpService:JSONEncode(self))
end
function RobloxSubscriptionLogger:warn()
	Logger:warn(HttpService:JSONEncode(self))
end
function RobloxSubscriptionLogger:error()
	Logger:error(HttpService:JSONEncode(self))
end

return RobloxSubscriptionLogger
