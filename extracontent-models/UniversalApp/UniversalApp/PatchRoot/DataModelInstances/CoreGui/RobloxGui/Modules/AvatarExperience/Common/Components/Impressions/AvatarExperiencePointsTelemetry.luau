local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local v3 = game:DefineFastInt("AXPointsEventHundredthsPercent", 0)

local function generateEventConfig(p1) -- line: 7
	-- upvalues: default (copy), v3 (copy)
	return {
		eventName = "AvatarExperience" .. p1,
		backends = { default.TelemetryBackends.Points },
		throttlingPercentage = v3
	}
end

return {
	sendTelemetryEvent = function(s1: string, t1: {[any]: any}) -- line: 19
		-- upvalues: default (copy), v3 (copy)
		local t2 = {
			eventName = "AvatarExperience" .. s1,
			backends = { default.TelemetryBackends.Points },
			throttlingPercentage = v3
		}

		default:logRobloxTelemetryEvent(t2, nil, t1)
	end
}
