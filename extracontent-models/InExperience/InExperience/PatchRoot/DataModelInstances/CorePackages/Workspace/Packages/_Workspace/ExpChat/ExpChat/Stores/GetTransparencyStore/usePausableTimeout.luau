local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

local function usePausableTimeout(b1: boolean, n1: number, p1: ((...any) -> ...any)) -- line: 9
	-- upvalues: React (copy)
	local v7 = React.useRef(0)

	React.useEffect(function() -- line: 11
		-- upvalues: n1 (copy), b1 (copy), v7 (copy), p1 (copy)
		if n1 <= 0 or not b1 then
			return nil
		end

		local elapsed = os.clock()
		local v9 = math.max(0, n1 - v7.current)
		local thread = task.delay(v9, p1)

		return function() -- line: 18
			-- upvalues: v7 (copy), elapsed (copy), thread (copy)
			local v11 = v7

			v11.current = v11.current + (os.clock() - elapsed)
			pcall(task.cancel, thread)
		end
	end, {
		b1,
		n1,
		p1
	})
end

return usePausableTimeout
