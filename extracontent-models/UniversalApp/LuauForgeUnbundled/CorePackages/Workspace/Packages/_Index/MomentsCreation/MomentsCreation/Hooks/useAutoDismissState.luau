local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local function useAutoDismissState(p2, value)
	local v5 = useRef(nil)
	local state, setState = useState(p2 or true)

	local v6 = useCallback(function()
		if v5.current then
			task.cancel(v5.current)
		end

		setState(true)
		v5.current = task.delay(value or 5, function()
			setState(false)
		end)
	end, { value, state })

	useEffect(function()
		v6()

		return function()
			if v5.current then
				task.cancel(v5.current)
				v5.current = nil
			end
		end
	end, { value })

	return state, v6
end

return useAutoDismissState
