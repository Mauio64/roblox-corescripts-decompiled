local ParentParent = script.Parent.Parent.Parent.Parent
local useCursor = require(ParentParent.Foundation).Hooks.useCursor

require(ParentParent.React)

local mapCursorType = require(script.Parent.mapCursorType)

local function useCursorByType(p1) -- line: 8
	-- upvalues: useCursor (copy), mapCursorType (copy)
	return useCursor(mapCursorType(p1))
end

return useCursorByType
