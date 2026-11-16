local TextService = game:GetService("TextService")

local function wrappedHeight(p2, p3, p4, p5)
	return TextService:GetTextSize(p2, p3, p4, Vector2.new(p5, 1000000)).Y
end

local function fitTextOverlayFontSize(p2, p3, p4, p5, p6, p7)
	if p2 == "" or p5 <= 0 or p6 <= 0 or p4 <= p7 then
		return p4
	end

	if TextService:GetTextSize(p2, p4, p3, Vector2.new(p5, 1000000)).Y <= p6 then
		return p4
	end

	for i = 1, 8 do
		local v5 = (p7 + p4) / 2

		if TextService:GetTextSize(p2, v5, p3, Vector2.new(p5, 1000000)).Y <= p6 then
			p7 = v5
		else
			p4 = v5
		end
	end

	return p7
end

return fitTextOverlayFontSize
