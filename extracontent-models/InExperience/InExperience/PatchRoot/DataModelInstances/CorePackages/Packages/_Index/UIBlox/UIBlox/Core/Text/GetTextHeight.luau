local GetTextSize = require(script.Parent.GetTextSize)

local function getTextHeight(s1: string, p1, n1: number, n2: number, n3: number?) -- line: 6
	-- upvalues: GetTextSize (copy)
	local v8 = n3 or 10000
	local vector2 = Vector2.new(n2, (math.min(10000, v8)))

	return GetTextSize(s1, n1, p1, vector2).Y
end

return getTextHeight
