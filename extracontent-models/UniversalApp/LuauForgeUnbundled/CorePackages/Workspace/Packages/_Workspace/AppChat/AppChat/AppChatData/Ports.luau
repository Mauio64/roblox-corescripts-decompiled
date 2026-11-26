local module = require("@luauforge/deferred/ioT")

local createHttpPort = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatData/Ports/createHttpPort")
local NotificationService = game:GetService("NotificationService")

local robloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatData/Ports/createRealtimePort").RobloxEventReceiver

local function QueryRefetchManager(): nil
	createHttpPort((module.useMemo(function()
		return robloxEventReceiver.new(NotificationService)
	end, {})))
	return nil
end

return QueryRefetchManager
