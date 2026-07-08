local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useDebounce(p1, n1: number?) -- line: 7
	-- upvalues: React (copy)
	local v6, v7 = React.useState(p1)

	React.useLayoutEffect(function() -- line: 10
		-- upvalues: v7 (copy), p1 (copy), n1 (copy)
		local function updateValue() -- line: 11
			-- upvalues: v7 (copy), p1 (copy)
			v7(p1)
		end

		if n1 == nil or n1 == 0 then
			v7(p1)

			return
		end

		local thread = task.delay(n1, updateValue)

		return function() -- line: 22
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		p1,
		n1
	})

	return v6
end

return useDebounce
