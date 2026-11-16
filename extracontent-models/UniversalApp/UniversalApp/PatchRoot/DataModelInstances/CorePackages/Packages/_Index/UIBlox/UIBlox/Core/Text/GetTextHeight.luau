local GetTextSize = require(script.Parent.GetTextSize)

local function getTextHeight(p: string, p2, p3: number, p4: number, value: number?)
	return GetTextSize(p, p3, p2, (Vector2.new(p4, (math.min(10000, value or 10000))))).Y
end

return getTextHeight
