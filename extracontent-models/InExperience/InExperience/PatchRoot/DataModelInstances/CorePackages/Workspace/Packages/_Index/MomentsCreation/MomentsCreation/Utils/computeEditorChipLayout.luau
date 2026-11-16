local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

local TextService = game:GetService("TextService")

local Constants = require(MomentsCreation.Constants)
local fitTextOverlayFontSize = require(MomentsCreation.Utils.fitTextOverlayFontSize)

local function computeEditorChipLayout(data)
	local v = math.min(data.itemWidth / 2, data.maxChipWidth - data.chipPadding * 2)
	local minFontSize = Constants.TextOverlay.MinFontSize
	local keyboardTop = data.keyboardTop or data.viewportHeight - data.keyboardHeight

	local v2 = math.max(minFontSize, keyboardTop - data.keyboardGap - data.topMargin - data.chipPadding * 2)
	local fontSize = fitTextOverlayFontSize(
		data.text,
		data.font,
		Constants.TextOverlay.DefaultFontSize,
		v,
		v2,
		minFontSize
	)

	local textSize = TextService:GetTextSize(data.text, fontSize, data.font, Vector2.new(v, data.viewportHeight))
	local y = textSize.Y

	if
		data.growWidthWithText
		and TextService:GetTextSize(data.text, fontSize, data.font, Vector2.new(v, 1000000)).Y <= TextService:GetTextSize(
			data.text,
			fontSize,
			data.font,
			Vector2.new(1000000, 1000000)
		).Y
	then
		local v3 = math.ceil(TextService:GetTextSize(" ", fontSize, data.font, Vector2.new(1000000, 1000000)).X) + math.ceil(fontSize * (data.overhangFraction or 0))
		v = math.clamp(math.ceil(textSize.X) + v3, math.min(fontSize, v), v)
	end

	local v3 = keyboardTop - data.layerTopY - data.keyboardGap

	local v4 = y + data.chipPadding * 2

	return {
		fontSize = fontSize,
		size = UDim2.fromOffset(v, y),
		position = UDim2.new(0.5, 0, 0, v3 - v4 / 2)
	}
end

return computeEditorChipLayout
