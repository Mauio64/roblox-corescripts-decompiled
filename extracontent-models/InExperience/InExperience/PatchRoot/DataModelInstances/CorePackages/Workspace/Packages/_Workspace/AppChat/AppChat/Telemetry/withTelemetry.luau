local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

local createTelemetryEmitter = require(script.Parent.createTelemetryEmitter)

return function(p)
	return function(callback)
		assert(type(callback) == "function", "Expect renderCallback to be a function.")

		local function fn(callback2)
			return callback((createTelemetryEmitter(callback2)))
		end

		return React.createElement(p.Consumer, { render = fn })
	end
end
