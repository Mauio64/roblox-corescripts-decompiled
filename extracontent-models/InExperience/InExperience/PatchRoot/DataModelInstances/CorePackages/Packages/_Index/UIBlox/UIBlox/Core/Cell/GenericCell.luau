local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local t = require(parent3.t)

local GenericTextLabel = require(parent.Text.GenericTextLabel.GenericTextLabel)
local Interactable = require(parent.Control.Interactable)
local validateColorInfo = require(parent2.Core.Style.Validator.validateColorInfo)
local validateFontInfo = require(parent2.Core.Style.Validator.validateFontInfo)

local extended = Roact.PureComponent:extend("GenericCell")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { rightContentWidth = 0, leftContentWidth = 0, isDisabled = false }

function extended.render(p)
	assert(p.validateProps(p.props))

	return Roact.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, BackgroundTransparency = 1 },
		{
			Interactable = Roact.createElement(Interactable, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = p.props.colorStyle.Color,
				BackgroundTransparency = p.props.colorStyle.Transparency,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				[Roact.Event.Activated] = not p.props.isDisabled and p.props.onActivated,
				[Roact.Ref] = p.props.controlRef,
				NextSelectionUp = p.props.NextSelectionUp,
				NextSelectionDown = p.props.NextSelectionDown,
				NextSelectionLeft = p.props.NextSelectionLeft,
				NextSelectionRight = p.props.NextSelectionRight,
				SelectionImageObject = p.props.SelectionImageObject,
				isDisabled = p.props.isDisabled,
				onStateChanged = p.props.onStateChanged
			}, {
				Contents = Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), LayoutOrder = 1 },
					{
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
							Size = UDim2.new(1, -p.props.rightContentWidth - p.props.leftContentWidth, 1, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 2
						}, {
							UIListLayout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Center
							}),
							TitleText = p.props.titleText and Roact.createElement(GenericTextLabel, {
								Size = UDim2.new(1, 0, 1, 0),
								colorStyle = p.props.textStyle,
								fontStyle = p.props.fontStyle,
								Text = p.props.titleText,
								LayoutOrder = 1,
								TextXAlignment = Enum.TextXAlignment.Left
							}),
							SubTitleText = p.props.subtitleText and Roact.createElement(GenericTextLabel, {
								Size = UDim2.new(1, 0, 1, 0),
								colorStyle = p.props.subtitleTextStyle,
								fontStyle = p.props.subtitleFontStyle,
								Text = p.props.subtitleText,
								LayoutOrder = 2,
								TextXAlignment = Enum.TextXAlignment.Left
							})
						}),
						RightContent = p.props.renderRightContent and p.props.renderRightContent(),
						LeftContent = p.props.renderLeftContent and p.props.renderLeftContent()
					}
				),
				Divider = Roact.createElement("Frame", {
					Size = UDim2.new(1, -24, 0, 1),
					Position = UDim2.new(0, 24, 1, -1),
					BorderSizePixel = 0,
					BackgroundColor3 = p.props.dividerStyle.Color,
					BackgroundTransparency = p.props.dividerStyle.Transparency
				})
			})
		}
	)
end

return Roact.forwardRef(function(p, controlRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { controlRef = controlRef }))
end)
