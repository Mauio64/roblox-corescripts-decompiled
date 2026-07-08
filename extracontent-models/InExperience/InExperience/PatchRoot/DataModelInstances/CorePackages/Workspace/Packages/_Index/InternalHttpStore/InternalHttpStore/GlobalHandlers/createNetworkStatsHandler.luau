local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local NetworkProfiler = require(ParentParentParent.Http).NetworkProfiler

require(ParentParent.HttpStoreTypes)

local function createNetworkStatsHandler(p1) -- line: 13
	-- upvalues: Signals (copy), NetworkProfiler (copy)
	return Signals.createEffect(function(p2) -- line: 14
		-- upvalues: p1 (copy), NetworkProfiler (copy)
		local v8 = p1(p2)

		if v8.status == "Success" then
			local response = v8.response

			if response.Stats then
				local Stats = response.Stats

				NetworkProfiler:track({
					queued = Stats.DurationInQueue or 0,
					nameLookup = Stats.DurationNameLookup or -1,
					connect = Stats.DurationConnect or -1,
					sslHandshake = Stats.DurationSSLHandshake or -1,
					makeRequest = Stats.DurationMakeRequest or -1,
					receiveResponse = Stats.DurationReceiveResponse or -1
				})
			end
		end
	end)
end

return createNetworkStatsHandler
