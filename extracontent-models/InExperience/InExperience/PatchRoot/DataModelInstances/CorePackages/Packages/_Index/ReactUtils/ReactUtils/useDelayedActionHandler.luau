local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useDelayedActionHandler(n1: number, n2: number?, p1: ((...any) -> ...any)) -- line: 6
	-- upvalues: React (copy)
	local v7 = React.useRef(nil)
	local v8 = React.useRef(0)

	local function handleAction() -- line: 15
		-- upvalues: n2 (copy), v8 (copy), v7 (copy), n1 (copy), p1 (copy)
		local elapsed = os.clock()

		if n2 ~= nil and (v8.current ~= nil and elapsed - v8.current < n2) then
			return
		end

		v8.current = elapsed

		local current = v7.current

		if current ~= nil then
			task.cancel(current)
		end

		v7.current = task.delay(n1, function() -- line: 33
			-- upvalues: p1 (copy)
			p1()
		end)
	end

	React.useEffect(function() -- line: 38
		-- upvalues: v7 (copy)
		return function() -- line: 39
			-- upvalues: v7 (copy)
			local current = v7.current

			if current ~= nil then
				task.cancel(current)
			end
		end
	end, { v7 })

	return handleAction
end

return useDelayedActionHandler
