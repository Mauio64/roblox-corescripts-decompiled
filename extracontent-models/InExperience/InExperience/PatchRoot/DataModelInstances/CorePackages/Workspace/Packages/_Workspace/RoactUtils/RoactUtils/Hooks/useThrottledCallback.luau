local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)
local Promise = require(Parent.Promise)

local function useThrottledCallback(p1: ((...any) -> ...any), n1: number) -- line: 20
	-- upvalues: React (copy), Promise (copy)
	local v7 = React.useRef(p1)
	local v8 = React.useRef(n1)

	v7.current = p1
	v8.current = n1

	local v9 = React.useRef(nil)
	local v10 = React.useRef(0)
	local v11 = React.useCallback(function() -- line: 30
		-- upvalues: v9 (copy), v8 (copy), v10 (copy), v7 (copy), Promise (copy)
		if v9.current then
			return
		end

		local v12 = v8.current or 0
		local v13 = v10.current + v12 - tick()

		local function runCallback() -- line: 39
			-- upvalues: v7 (copy), v10 (copy), v9 (copy)
			v7.current()
			v10.current = tick()
			v9.current = nil
		end

		if v13 > 0 then
			v9.current = Promise.delay(v13):andThen(runCallback)

			return
		end

		v7.current()
		v10.current = tick()
		v9.current = nil
	end)

	React.useEffect(function() -- line: 53
		-- upvalues: v9 (copy), v7 (copy)
		return function() -- line: 54
			-- upvalues: v9 (copy), v7 (copy)
			local current = v9.current

			if current then
				current:cancel()
				v7.current()
			end
		end
	end, {})

	return v11
end

return useThrottledCallback
