local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Translator = require(parent.Translations.Translator)
local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = require(parent.Core.Style.useStyle)

local function labelText(text: string, required: boolean?) -- 1 equivalent call inferred from this helper
	if required == nil or required == React.None then
		return text
	end

	if required then
		return text .. "*"
	end

	return (Translator:FormatByKey("CommonUI.Controls.Input.Optional", { inputLabel = text }))
end

local function InputLabel(props)
	local v = useStyle()

	local bodySmall = v.Tokens.Typography.BodySmall
	local default = v.Tokens.Color.Content.Default

	return React.createElement("TextLabel", {
		Text = labelText(props.text, props.required), -- inferred equivalent call
		TextTransparency = default.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextColor3 = default.Color3,
		FontFace = normalizeFontFace(bodySmall.Font),
		TextSize = bodySmall.FontSize,
		LineHeight = bodySmall.LineHeight,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder
	})
end

return InputLabel
