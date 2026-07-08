local ParentParent = script.Parent.Parent.Parent
local Core = ParentParent.Core
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Cryo = require(ParentParentParent.Cryo)
local Foundation = require(ParentParentParent.Foundation)
local Interactable = require(Core.Control.Interactable)
local ControlState = require(Core.Control.Enum.ControlState)
local getContentStyle = require(Core.Button.getContentStyle)
local withStyle = require(ParentParent.Core.Style.withStyle)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local IconSize = require(ParentParent.App.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.App.ImageSet.getIconSize)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local validateFontInfo = require(ParentParent.Core.Style.Validator.validateFontInfo)
local validateImage = require(Core.ImageSet.Validator.validateImage)
local v19 = Roact.PureComponent:extend("SegmentedControlTabName")

function v19.init(p1) -- line: 32
	-- upvalues: ControlState (copy)
	p1.state = {
		controlState = ControlState.Initialize
	}

	function p1.onStateChanged(p2, p3) -- line: 37
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p3
		})

		if p1.props.onStateChanged then
			p1.props.onStateChanged(p2, p3)
		end
	end
end

local v20 = t.interface({
	[ControlState.Default] = t.string
})

v19.validateProps = t.interface({
	icon = t.optional(validateImage),
	text = t.optional(t.string),
	fontStyle = t.optional(validateFontInfo),
	textStateColorMap = t.optional(v20),
	iconStateColorMap = t.optional(v20),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	onActivated = t.callback,
	onStateChanged = t.optional(t.callback),
	userInteractionEnabled = t.optional(t.boolean),
	isSelectedStyle = t.optional(t.boolean)
})
v19.defaultProps = {
	isDisabled = false,
	isLoading = false,
	isSelectedStyle = false,
	SliceCenter = Rect.new(8, 8, 9, 9),
	textStateColorMap = {
		[ControlState.Default] = "TextDefault",
		[ControlState.Hover] = "TextEmphasis"
	},
	buttonStateColorMap = {
		[ControlState.Default] = "SecondaryContent"
	}
}

function v19.render(p4) -- line: 101
	-- upvalues: withStyle (copy), ControlState (copy), getContentStyle (copy), Roact (copy), Skeleton (copy), ImageSetComponent (copy), getIconSize (copy), IconSize (copy), GenericTextLabel (copy), Interactable (copy), Cryo (copy)
	return withStyle(function(p5) -- line: 102
		-- upvalues: p4 (copy), ControlState (copy), getContentStyle (copy), Roact (copy), Skeleton (copy), ImageSetComponent (copy), getIconSize (copy), IconSize (copy), GenericTextLabel (copy), Interactable (copy), Cryo (copy)
		local controlState = p4.state.controlState
		local text = p4.props.text
		local icon = p4.props.icon
		local isLoading = p4.props.isLoading
		local isDisabled = p4.props.isDisabled
		local buttonStateColorMap = p4.props.buttonStateColorMap
		local contentStateColorMap = p4.props.contentStateColorMap
		local v33 = p4.props.textStateColorMap or contentStateColorMap
		local v34 = p4.props.iconStateColorMap or contentStateColorMap

		if isLoading then
			isDisabled = true
		end

		local v35 = controlState

		if p4.props.isDisabled then
			v35 = ControlState.Disabled
		elseif p4.props.isSelectedStyle then
			v35 = ControlState.Hover
		end

		local v36 = getContentStyle(buttonStateColorMap, controlState, p5)
		local v37 = text and getContentStyle(v33, v35, p5)
		local v38 = icon and getContentStyle(v34, controlState, p5)
		local v39 = p4.props.fontStyle or p5.Font.Header2
		local v40 = if not isLoading then p4.props[Roact.Children] or {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5)
			}),
			Icon = icon and Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(0, getIconSize(IconSize.Medium), 0, getIconSize(IconSize.Medium)),
				Image = icon,
				ImageColor3 = v38.Color,
				ImageTransparency = v38.Transparency
			}) or nil,
			Text = text and Roact.createElement(GenericTextLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.X,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = text,
				fontStyle = v39,
				colorStyle = v37
			}) or nil
		} else {
			isLoadingShimmer = Roact.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1)
			})
		}

		return Roact.createElement(Interactable, Cryo.Dictionary.join(p4.props, {
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
			isDisabled = isDisabled,
			onStateChanged = p4.onStateChanged,
			userInteractionEnabled = p4.props.userInteractionEnabled,
			Image = Cryo.None,
			ScaleType = Enum.ScaleType.Slice,
			ImageColor3 = v36.Color,
			ImageTransparency = v36.Transparency,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			[Roact.Event.Activated] = p4.props.onActivated
		}), {
			ButtonContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, v40)
		})
	end)
end

return v19
