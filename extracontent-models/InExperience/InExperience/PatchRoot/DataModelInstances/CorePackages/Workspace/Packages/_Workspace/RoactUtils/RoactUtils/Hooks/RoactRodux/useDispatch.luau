local parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(parent.React)

local useStore = require(script.Parent.useStore)

local function useDispatch()
	local v = useStore()

	return (React.useCallback(function(...)
		return v:dispatch(...)
	end, { v }))
end

return useDispatch
