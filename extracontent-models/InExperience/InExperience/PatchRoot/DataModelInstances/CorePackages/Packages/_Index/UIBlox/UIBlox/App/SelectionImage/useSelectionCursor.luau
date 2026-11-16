local parent = script.Parent.Parent.Parent.Parent
local parent2 = script.Parent.Parent.Parent

local Foundation = require(parent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local mapCursorType = require(parent2.App.SelectionCursor.mapCursorType)

local function useSelectionCursor(p)
	return useCursor(mapCursorType(p, true))
end

return useSelectionCursor
