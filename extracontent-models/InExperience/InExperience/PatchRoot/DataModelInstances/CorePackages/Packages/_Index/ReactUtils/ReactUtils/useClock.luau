local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useClock() -- line: 7
	-- upvalues: React (copy)
	local v4, v5 = React.useBinding(0)

	React.useEffect(function() -- line: 10
		-- upvalues: v5 (copy), v4 (copy)
		local thread = task.spawn(function() -- line: 11
			-- upvalues: v5 (copy), v4 (copy)
			while true do
				local elapsed = task.wait()

				v5(v4:getValue() + elapsed)
			end
		end)

		return function() -- line: 18
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {})

	return v4
end

return useClock
