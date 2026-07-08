local EngineFeature = game:GetEngineFeature("TextBoundsRoundUp")
local TextService = game:GetService("TextService")
local t1 = {
	_TEMP_PATCHED_PADDING = Vector2.new(0, 0)
}

if not EngineFeature then
	t1._TEMP_PATCHED_PADDING = Vector2.new(2, 2)
end

function t1.GetTextBounds(p1, p2, p3, p4) -- line: 18
	-- upvalues: TextService (copy), t1 (copy)
	return TextService:GetTextSize(p1, p3, p2, p4) + t1._TEMP_PATCHED_PADDING
end
function t1.GetTextWidth(p5, p6, p7) -- line: 22
	-- upvalues: t1 (copy)
	return t1.GetTextBounds(p5, p6, p7, Vector2.new(10000, 10000)).X
end
function t1.GetTextHeight(p8, p9, p10, p11) -- line: 26
	-- upvalues: t1 (copy)
	return t1.GetTextBounds(p8, p9, p10, Vector2.new(p11, 10000)).Y
end

return t1
