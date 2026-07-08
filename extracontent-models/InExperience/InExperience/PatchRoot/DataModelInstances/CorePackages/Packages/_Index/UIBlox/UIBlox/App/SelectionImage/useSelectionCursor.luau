local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParent2 = script.Parent.Parent.Parent
local useCursor = require(ParentParent.Foundation).Hooks.useCursor
local mapCursorType = require(ParentParent2.App.SelectionCursor.mapCursorType)

local function useSelectionCursor(p1) -- line: 14
	-- upvalues: useCursor (copy), mapCursorType (copy)
	return useCursor(mapCursorType(p1, true))
end

return useSelectionCursor
