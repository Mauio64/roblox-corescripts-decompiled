local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useClock()
	local v, v2 = React.useBinding(0)

	React.useEffect(function()
		local thread = task.spawn(function()
			while true do
				local v3 = task.wait()
				v2(v:getValue() + v3)
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, {})

	return v
end

return useClock
