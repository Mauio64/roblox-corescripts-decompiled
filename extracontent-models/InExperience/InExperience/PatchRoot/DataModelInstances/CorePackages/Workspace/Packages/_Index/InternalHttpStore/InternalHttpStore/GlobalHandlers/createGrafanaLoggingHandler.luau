local parent = script.Parent.Parent

local parent2 = parent.Parent

local Signals = require(parent2.Signals)
local Http = require(parent2.Http)

local GreenlistedEndpointsForLogging = Http.Logger.GreenlistedEndpointsForLogging
require(parent.HttpStoreTypes)

local function createGrafanaLoggingHandler(callback)
	return Signals.createEffect(function(p)
		local v = callback(p)

		if v.status == "Success" then
			GreenlistedEndpointsForLogging.sendStatusCodeCounter(v.config.Url, v.response.StatusCode)
		end
	end)
end

return createGrafanaLoggingHandler
