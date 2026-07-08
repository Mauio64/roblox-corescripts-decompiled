local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParentParent.Core
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local React = require(ParentParentParentParent.React)
local t = require(ParentParentParentParent.t)
local Cryo = require(ParentParentParentParent.Cryo)
local Images = require(ParentParent.ImageSet.Images)
local useCursor = require(ParentParent.SelectionCursor.useCursor)
local ControlState = require(Core.Control.Enum.ControlState)
local GenericButton = require(Core.Button.GenericButton)
local validateImage = require(Core.ImageSet.Validator.validateImage)
local withStyle = require(Core.Style.withStyle)
local v15 = Roact.PureComponent:extend("ComboButton")
local uDim = UDim.new(0, 8)
local t1 = {
	[ControlState.Default] = "ContextualPrimaryDefault",
	[ControlState.Hover] = "ContextualPrimaryOnHover"
}
local t2 = {
	[ControlState.Default] = "ContextualPrimaryContent"
}

v15.validateProps = t.strictInterface({
	button = t.strictInterface({
		icon = t.optional(validateImage),
		text = t.optional(t.string),
		isDisabled = t.optional(t.boolean),
		onActivated = t.callback
	}),
	overflow = t.strictInterface({
		icon = t.optional(validateImage),
		isDisabled = t.optional(t.boolean),
		onActivated = t.callback
	}),
	position = t.optional(t.UDim2),
	size = t.optional(t.UDim2),
	layoutOrder = t.optional(t.number),
	cursor = t.optional(t.table),
	testId = t.optional(t.string)
})
v15.defaultProps = {
	testId = "--uiblox-combo-button",
	size = UDim2.fromScale(1, 1)
}

function v15.init(p1) -- line: 77
	-- upvalues: ControlState (copy)
	p1:setState({
		buttonControlState = ControlState.Initialize,
		overflowControlState = ControlState.Initialize
	})

	function p1.onButtonStateChanged(_, p3) -- line: 80
		-- upvalues: p1 (copy)
		p1:setState({
			buttonControlState = p3
		})
	end
	function p1.onOverflowStateChanged(_, p5) -- line: 84
		-- upvalues: p1 (copy)
		p1:setState({
			overflowControlState = p5
		})
	end
end
function v15.render(p6) -- line: 89
	-- upvalues: withStyle (copy)
	return withStyle(function(p7) -- line: 90
		-- upvalues: p6 (copy)
		return p6:renderWithProviders(p7, nil, nil)
	end)
end
function v15.renderWithProviders(p8, _, _, _) -- line: 95
	-- upvalues: Roact (copy), React (copy), GenericButton (copy), Images (copy), t1 (copy), t2 (copy)
	local size = p8.props.size
	local uDim2 = UDim2.new(1, -40, 1, 0)
	local uDim2_2 = UDim2.new(0, 39, 1, 0)

	return Roact.createElement("Frame", {
		LayoutOrder = p8.props.layoutOrder,
		Position = p8.props.position,
		Size = size,
		BackgroundTransparency = 1,
		[React.Tag] = if not p8.props.testId then nil else `data-testid={ p8.props.testId }`
	}, {
		Button = Roact.createElement(GenericButton, {
			isHoverBackgroundEnabled = true,
			ZIndex = 0,
			Position = UDim2.fromScale(0, 0),
			Size = uDim2,
			buttonImage = Images["component_assets/bulletLeft_17"],
			buttonStateColorMap = t1,
			contentStateColorMap = t2,
			hoverImage = Images["component_assets/bulletLeft_17"],
			icon = p8.props.button.icon,
			isDisabled = p8.props.button.isDisabled,
			onActivated = p8.props.button.onActivated,
			onStateChanged = p8.onButtonStateChanged,
			SelectionImageObject = p8.props.cursor,
			text = p8.props.button.text
		}),
		Overflow = Roact.createElement(GenericButton, {
			ZIndex = 0,
			isHoverBackgroundEnabled = true,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = uDim2_2,
			buttonImage = Images["component_assets/bulletRight_17"],
			buttonStateColorMap = t1,
			contentStateColorMap = t2,
			hoverImage = Images["component_assets/bulletRight_17"],
			icon = p8.props.overflow.icon or Images["icons/actions/truncationExpand"],
			isDisabled = p8.props.overflow.isDisabled,
			onActivated = p8.props.overflow.onActivated,
			onStateChanged = p8.onOverflowStateChanged,
			SelectionImageObject = p8.props.cursor
		})
	})
end
function ComboButtonFunctionalWrapper(p12) -- line: 142
	-- upvalues: useCursor (copy), uDim (copy), Roact (copy), v15 (copy), Cryo (copy)
	local v30 = useCursor(uDim)

	return Roact.createElement(v15, Cryo.Dictionary.join(p12, {
		cursor = v30
	}))
end

local v19 = Roact.PureComponent:extend("ComboButtonOuterWrapper")

v19.validateProps = v15.validateProps

function v19.render(p13) -- line: 156
	-- upvalues: Roact (copy)
	return Roact.createElement(ComboButtonFunctionalWrapper, p13.props)
end

return v19
