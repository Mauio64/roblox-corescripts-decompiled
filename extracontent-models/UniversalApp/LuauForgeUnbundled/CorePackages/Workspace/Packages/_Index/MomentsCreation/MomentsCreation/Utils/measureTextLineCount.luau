local TextService = game:GetService("TextService")

local function measureTextLineCount(p2, p3, p4, p5, max)
	if p2 == "" or p3 <= 0 then
		return 1
	end

	local vector2 = Vector2.new(p3, 1e999)
	local y = TextService:GetTextSize("M", p4, p5, vector2).Y

	if y <= 0 then
		return 1
	end

	return (math.clamp(math.ceil(TextService:GetTextSize(p2, p4, p5, vector2).Y / y), 1, max))
end

return measureTextLineCount
