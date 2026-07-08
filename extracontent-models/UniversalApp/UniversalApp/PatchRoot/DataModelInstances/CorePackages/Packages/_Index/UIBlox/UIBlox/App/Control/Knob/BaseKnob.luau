local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local Images = require(ParentParent.ImageSet.Images)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local Interactable = require(ParentParentParent.Core.Control.Interactable)
local ControlState = require(ParentParentParent.Core.Control.Enum.ControlState)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local validateColorInfo = require(ParentParentParent.Core.Style.Validator.validateColorInfo)
local v13 = Roact.Component:extend("BaseKnob")
local t1 = {
	[ControlState.Default] = {
		Transparency = 0.7,
		Color = Color3.fromRGB(0, 0, 0)
	},
	[ControlState.Hover] = {
		Transparency = 0.5,
		Color = Color3.fromRGB(0, 0, 0)
	}
}
local t2 = {
	[ControlState.Default] = UDim2.fromOffset(48, 48),
	[ControlState.Hover] = UDim2.fromOffset(48, 48),
	[ControlState.Pressed] = UDim2.fromOffset(0, 0),
	[ControlState.Disabled] = UDim2.fromOffset(0, 0),
	[ControlState.Selected] = UDim2.fromOffset(52, 52),
	[ControlState.SelectedPressed] = UDim2.fromOffset(42, 42)
}
local t3 = {
	[ControlState.Default] = "component_assets/dropshadow_28",
	[ControlState.Hover] = "component_assets/dropshadow_28",
	[ControlState.Selected] = "component_assets/circle_52_stroke_3",
	[ControlState.SelectedPressed] = "component_assets/circle_42_stroke_3"
}

v13.validateProps = t.interface({
	onStateChanged = t.optional(t.callback),
	isDisabled = t.optional(t.boolean),
	userInteractionEnabled = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
	anchorPoint = t.optional(t.Vector2),
	layoutOrder = t.optional(t.number),
	position = t.optional(t.UDim2),
	colorMap = t.strictInterface({
		[ControlState.Default] = validateColorInfo,
		[ControlState.Hover] = validateColorInfo,
		[ControlState.Pressed] = validateColorInfo,
		[ControlState.Disabled] = validateColorInfo,
		[ControlState.Selected] = validateColorInfo,
		[ControlState.SelectedPressed] = validateColorInfo
	}),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	controlRef = t.optional(t.table),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v13.defaultProps = {
	userInteractionEnabled = true,
	isDisabled = false,
	isRoactGamepadEnabled = true,
	anchorPoint = Vector2.new(0.5, 0.5)
}

function v13.init(p1) -- line: 99
	-- upvalues: ControlState (copy)
	p1:setState({
		controlState = ControlState.Initialize
	})

	function p1.onStateChanged(p2, p3) -- line: 104
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p3
		})

		if p1.props.onStateChanged then
			p1.props.onStateChanged(p2, p3)
		end
	end
end
function v13.render(p4) -- line: 114
	-- upvalues: withStyle (copy), ControlState (copy), t2 (copy), t3 (copy), t1 (copy), Roact (copy), ImageSetComponent (copy), Images (copy), RoactGamepad (copy), Interactable (copy)
	return withStyle(function(p5) -- line: 115
		-- upvalues: p4 (copy), ControlState (copy), t2 (copy), t3 (copy), t1 (copy), Roact (copy), ImageSetComponent (copy), Images (copy), RoactGamepad (copy), Interactable (copy)
		local v22 = p4.props.colorMap[p4.state.controlState] or p4.props.colorMap[ControlState.Default]
		local v23 = t2[p4.state.controlState] or t2[ControlState.Default]
		local v24 = t3[p4.state.controlState] or t3[ControlState.Default]
		local v25 = p4.state.controlState == ControlState.Selected or p4.state.controlState == ControlState.SelectedPressed
		local v26 = t1[p4.state.controlState] or t1[ControlState.Default]

		if v25 then
			v26 = p5.Theme.SelectionCursor
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = p4.props.anchorPoint,
			LayoutOrder = p4.props.layoutOrder,
			Position = p4.props.position,
			Size = UDim2.fromOffset(28, 28)
		}, {
			KnobShadow = Roact.createElement(ImageSetComponent.Label, {
				Active = true,
				BackgroundTransparency = 1,
				Size = v23,
				Position = UDim2.new(0.5, 0, 0.5, v25 and 0 or 2),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images[v24],
				ImageColor3 = v26.Color,
				ImageTransparency = v26.Transparency
			}),
			KnobButton = Roact.createElement(if not p4.props.isRoactGamepadEnabled then Interactable else RoactGamepad.Focusable[Interactable], {
				Size = UDim2.fromScale(1, 1),
				isDisabled = p4.props.isDisabled,
				onStateChanged = p4.onStateChanged,
				userInteractionEnabled = p4.props.userInteractionEnabled,
				BackgroundTransparency = 1,
				Image = Images["component_assets/circle_29"],
				ImageColor3 = v22.Color,
				ImageTransparency = v22.Transparency,
				[Roact.Ref] = p4.props.forwardedRef,
				[Roact.Event.Activated] = p4.props.onActivated,
				NextSelectionLeft = p4.props.NextSelectionLeft,
				NextSelectionRight = p4.props.NextSelectionRight,
				NextSelectionUp = p4.props.NextSelectionUp,
				NextSelectionDown = p4.props.NextSelectionDown
			})
		})
	end)
end

return v13
