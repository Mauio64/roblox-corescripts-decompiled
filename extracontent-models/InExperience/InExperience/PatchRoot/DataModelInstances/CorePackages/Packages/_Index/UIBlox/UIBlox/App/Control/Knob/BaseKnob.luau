local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)

local RoactGamepad = require(parent3.RoactGamepad)
local Images = require(parent.ImageSet.Images)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local Interactable = require(parent2.Core.Control.Interactable)
local ControlState = require(parent2.Core.Control.Enum.ControlState)
local withStyle = require(parent2.Core.Style.withStyle)
local validateColorInfo = require(parent2.Core.Style.Validator.validateColorInfo)
local extended = Roact.Component:extend("BaseKnob")

local v = {
	[ControlState.Default] = { Color = Color3.fromRGB(0, 0, 0), Transparency = 0.7 },
	[ControlState.Hover] = { Color = Color3.fromRGB(0, 0, 0), Transparency = 0.5 }
}

local udims = {
	[ControlState.Default] = UDim2.fromOffset(48, 48),
	[ControlState.Hover] = UDim2.fromOffset(48, 48),
	[ControlState.Pressed] = UDim2.fromOffset(0, 0),
	[ControlState.Disabled] = UDim2.fromOffset(0, 0),
	[ControlState.Selected] = UDim2.fromOffset(52, 52),
	[ControlState.SelectedPressed] = UDim2.fromOffset(42, 42)
}

local v2 = {
	[ControlState.Default] = "component_assets/dropshadow_28",
	[ControlState.Hover] = "component_assets/dropshadow_28",
	[ControlState.Selected] = "component_assets/circle_52_stroke_3",
	[ControlState.SelectedPressed] = "component_assets/circle_42_stroke_3"
}

extended.validateProps = t.interface({
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

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	userInteractionEnabled = true,
	isDisabled = false,
	isRoactGamepadEnabled = true
}

function extended:init()
	self:setState({ controlState = ControlState.Initialize })

	function self.onStateChanged(p, controlState)
		self:setState({ controlState = controlState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, controlState)
		end
	end
end

function extended.render(data)
	return withStyle(function(p)
		local v3 = data.props.colorMap[data.state.controlState] or data.props.colorMap[ControlState.Default]
		local size = udims[data.state.controlState] or udims[ControlState.Default]
		local v4 = v2[data.state.controlState] or v2[ControlState.Default]
		local v5 = data.state.controlState == ControlState.Selected
			or data.state.controlState == ControlState.SelectedPressed
		local v6 = v[data.state.controlState] or v[ControlState.Default]

		if v5 then
			v6 = p.Theme.SelectionCursor
		end

		local createElement = Roact.createElement
		local v7 = {
			AnchorPoint = data.props.anchorPoint,
			LayoutOrder = data.props.layoutOrder,
			Position = data.props.position,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(28, 28)
		}
		local v8 = {
			KnobShadow = Roact.createElement(ImageSetComponent.Label, {
				Size = size,
				Position = UDim2.new(0.5, 0, 0.5, v5 and 0 or 2),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Images[v4],
				ImageColor3 = v6.Color,
				ImageTransparency = v6.Transparency,
				Active = true,
				BackgroundTransparency = 1
			}),
			KnobButton = 0
		}

		local createElement2 = Roact.createElement
		local v9

		if data.props.isRoactGamepadEnabled then
			v9 = RoactGamepad.Focusable[Interactable]
		else
			v9 = Interactable
		end

		v8.KnobButton = createElement2(v9, {
			Size = UDim2.fromScale(1, 1),
			isDisabled = data.props.isDisabled,
			onStateChanged = data.onStateChanged,
			userInteractionEnabled = data.props.userInteractionEnabled,
			BackgroundTransparency = 1,
			Image = Images["component_assets/circle_29"],
			ImageColor3 = v3.Color,
			ImageTransparency = v3.Transparency,
			[Roact.Ref] = data.props.forwardedRef,
			[Roact.Event.Activated] = data.props.onActivated,
			NextSelectionLeft = data.props.NextSelectionLeft,
			NextSelectionRight = data.props.NextSelectionRight,
			NextSelectionUp = data.props.NextSelectionUp,
			NextSelectionDown = data.props.NextSelectionDown
		})
		return createElement("Frame", v7, v8)
	end)
end

return extended
