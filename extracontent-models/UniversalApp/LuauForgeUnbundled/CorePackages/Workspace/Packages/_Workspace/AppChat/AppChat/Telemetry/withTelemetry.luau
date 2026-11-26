local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local createTelemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createTelemetryEmitter")

return function(p2)
	return function(callback)
		assert(type(callback) == "function", "Expect renderCallback to be a function.")

		local function fn(p3)
			return callback((createTelemetryEmitter(p3)))
		end

		return React.createElement(p2.Consumer, { render = fn })
	end
end
