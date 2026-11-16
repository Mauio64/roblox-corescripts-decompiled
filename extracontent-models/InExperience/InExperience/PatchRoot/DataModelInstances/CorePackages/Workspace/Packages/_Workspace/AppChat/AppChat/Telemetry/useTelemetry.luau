local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

local createTelemetryEmitter = require(script.Parent.createTelemetryEmitter)

local function useTelemetry(p)
	return createTelemetryEmitter((React.useContext(p)))
end

return useTelemetry
