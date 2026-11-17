local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Emoji = require(parent.Enum.Emoji)
local constants = require(parent.constants)

local function getEmojiString(emoji: string) -- 1 equivalent call inferred from this helper
	if not Emoji.isEnumValue(emoji) then
		return ""
	end

	return constants[emoji.rawValue()]
end

local function Emoji2(props)
	return React.createElement(props.onActivated and "TextButton" or "TextLabel", {
		Size = UDim2.fromScale(0, 1),
		Text = getEmojiString(props.emoji), -- inferred equivalent call
		TextColor3 = Color3.fromHex("#fff"),
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = normalizeFontFace(props.textFont),
		TextSize = props.textSize,
		Position = props.Position,
		BackgroundTransparency = 1,
		[React.Event.Activated] = props.onActivated
	})
end

return Emoji2
