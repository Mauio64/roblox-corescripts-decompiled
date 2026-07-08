local Parent = script:FindFirstAncestor("ReactUtils").Parent

require(Parent.React)

local usePropertiesBase = require(script.Parent.usePropertiesBase)

local function useProperties(p1, p2, ...) -- line: 33
	-- upvalues: usePropertiesBase (copy)
	return usePropertiesBase(p1, p2, false, ...)
end

return useProperties
