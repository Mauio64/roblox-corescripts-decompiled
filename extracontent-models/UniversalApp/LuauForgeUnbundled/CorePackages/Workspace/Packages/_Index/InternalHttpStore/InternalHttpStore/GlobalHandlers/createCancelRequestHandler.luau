local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")
local HttpSessionTracker = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpSessionTracker")
require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpStoreTypes")

local function createCancelRequestHandler(callback)
	local currentSession = HttpSessionTracker.currentSession()
	return Signals.createComputed(function(p2)
		local v5 = callback(p2)

		if currentSession == HttpSessionTracker.currentSession() then
			return v5
		end

		return { status = "Failed", config = v5.config, cancelled = true }
	end)
end

return createCancelRequestHandler
