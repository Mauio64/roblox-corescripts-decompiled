local parent = script:FindFirstAncestor("ReactUtils").Parent
require(parent.React)
local usePropertiesBase = require(script.Parent.usePropertiesBase)

local function usePropertiesDeferred(p, p2, ...)
	return usePropertiesBase(p, p2, true, ...)
end

return usePropertiesDeferred
