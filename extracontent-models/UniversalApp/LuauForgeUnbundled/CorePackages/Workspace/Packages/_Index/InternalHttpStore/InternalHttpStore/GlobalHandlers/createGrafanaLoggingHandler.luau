local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")
local greenlistedEndpointsForLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Http").Logger.GreenlistedEndpointsForLogging
require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpStoreTypes")

local function createGrafanaLoggingHandler(callback)
	return Signals.createEffect(function(p2)
		local v5 = callback(p2)

		if v5.status == "Success" then
			greenlistedEndpointsForLogging.sendStatusCodeCounter(v5.config.Url, v5.response.StatusCode)
		end
	end)
end

return createGrafanaLoggingHandler
