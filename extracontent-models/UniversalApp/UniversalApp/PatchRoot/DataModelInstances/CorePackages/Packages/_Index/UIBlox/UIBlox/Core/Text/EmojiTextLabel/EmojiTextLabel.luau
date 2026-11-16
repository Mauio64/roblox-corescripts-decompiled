local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)

require(parent.App.Style.StyleTypes)
require(parent.Core.Style.Validator.validateFontInfo)
require(parent.Core.Style.Validator.validateColorInfo)
local useStyle = require(parent.Core.Style.useStyle)
local GetTextSize = require(parent.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent.Core.Text.GetFontFromFontStyle)

local emoji = parent.Core.Emoji
local Emoji = require(emoji.Emoji)
local Emoji2 = require(emoji.Enum.Emoji)

local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)

local v = { maxSize = Vector2.new(10000, 10000), fluidSizing = false }

local function EmojiTextLabel(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useStyle()
	local enumValue = Emoji2.isEnumValue(joined.emoji)
	local baseSize = v2.Font.BaseSize
	local colorStyle = joined.colorStyle

	local fontStyle = joined.fontStyle
	local textFont = GetFontFromFontStyle(fontStyle)
	local textSize

	if fontStyle.RelativeSize then
		textSize = baseSize * fontStyle.RelativeSize
	else
		textSize = fontStyle.FontSize
	end

	local maxSize = joined.maxSize

	local textSize2 = GetTextSize(joined.Text, textSize, textFont, maxSize)
	local v3 = math.min(textSize2.X, maxSize.X - textSize)

	local joined2 = Cryo.Dictionary.join(joined, {
		emoji = Cryo.None,
		emojiOnActivated = Cryo.None,
		colorStyle = colorStyle,
		Size = UDim2.fromOffset(v3, textSize2.Y)
	})

	return React.createElement(GenericTextLabel, joined2, {
		Emoji = enumValue and React.createElement(Emoji, {
			emoji = joined.emoji,
			onActivated = joined.emojiOnActivated,
			textFont = textFont,
			textSize = textSize,
			Position = UDim2.fromScale(1, 0)
		})
	})
end

return EmojiTextLabel
