local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local Logger = require(Parent.Loggers).Logger
local HttpService = game:GetService("HttpService")

return {
	debug = function(t1: {[any]: any}) -- line: 8
		-- upvalues: Logger (copy), HttpService (copy)
		Logger:debug(HttpService:JSONEncode(t1))
	end,
	info = function(t2: {[any]: any}) -- line: 11
		-- upvalues: Logger (copy), HttpService (copy)
		Logger:info(HttpService:JSONEncode(t2))
	end,
	warn = function(t3: {[any]: any}) -- line: 14
		-- upvalues: Logger (copy), HttpService (copy)
		Logger:warn(HttpService:JSONEncode(t3))
	end,
	error = function(t4: {[any]: any}) -- line: 17
		-- upvalues: Logger (copy), HttpService (copy)
		Logger:error(HttpService:JSONEncode(t4))
	end
}
