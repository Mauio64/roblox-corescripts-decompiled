local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)
local useStore = require(script.Parent.useStore)

local function useDispatch() -- line: 10
	-- upvalues: useStore (copy), React (copy)
	local v5 = useStore()

	return (React.useCallback(function(...) -- line: 13
		-- upvalues: v5 (copy)
		return v5:dispatch(...)
	end, { v5 }))
end

return useDispatch
