local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local Cryo = require(ParentParentParentParent.Cryo)
local t = require(ParentParentParentParent.t)
local GenericTextLabel = require(ParentParent.Text.GenericTextLabel.GenericTextLabel)
local Interactable = require(ParentParent.Control.Interactable)
local validateColorInfo = require(ParentParentParent.Core.Style.Validator.validateColorInfo)
local validateFontInfo = require(ParentParentParent.Core.Style.Validator.validateFontInfo)
local v11 = Roact.PureComponent:extend("GenericCell")

v11.validateProps = t.strictInterface({
	onActivated = t.optional(t.callback),
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	onStateChanged = t.callback,
	titleText = t.optional(t.string),
	subtitleText = t.optional(t.string),
	renderRightContent = t.optional(t.callback),
	rightContentWidth = t.optional(t.number),
	renderLeftContent = t.optional(t.callback),
	leftContentWidth = t.optional(t.number),
	colorStyle = validateColorInfo,
	textStyle = t.optional(validateColorInfo),
	fontStyle = t.optional(validateFontInfo),
	subtitleTextStyle = t.optional(validateColorInfo),
	subtitleFontStyle = t.optional(validateFontInfo),
	dividerStyle = t.table,
	controlRef = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	SelectionImageObject = t.optional(t.table)
})
v11.defaultProps = {
	rightContentWidth = 0,
	leftContentWidth = 0,
	isDisabled = false
}

function v11.render(p1) -- line: 84
	-- upvalues: Roact (copy), Interactable (copy), GenericTextLabel (copy)
	assert(p1.validateProps(p1.props))

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Interactable = Roact.createElement(Interactable, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p1.props.colorStyle.Color,
			BackgroundTransparency = p1.props.colorStyle.Transparency,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			[Roact.Event.Activated] = not p1.props.isDisabled and p1.props.onActivated,
			[Roact.Ref] = p1.props.controlRef,
			NextSelectionUp = p1.props.NextSelectionUp,
			NextSelectionDown = p1.props.NextSelectionDown,
			NextSelectionLeft = p1.props.NextSelectionLeft,
			NextSelectionRight = p1.props.NextSelectionRight,
			SelectionImageObject = p1.props.SelectionImageObject,
			isDisabled = p1.props.isDisabled,
			onStateChanged = p1.props.onStateChanged
		}, {
			Contents = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24),
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12)
				}),
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Frame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, -p1.props.rightContentWidth - p1.props.leftContentWidth, 1, 0)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					TitleText = p1.props.titleText and Roact.createElement(GenericTextLabel, {
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 1, 0),
						colorStyle = p1.props.textStyle,
						fontStyle = p1.props.fontStyle,
						Text = p1.props.titleText,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					SubTitleText = p1.props.subtitleText and Roact.createElement(GenericTextLabel, {
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 1, 0),
						colorStyle = p1.props.subtitleTextStyle,
						fontStyle = p1.props.subtitleFontStyle,
						Text = p1.props.subtitleText,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}),
				RightContent = p1.props.renderRightContent and p1.props.renderRightContent(),
				LeftContent = p1.props.renderLeftContent and p1.props.renderLeftContent()
			}),
			Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, -24, 0, 1),
				Position = UDim2.new(0, 24, 1, -1),
				BackgroundColor3 = p1.props.dividerStyle.Color,
				BackgroundTransparency = p1.props.dividerStyle.Transparency
			})
		})
	})
end

return Roact.forwardRef(function(p2, p3) -- line: 165
	-- upvalues: Roact (copy), v11 (copy), Cryo (copy)
	return Roact.createElement(v11, Cryo.Dictionary.join(p2, {
		controlRef = p3
	}))
end)
