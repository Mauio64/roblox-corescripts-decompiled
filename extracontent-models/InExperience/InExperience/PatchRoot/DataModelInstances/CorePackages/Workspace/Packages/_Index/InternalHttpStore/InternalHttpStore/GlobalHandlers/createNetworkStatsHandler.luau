local parent = script.Parent.Parent

local parent2 = parent.Parent

local Signals = require(parent2.Signals)
local Http = require(parent2.Http)

local NetworkProfiler = Http.NetworkProfiler
require(parent.HttpStoreTypes)

local function createNetworkStatsHandler(callback)
	return Signals.createEffect(function(p)
		local v = callback(p)

		if v.status == "Success" then
			local response = v.response

			if response.Stats then
				local stats = response.Stats
				NetworkProfiler:track({
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
