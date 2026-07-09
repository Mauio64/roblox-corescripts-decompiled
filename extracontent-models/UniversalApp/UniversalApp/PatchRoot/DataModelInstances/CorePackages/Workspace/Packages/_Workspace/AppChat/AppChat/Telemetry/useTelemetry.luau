local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local createTelemetryEmitter = require(script.Parent.createTelemetryEmitter)

local function useTelemetry(p1) -- line: 7
	-- upvalues: React (copy), createTelemetryEmitter (copy)
	local v6 = React.useContext(p1)

	return createTelemetryEmitter(v6)
end

return useTelemetry
