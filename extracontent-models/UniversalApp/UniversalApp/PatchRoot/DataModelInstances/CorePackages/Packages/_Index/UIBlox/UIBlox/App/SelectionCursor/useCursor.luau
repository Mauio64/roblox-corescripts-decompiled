local parent = script.Parent.Parent.Parent.Parent
require(parent.React)
local Foundation = require(parent.Foundation)
local useCursor = Foundation.Hooks.useCursor

local function useCursor2(radius: UDim?, offset: number?, borderWidth: number?)
	return useCursor({ radius = radius, offset = offset, borderWidth = borderWidth })
end

return useCursor2
