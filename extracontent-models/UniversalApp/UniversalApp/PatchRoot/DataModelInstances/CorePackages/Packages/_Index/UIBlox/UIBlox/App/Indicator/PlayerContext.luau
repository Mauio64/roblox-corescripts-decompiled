local App = script:FindFirstAncestor("App")
local AppParent = App.Parent
local Core = AppParent.Core
local AppParentParent = AppParent.Parent
local t = require(AppParentParent.t)
local Roact = require(AppParentParent.Roact)
local ControlState = require(Core.Control.Enum.ControlState)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(Core.Style.withStyle)
local getContentStyle = require(Core.Button.getContentStyle)
local getIconSize = require(App.ImageSet.getIconSize)
local ImageSetComponent = require(AppParent.Core.ImageSet.ImageSetComponent)
local IconSize = require(App.ImageSet.Enum.IconSize)
local validateFontInfo = require(AppParent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(AppParent.Core.Style.Validator.validateTypographyInfo)
local validateColorInfo = require(AppParent.Core.Style.Validator.validateColorInfo)
local v17 = Roact.PureComponent:extend("PlayerContext")
local t1 = {
	[ControlState.Default] = "TextDefault"
}
local t2 = {
	[ControlState.Default] = "IconOnHover",
	[ControlState.Hover] = "IconDefault"
}

local function doesNotUseScale(p1) -- line: 33
	if p1.X.Scale ~= 0 or p1.Y.Scale ~= 0 then
		return false, "Only Offset values are allowed"
	end

	return true
end

v17.validateProps = t.strictInterface({
	text = t.optional(t.string),
	icon = t.optional(t.union(t.string, t.table)),
	iconSize = t.optional(t.intersection(t.UDim2, doesNotUseScale)),
	iconColor = t.optional(t.Color3),
	iconTransparency = t.optional(t.number),
	onActivated = t.optional(t.callback),
	Selectable = t.optional(t.boolean),
	fontStyle = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	textHeight = t.optional(t.number),
	textColorStyle = t.optional(validateColorInfo),
	iconPadding = t.optional(t.number),
	iconTextSpacing = t.optional(t.number),
	layoutOrder = t.optional(t.number),
	horizontalAlignment = t.optional(t.EnumItem),
	textXAlignment = t.optional(t.EnumItem)
})
v17.defaultProps = {
	text = "",
	icon = nil,
	Selectable = true,
	textHeight = 28,
	iconPadding = 4,
	iconTextSpacing = 4,
	layoutOrder = 1,
	iconSize = UDim2.fromOffset(getIconSize(IconSize.Small), getIconSize(IconSize.Small)),
	horizontalAlignment = Enum.HorizontalAlignment.Left,
	textXAlignment = Enum.TextXAlignment.Left
}

function v17.init(p2) -- line: 87
	p2.state = {}
end
function v17.render(p3) -- line: 91
	-- upvalues: withStyle (copy), getContentStyle (copy), t2 (copy), t1 (copy), Roact (copy), ImageSetComponent (copy), GenericTextLabel (copy)
	local controlState = p3.state.controlState
	local text = p3.props.text
	local icon = p3.props.icon
	local iconSize = p3.props.iconSize
	local horizontalAlignment = p3.props.horizontalAlignment
	local onActivated = p3.props.onActivated

	return withStyle(function(p4) -- line: 101
		-- upvalues: getContentStyle (copy), t2 (copy), controlState (copy), t1 (copy), onActivated (copy), p3 (copy), iconSize (copy), Roact (copy), horizontalAlignment (copy), icon (copy), ImageSetComponent (copy), text (copy), GenericTextLabel (copy)
		local v31 = getContentStyle(t2, controlState, p4)
		local v32 = getContentStyle(t1, controlState, p4)
		local v33 = onActivated and v31 or v32
		local iconTransparency = p3.props.iconTransparency

		if not p3.props.iconTransparency then
			iconTransparency = if not p3.props.iconColor then v33.Transparency else 0
		end

		local iconColor = p3.props.iconColor

		if not p3.props.iconColor then
			iconColor = v33.Color
		end

		local textHeight = p3.props.textHeight
		local v37 = p3.props.textColorStyle or if not onActivated then v32 else v31
		local iconPadding = p3.props.iconPadding
		local iconTextSpacing = p3.props.iconTextSpacing
		local v40 = iconSize.X.Offset + iconPadding * 2
		local v41 = iconSize.Y.Offset + iconPadding * 2
		local v42 = p3.props.fontStyle or p4.Font.CaptionHeader

		return Roact.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 0, textHeight),
			BackgroundTransparency = 1,
			Selectable = p3.props.Selectable,
			Active = not not onActivated,
			LayoutOrder = p3.props.layoutOrder,
			[Roact.Event.Activated] = onActivated
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = horizontalAlignment,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, iconTextSpacing)
			}),
			IconFrame = icon and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v40, v41)
			}, {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				icon = Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = iconSize,
					Image = icon,
					ImageColor3 = iconColor,
					ImageTransparency = iconTransparency
				})
			}),
			Text = text and Roact.createElement(GenericTextLabel, {
				TextWrapped = true,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, not icon and 0 or -(v40 + iconTextSpacing), 0, 0),
				Text = text,
				TextXAlignment = p3.props.textXAlignment,
				fontStyle = v42,
				colorStyle = v37,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		})
	end)
end

return v17
