local GetTextSize = require(script.Parent.GetTextSize)

local function getWrappedTextWithIcon(p, p2, p3, p4, p5)
	local v = GetTextSize("  ", p2, p3, Vector2.new(0, 0)) - GetTextSize(" ", p2, p3, Vector2.new(0, 0))
	local v2 = math.ceil((p4 + p5) / v.X)
	return string.rep(" ", v2) .. p
end

return getWrappedTextWithIcon
