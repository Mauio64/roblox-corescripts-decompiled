local parent = script.Parent.Parent.Parent.Parent
local Foundation = require(parent.Foundation)
local useCursor = Foundation.Hooks.useCursor
require(parent.React)
local mapCursorType = require(script.Parent.mapCursorType)

local function useCursorByType(p)
	return useCursor(mapCursorType(p))
end

return useCursorByType
