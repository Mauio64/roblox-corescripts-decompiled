local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")
local networkProfiler = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Http").NetworkProfiler
require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpStoreTypes")

local function createNetworkStatsHandler(callback)
	return Signals.createEffect(function(p2)
		local v5 = callback(p2)

		if v5.status == "Success" then
			local response = v5.response

			if response.Stats then
				local stats = response.Stats
				networkProfiler:track({
					queued = stats.DurationInQueue or 0,
					nameLookup = stats.DurationNameLookup or -1,
					connect = stats.DurationConnect or -1,
					sslHandshake = stats.DurationSSLHandshake or -1,
					makeRequest = stats.DurationMakeRequest or -1,
					receiveResponse = stats.DurationReceiveResponse or -1
				})
			end
		end
	end)
end

return createNetworkStatsHandler
