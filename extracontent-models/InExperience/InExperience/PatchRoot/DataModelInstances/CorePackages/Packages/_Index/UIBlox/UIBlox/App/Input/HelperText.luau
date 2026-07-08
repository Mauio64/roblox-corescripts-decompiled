local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local useStyle = require(ParentParent.Core.Style.useStyle)

local function HelperText(t1: {[any]: any}) -- line: 18
	-- upvalues: useStyle (copy), React (copy)
	local HelperText2 = useStyle().Tokens.Component.HelperText
	local Typography = HelperText2.Base.Typography
	local v9 = if not t1.error then HelperText2.Base.ContentColor else HelperText2.Error.ContentColor

	return React.createElement("TextLabel", {
		TextWrapped = true,
		BackgroundTransparency = 1,
		Text = t1.text,
		TextTransparency = v9.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = v9.Color3,
		Font = Typography.Font,
		TextSize = Typography.FontSize,
		LineHeight = Typography.LineHeight,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	})
end

return HelperText
