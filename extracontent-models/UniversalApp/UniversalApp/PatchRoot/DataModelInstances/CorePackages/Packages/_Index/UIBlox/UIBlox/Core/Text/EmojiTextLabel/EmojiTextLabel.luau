local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Cryo = require(ParentParentParent.Cryo)

require(ParentParent.App.Style.StyleTypes)
require(ParentParent.Core.Style.Validator.validateFontInfo)
require(ParentParent.Core.Style.Validator.validateColorInfo)

local useStyle = require(ParentParent.Core.Style.useStyle)
local GetTextSize = require(ParentParent.Core.Text.GetTextSize)
local Emoji = ParentParent.Core.Emoji
local Emoji2 = require(Emoji.Emoji)
local Emoji3 = require(Emoji.Enum.Emoji)
local GenericTextLabel = require(ParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local t1 = {
	fluidSizing = false,
	maxSize = Vector2.new(10000, 10000)
}

local function EmojiTextLabel(t2: {[any]: any}) -- line: 47
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), Emoji3 (copy), GetTextSize (copy), React (copy), GenericTextLabel (copy), Emoji2 (copy)
	local v14 = Cryo.Dictionary.join(t1, t2)
	local v15 = useStyle()
	local v16 = Emoji3.isEnumValue(v14.emoji)
	local BaseSize = v15.Font.BaseSize
	local colorStyle = v14.colorStyle
	local fontStyle = v14.fontStyle
	local fontStyleFont = fontStyle.Font
	local v21 = if not fontStyle.RelativeSize then fontStyle.FontSize else BaseSize * fontStyle.RelativeSize
	local maxSize = v14.maxSize
	local v23 = GetTextSize(v14.Text, v21, fontStyleFont, maxSize)
	local v24 = math.min(v23.X, maxSize.X - v21)
	local v25 = Cryo.Dictionary.join(v14, {
		emoji = Cryo.None,
		emojiOnActivated = Cryo.None,
		colorStyle = colorStyle,
		Size = UDim2.fromOffset(v24, v23.Y)
	})

	return React.createElement(GenericTextLabel, v25, {
		Emoji = v16 and React.createElement(Emoji2, {
			emoji = v14.emoji,
			onActivated = v14.emojiOnActivated,
			textFont = fontStyleFont,
			textSize = v21,
			Position = UDim2.fromScale(1, 0)
		})
	})
end

return EmojiTextLabel
