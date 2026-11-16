local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local function useUncontrolledState(flag: boolean?, callback)
	local state, setState = React.useState(flag or false)
	React.useEffect(function()
		if flag ~= nil then
			setState(flag)
		end
	end, { flag })

	return state, (React.useCallback(function(flag2: boolean)
		if flag == nil then
			setState(flag2)
		end

		callback(flag2)
	end, { flag, callback }))
end

return useUncontrolledState
