local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)

local function useOptimisticUpdateStatus(p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 11
	-- upvalues: React (copy), Signals (copy)
	local v7 = React.useRef(nil)

	React.useEffect(function() -- line: 18
		-- upvalues: v7 (copy)
		return function() -- line: 19
			-- upvalues: v7 (copy)
			if v7.current then
				v7.current()
			end
		end
	end, {})

	return React.useCallback(function(...) -- line: 27
		-- upvalues: v7 (copy), p1 (copy), Signals (copy), p2 (copy)
		if v7.current then
			v7.current()
			v7.current = nil
		end

		local v8 = p1(...)

		if v8 then
			v7.current = Signals.createEffect(function(p3) -- line: 39
				-- upvalues: v8 (copy), p2 (copy)
				local v10 = v8(p3)

				if v10 ~= nil then
					p2(v10)
				end
			end)
		end
	end, {
		p1,
		p2
	})
end

return useOptimisticUpdateStatus
