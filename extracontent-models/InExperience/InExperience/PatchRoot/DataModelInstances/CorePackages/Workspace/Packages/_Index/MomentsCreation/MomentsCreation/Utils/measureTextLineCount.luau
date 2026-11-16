local TextService = game:GetService("TextService")

local function measureTextLineCount(p: string, p2: number, p3: number, p4, max: number)
	if p == "" or p2 <= 0 then
		return 1
	end

	local vector2 = Vector2.new(p2, 1e999)
	local y = TextService:GetTextSize("M", p3, p4, vector2).Y

	if y <= 0 then
		return 1
	end

	return (math.clamp(math.ceil(TextService:GetTextSize(p, p3, p4, vector2).Y / y), 1, max))
end

return measureTextLineCount
