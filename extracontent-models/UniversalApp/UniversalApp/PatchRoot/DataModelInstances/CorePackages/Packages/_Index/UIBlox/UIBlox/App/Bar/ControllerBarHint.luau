local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local KeyLabel = require(ParentParent.Menu.KeyLabel.KeyLabel)
local ControllerBarHintInternalPadding = require(script.Parent.BarConstants).ControllerBarHintInternalPadding
local v10 = Roact.PureComponent:extend("ControllerBarHint")

v10.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	keyCode = t.enum(Enum.KeyCode),
	text = t.string,
	maxWidth = t.optional(t.number),
	hintTextSize = t.optional(t.number)
})

function v10.render(p1) -- line: 34
	-- upvalues: withStyle (copy), Roact (copy), ControllerBarHintInternalPadding (copy), KeyLabel (copy), GenericTextLabel (copy)
	return withStyle(function(p2) -- line: 35
		-- upvalues: Roact (copy), p1 (copy), ControllerBarHintInternalPadding (copy), KeyLabel (copy), GenericTextLabel (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p1.props.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.X
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, ControllerBarHintInternalPadding)
			}),
			ControllerBarHintIcon = Roact.createElement(KeyLabel, {
				LayoutOrder = 1,
				iconThemeKey = "IconEmphasis",
				keyCode = p1.props.keyCode
			}),
			ControllerBarHintText = Roact.createElement(GenericTextLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				TextSize = p1.props.hintTextSize,
				maxSize = p1.props.maxWidth and Vector2.new(p1.props.maxWidth) or nil,
				fontStyle = p2Font.Header2,
				colorStyle = Theme.TextEmphasis,
				AutomaticSize = not p1.props.maxWidth and Enum.AutomaticSize.X or nil,
				TextTransparency = Theme.TextEmphasis.TextTransparency,
				fluidSizing = not not p1.props.maxWidth,
				Text = p1.props.text,
				TextTruncate = p1.props.maxWidth and Enum.TextTruncate.AtEnd or nil,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end)
end

return v10
