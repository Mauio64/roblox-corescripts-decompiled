local Parent = script:FindFirstAncestor("ReactUtils").Parent

require(Parent.React)

local usePropertiesBase = require(script.Parent.usePropertiesBase)

local function usePropertiesDeferred(p1, p2, ...) -- line: 19
	-- upvalues: usePropertiesBase (copy)
	return usePropertiesBase(p1, p2, true, ...)
end

return usePropertiesDeferred
