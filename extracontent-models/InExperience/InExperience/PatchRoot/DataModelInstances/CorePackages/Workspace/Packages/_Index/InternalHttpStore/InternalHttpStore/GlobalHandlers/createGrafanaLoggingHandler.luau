local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local GreenlistedEndpointsForLogging = require(ParentParentParent.Http).Logger.GreenlistedEndpointsForLogging

require(ParentParent.HttpStoreTypes)

local function createGrafanaLoggingHandler(p1) -- line: 13
	-- upvalues: Signals (copy), GreenlistedEndpointsForLogging (copy)
	return Signals.createEffect(function(p2) -- line: 14
		-- upvalues: p1 (copy), GreenlistedEndpointsForLogging (copy)
		local v8 = p1(p2)

		if v8.status == "Success" then
			GreenlistedEndpointsForLogging.sendStatusCodeCounter(v8.config.Url, v8.response.StatusCode)
		end
	end)
end

return createGrafanaLoggingHandler
