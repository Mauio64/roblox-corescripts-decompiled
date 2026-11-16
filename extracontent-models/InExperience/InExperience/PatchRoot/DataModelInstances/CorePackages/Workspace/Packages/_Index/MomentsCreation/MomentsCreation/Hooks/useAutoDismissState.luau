local parent = script:FindFirstAncestor("MomentsCreation").Parent

local React = require(parent.React)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local function useAutoDismissState(flag: boolean?, value: number?)
	local v = useRef(nil)
	local state, setState = useState(flag or true)

	local v2 = useCallback(function()
		if v.current then
			task.cancel(v.current)
		end

		setState(true)
		v.current = task.delay(value or 5, function()
			setState(false)
		end)
	end, { value, state })

	useEffect(function()
		v2()

		return function()
			if v.current then
				task.cancel(v.current)
				v.current = nil
			end
		end
	end, { value })

	return state, v2
end

return useAutoDismissState
