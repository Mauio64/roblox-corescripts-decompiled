local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local createTelemetryEmitter = require(script.Parent.createTelemetryEmitter)

return function(p1) -- line: 7
	-- upvalues: createTelemetryEmitter (copy), React (copy)
	return function(p2) -- line: 8
		-- upvalues: createTelemetryEmitter (copy), React (copy), p1 (copy)
		assert(type(p2) == "function", "Expect renderCallback to be a function.")

		return React.createElement(p1.Consumer, {
			render = function(p3: ((...any) -> ...any)) -- line: 11
				-- upvalues: createTelemetryEmitter (copy), p2 (copy)
				local v7 = createTelemetryEmitter(p3)

				return p2(v7)
			end
		})
	end
end
