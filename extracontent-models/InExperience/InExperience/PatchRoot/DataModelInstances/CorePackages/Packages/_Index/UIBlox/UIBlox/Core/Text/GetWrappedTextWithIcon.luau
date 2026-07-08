local GetTextSize = require(script.Parent.GetTextSize)

local function getWrappedTextWithIcon(p1, p2, p3, p4, p5) -- line: 16
	-- upvalues: GetTextSize (copy)
	local v8 = GetTextSize("  ", p2, p3, Vector2.new(0, 0)) - GetTextSize(" ", p2, p3, Vector2.new(0, 0))
	local v9 = math.ceil((p4 + p5) / v8.X)

	return string.rep(" ", v9) .. p1
end

return getWrappedTextWithIcon
