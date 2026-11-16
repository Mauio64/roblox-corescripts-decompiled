local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)

local useStore = require(MomentsCommon.Hooks.useStore)

local function useDispatch()
	local v = useStore()

	return (React.useCallback(function(...)
		return v:dispatch(...)
	end, { v }))
end

return useDispatch
