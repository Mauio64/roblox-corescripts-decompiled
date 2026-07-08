local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")
local useEffect = require(ReactSceneUnderstanding.Parent.React).useEffect

local function useTimedLoop(n1: number, p1: ((...any) -> ...any)) -- line: 7
	-- upvalues: useEffect (copy)
	useEffect(function() -- line: 8
		-- upvalues: n1 (copy), p1 (copy)
		local u6 = true

		task.spawn(function() -- line: 11
			-- upvalues: u6 (ref), n1 (copy), p1 (copy)
			while u6 do
				task.wait(n1)

				if not u6 then
					return
				end

				p1()
			end
		end)

		return function() -- line: 23
			-- upvalues: u6 (ref)
			u6 = false
		end
	end, {
		n1,
		p1
	})
end

return useTimedLoop
