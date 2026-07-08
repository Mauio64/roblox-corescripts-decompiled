local ParentParent = script.Parent.Parent.Parent.Parent
local CursorType = require(ParentParent.Foundation).Enums.CursorType

local function mapCursorType(p1, b1: boolean?) -- line: 5
	-- upvalues: CursorType (copy)
	local str = tostring(p1)

	return CursorType[string.gsub(str, not b1 and "CursorType%." or "CursorKind%.", "")]
end

return mapCursorType
