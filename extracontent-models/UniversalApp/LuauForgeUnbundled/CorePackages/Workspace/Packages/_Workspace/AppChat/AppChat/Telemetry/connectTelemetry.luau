local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local function connectTelemetry(p2)
	return function(p3)
		return function(p4)
			local v5 = useTelemetry(p2)
			return React.createElement(p3, Cryo.Dictionary.union(p4, {
				telemetry = v5
			}))
		end
	end
end

return connectTelemetry
