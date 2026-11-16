local engineFeature = game:GetEngineFeature("TextBoundsRoundUp")

local TextService = game:GetService("TextService")

local Text = {}

Text._TEMP_PATCHED_PADDING = Vector2.new(0, 0)

if not engineFeature then
	Text._TEMP_PATCHED_PADDING = Vector2.new(2, 2)
end

function Text.GetTextBounds(p, p2, p3, p4)
	return TextService:GetTextSize(p, p3, p2, p4) + Text._TEMP_PATCHED_PADDING
end

function Text.GetTextWidth(p, p2, p3)
	return Text.GetTextBounds(p, p2, p3, Vector2.new(10000, 10000)).X
end

function Text.GetTextHeight(p, p2, p3, p4)
	return Text.GetTextBounds(p, p2, p3, Vector2.new(p4, 10000)).Y
end

return Text
