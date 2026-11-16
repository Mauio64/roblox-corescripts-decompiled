local TextService = game:GetService("TextService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local fitTextOverlayFontSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/fitTextOverlayFontSize")

local function computeEditorChipLayout(data)
	local v5 = math.min(data.itemWidth / 2, data.maxChipWidth - 2 * data.chipPadding)
	local minFontSize = Constants.TextOverlay.MinFontSize
	local keyboardTop = data.keyboardTop or data.viewportHeight - data.keyboardHeight

	local v6 = math.max(minFontSize, keyboardTop - data.keyboardGap - data.topMargin - 2 * data.chipPadding)
	local v7 = fitTextOverlayFontSize(data.text, data.font, Constants.TextOverlay.DefaultFontSize, v5, v6, minFontSize)

	local textSize = TextService:GetTextSize(data.text, v7, data.font, Vector2.new(v5, data.viewportHeight))
	local y = textSize.Y

	if
		data.growWidthWithText
		and TextService:GetTextSize(data.text, v7, data.font, Vector2.new(v5, 1000000)).Y <= TextService:GetTextSize(
			data.text,
			v7,
			data.font,
			Vector2.new(1000000, 1000000)
		).Y
	then
		local v8 = math.ceil(TextService:GetTextSize(" ", v7, data.font, Vector2.new(1000000, 1000000)).X) + math.ceil(v7 * (data.overhangFraction or 0))
		v5 = math.clamp(math.ceil(textSize.X) + v8, math.min(v7, v5), v5)
	end

	local v8 = keyboardTop - data.layerTopY - data.keyboardGap

	local v9 = y + 2 * data.chipPadding

	return {
		fontSize = v7,
		size = UDim2.fromOffset(v5, y),
		position = UDim2.new(0.5, 0, 0, v8 - v9 / 2)
	}
end

return computeEditorChipLayout
