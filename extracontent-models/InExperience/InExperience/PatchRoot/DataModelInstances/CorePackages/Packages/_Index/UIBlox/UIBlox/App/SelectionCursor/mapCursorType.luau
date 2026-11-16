local parent = script.Parent.Parent.Parent.Parent
local Foundation = require(parent.Foundation)
local CursorType = Foundation.Enums.CursorType

local function mapCursorType(p, flag: boolean?)
	local v = tostring(p)
	return CursorType[string.gsub(v, flag and "CursorKind%." or "CursorType%.", "")]
end

return mapCursorType
