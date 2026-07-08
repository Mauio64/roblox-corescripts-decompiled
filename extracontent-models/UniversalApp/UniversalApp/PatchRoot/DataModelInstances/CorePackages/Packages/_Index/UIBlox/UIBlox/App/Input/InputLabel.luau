local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Translator = require(ParentParent.Translations.Translator)
local React = require(ParentParentParent.React)
local useStyle = require(ParentParent.Core.Style.useStyle)

local function labelText(s1: string, b1: boolean?) -- line: 21
	-- upvalues: React (copy), Translator (copy)
	if b1 == nil or b1 == React.None then
		return s1
	end

	if b1 then
		return s1 .. "*"
	end

	return (Translator:FormatByKey("CommonUI.Controls.Input.Optional", {
		inputLabel = s1
	}))
end
local function InputLabel(t1: {[any]: any}) -- line: 31
	-- upvalues: useStyle (copy), React (copy), Translator (copy)
	local InputLabel2 = useStyle().Tokens.Component.InputLabel
	local Typography = InputLabel2.Base.Typography
	local ContentColor = InputLabel2.Base.ContentColor
	local createElement = React.createElement
	local t2 = {
		TextWrapped = true,
		BackgroundTransparency = 1
	}
	local text = t1.text
	local required = t1.required

	t2.Text = if required ~= nil and required ~= React.None then if not required then Translator:FormatByKey("CommonUI.Controls.Input.Optional", {
		inputLabel = text
	}) else text .. "*" else text
	t2.TextTransparency = ContentColor.Transparency
	t2.TextXAlignment = Enum.TextXAlignment.Left
	t2.TextYAlignment = Enum.TextYAlignment.Top
	t2.TextColor3 = ContentColor.Color3
	t2.Font = Typography.Font
	t2.TextSize = Typography.FontSize
	t2.LineHeight = Typography.LineHeight
	t2.Size = UDim2.new(1, 0, 0, 0)
	t2.AutomaticSize = Enum.AutomaticSize.Y
	t2.LayoutOrder = t1.LayoutOrder

	return createElement("TextLabel", t2)
end

return InputLabel
