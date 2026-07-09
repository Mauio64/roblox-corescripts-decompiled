local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)

local function createControllableThrowingMock() -- line: 24
	-- upvalues: React (copy)
	local t1 = {
		mode = nil,
		renderCount = 0
	}

	return {
		reset = function() -- line: 27
			-- upvalues: t1 (copy)
			t1.mode = nil
			t1.renderCount = 0
		end,
		setMode = function(s1: string?) -- line: 32
			-- upvalues: t1 (copy)
			t1.mode = s1
		end,
		wrap = function(p1: ((...any) -> ...any)) -- line: 36
			-- upvalues: t1 (copy), React (copy)
			return function(p2) -- line: 37
				-- upvalues: t1 (copy), React (copy), p1 (copy)
				local v8 = t1

				v8.renderCount = v8.renderCount + 1

				local renderCount = t1.renderCount
				local _, v11 = React.useState(0)

				React.useEffect(function() -- line: 42
					-- upvalues: t1 (copy), renderCount (copy), v11 (copy)
					if t1.mode == "afterFirst" and renderCount == 1 then
						v11(1)
					end
				end, { renderCount })

				if t1.mode == "always" then
					error("simulated render error (pre-handle)")
				elseif t1.mode == "afterFirst" and renderCount > 1 then
					error("simulated render error (post-handle)")
				end

				return p1(p2)
			end
		end
	}
end

return createControllableThrowingMock
