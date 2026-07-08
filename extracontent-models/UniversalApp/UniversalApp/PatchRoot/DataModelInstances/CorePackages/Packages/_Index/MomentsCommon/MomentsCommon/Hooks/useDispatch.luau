local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local useStore = require(MomentsCommon.Hooks.useStore)

local function useDispatch() -- line: 8
	-- upvalues: useStore (copy), React (copy)
	local v6 = useStore()

	return (React.useCallback(function(...) -- line: 11
		-- upvalues: v6 (copy)
		return v6:dispatch(...)
	end, { v6 }))
end

return useDispatch
