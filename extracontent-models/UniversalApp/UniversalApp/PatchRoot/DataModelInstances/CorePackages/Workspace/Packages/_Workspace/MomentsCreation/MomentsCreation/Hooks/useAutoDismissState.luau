local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local React = require(Parent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local function useAutoDismissState(b1: boolean?, n1: number?) -- line: 21
	-- upvalues: useRef (copy), useState (copy), useCallback (copy), useEffect (copy)
	local v10 = useRef(nil)
	local v11, v12 = useState(b1 or true)
	local v13 = useCallback(function() -- line: 25
		-- upvalues: v10 (copy), v12 (copy), n1 (copy)
		if v10.current then
			task.cancel(v10.current)
		end

		v12(true)
		v10.current = task.delay(n1 or 5, function() -- line: 31
			-- upvalues: v12 (copy)
			v12(false)
		end)
	end, {
		n1,
		v11
	})

	useEffect(function() -- line: 40
		-- upvalues: v13 (copy), v10 (copy)
		v13()

		return function() -- line: 43
			-- upvalues: v10 (copy)
			if v10.current then
				task.cancel(v10.current)
				v10.current = nil
			end
		end
	end, { n1 })

	return v11, v13
end

return useAutoDismissState
