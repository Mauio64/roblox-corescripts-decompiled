local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local function connectTelemetry(p)
	return function(p2)
		return function(p3)
			local telemetry = useTelemetry(p)
			return React.createElement(p2, Cryo.Dictionary.union(p3, { telemetry = telemetry }))
		end
	end
end

return connectTelemetry
