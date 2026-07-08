local useLazyRef = require(script.Parent.useLazyRef)

local function useInitializedValue(p1: ((...any) -> ...any)) -- line: 11
	-- upvalues: useLazyRef (copy)
	return useLazyRef(p1).current
end

return useInitializedValue
