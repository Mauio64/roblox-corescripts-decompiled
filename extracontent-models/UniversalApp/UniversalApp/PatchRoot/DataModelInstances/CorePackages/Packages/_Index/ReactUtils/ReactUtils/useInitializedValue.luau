local useLazyRef = require(script.Parent.useLazyRef)

local function useInitializedValue(callback)
	return useLazyRef(callback).current
end

return useInitializedValue
