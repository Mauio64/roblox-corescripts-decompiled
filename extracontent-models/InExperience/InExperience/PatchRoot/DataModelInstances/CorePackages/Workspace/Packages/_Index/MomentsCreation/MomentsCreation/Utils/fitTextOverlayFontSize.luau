local TextService = game:GetService("TextService")

local function wrappedHeight(p: string, p2: number, p3, p4: number) -- 2 equivalent calls inferred from this helper
	return TextService:GetTextSize(p, p2, p3, Vector2.new(p4, 1000000)).Y
end

local function fitTextOverlayFontSize(p: string, p2, p3: number, p4: number, p5: number, p6: number)
	if p == "" or p4 <= 0 or p5 <= 0 or p3 <= p6 then
		return p3
	end

	if wrappedHeight(p, p3, p2, p4) <= p5 then -- inferred equivalent call
		return p3
	end

	for _ = 1, 8 do
		local midpoint = (p6 + p3) / 2

		if wrappedHeight(p, midpoint, p2, p4) <= p5 then -- inferred equivalent call
			p6 = midpoint
		else
			p3 = midpoint
		end
	end

	return p6
end

return fitTextOverlayFontSize
