local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local function createControllableThrowingMock()
	local v = { mode = nil, renderCount = 0 }

	return {
		reset = function()
			v.mode = nil
			v.renderCount = 0
		end,
		setMode = function(mode: string?)
			v.mode = mode
		end,
		wrap = function(callback)
			return function(p)
				v.renderCount += 1
				local renderCount = v.renderCount

				local _, setState = React.useState(0)
				React.useEffect(function()
					if v.mode == "afterFirst" and renderCount == 1 then
						setState(1)
					end
				end, { renderCount })

				if v.mode == "always" then
					error("simulated render error (pre-handle)")
				elseif v.mode == "afterFirst" and renderCount > 1 then
					error("simulated render error (post-handle)")
				end

				return callback(p)
			end
		end
	}
end

return createControllableThrowingMock
