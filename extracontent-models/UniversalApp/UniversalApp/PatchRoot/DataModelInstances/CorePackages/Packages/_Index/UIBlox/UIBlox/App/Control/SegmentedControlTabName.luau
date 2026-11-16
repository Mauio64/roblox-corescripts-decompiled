local parent = script.Parent.Parent.Parent
local core = parent.Core
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)

local Interactable = require(core.Control.Interactable)

local ControlState = require(core.Control.Enum.ControlState)
local getContentStyle = require(core.Button.getContentStyle)

local withStyle = require(parent.Core.Style.withStyle)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local IconSize = require(parent.App.ImageSet.Enum.IconSize)
local getIconSize = require(parent.App.ImageSet.getIconSize)
local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)
local validateFontInfo = require(parent.Core.Style.Validator.validateFontInfo)

local validateImage = require(core.ImageSet.Validator.validateImage)

local extended = Roact.PureComponent:extend("SegmentedControlTabName")

function extended:init()
	self.state = { controlState = ControlState.Initialize }

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end
end

local v = t.interface({ [ControlState.Default] = t.string })

extended.validateProps = t.interface({
	icon = t.optional(validateImage),
	text = t.optional(t.string),
	fontStyle = t.optional(validateFontInfo),
	textStateColorMap = t.optional(v),
	iconStateColorMap = t.optional(v),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	onActivated = t.callback,
	onStateChanged = t.optional(t.callback),
	userInteractionEnabled = t.optional(t.boolean),
	isSelectedStyle = t.optional(t.boolean)
})

extended.defaultProps = {
	isDisabled = false,
	isLoading = false,
	isSelectedStyle = false,
	SliceCenter = Rect.new(8, 8, 9, 9),
	textStateColorMap = {
		[ControlState.Default] = "TextDefault",
		[ControlState.Hover] = "TextEmphasis"
	},
	buttonStateColorMap = { [ControlState.Default] = "SecondaryContent" }
}

function extended.render(data)
	return withStyle(function(p)
		local controlState = data.state.controlState

		local text = data.props.text
		local icon = data.props.icon
		local isLoading = data.props.isLoading
		local isDisabled = data.props.isDisabled

		local buttonStateColorMap = data.props.buttonStateColorMap
		local contentStateColorMap = data.props.contentStateColorMap
		local textStateColorMap = data.props.textStateColorMap or contentStateColorMap
		local iconStateColorMap = data.props.iconStateColorMap or contentStateColorMap
		local v2

		if data.props.isDisabled then
			v2 = ControlState.Disabled
		elseif data.props.isSelectedStyle then
			v2 = ControlState.Hover
		else
			v2 = controlState
		end

		local contentStyle = getContentStyle(buttonStateColorMap, controlState, p)
		local colorStyle = text and getContentStyle(textStateColorMap, v2, p)
		local v3 = icon and getContentStyle(iconStateColorMap, controlState, p)
		local fontStyle = data.props.fontStyle or p.Font.Header2
		local v4

		if isLoading then
			v4 = {
				isLoadingShimmer = Roact.createElement(Skeleton, { Size = UDim2.fromScale(1, 1) })
			}
		else
			v4 = data.props[Roact.Children] or {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5)
				}),
				Icon = icon and Roact.createElement(ImageSetComponent.Label, {
					Size = UDim2.new(0, getIconSize(IconSize.Medium), 0, getIconSize(IconSize.Medium)),
					BackgroundTransparency = 1,
					Image = icon,
					ImageColor3 = v3.Color,
					ImageTransparency = v3.Transparency,
					LayoutOrder = 1
				}) or nil,
				Text = text and Roact.createElement(GenericTextLabel, {
					AutomaticSize = Enum.AutomaticSize.X,
					TextTruncate = Enum.TextTruncate.AtEnd,
					BackgroundTransparency = 1,
					Text = text,
					fontStyle = fontStyle,
					colorStyle = colorStyle,
					LayoutOrder = 2
				}) or nil
			}
		end

		return Roact.createElement(Interactable, Cryo.Dictionary.join(data.props, {
			icon = Cryo.None,
			text = Cryo.None,
			buttonStateColorMap = Cryo.None,
			contentStateColorMap = Cryo.None,
			textStateColorMap = Cryo.None,
			iconStateColorMap = Cryo.None,
			onActivated = Cryo.None,
			isLoading = Cryo.None,
			isSelectedStyle = Cryo.None,
			[Roact.Children] = Cryo.None,
			isDisabled = isLoading and true or isDisabled,
			onStateChanged = data.onStateChanged,
			userInteractionEnabled = data.props.userInteractionEnabled,
			Image = Cryo.None,
			ScaleType = Enum.ScaleType.Slice,
			ImageColor3 = contentStyle.Color,
			ImageTransparency = contentStyle.Transparency,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			[Roact.Event.Activated] = data.props.onActivated
		}), {
			ButtonContent = Roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
				v4
			)
		})
	end)
end

return extended
