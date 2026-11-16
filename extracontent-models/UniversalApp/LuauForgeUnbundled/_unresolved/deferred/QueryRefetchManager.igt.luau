local module = require("@luauforge/deferred/igu")

local module2 = require("@luauforge/deferred/igv")
local NotificationService = game:GetService("NotificationService")

local robloxEventReceiver = require("@luauforge/deferred/igC").RobloxEventReceiver

local function QueryRefetchManager(): nil
	module2((module.useMemo(function()
		return robloxEventReceiver.new(NotificationService)
	end, {})))
	return nil
end

return QueryRefetchManager
