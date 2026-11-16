local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

local InputSize = require(Foundation.Enums.InputSize)
local Knob = require(Foundation.Components.Knob)
local View = require(Foundation.Components.View)
local colorUtils = require(Foundation.Components.ColorPicker.colorUtils)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Components.Types)

local v = { showSelectionKnob = true }

local function SVPicker(p)
	local v2 = withDefaults(p, v)
	local hue = v2.hue
	local saturation = v2.saturation
	local value = v2.value
	local onChanged = v2.onChanged
	local onDragStarted = v2.onDragStarted
	local onDragEnded = v2.onDragEnded
	local v3 = useTokens()

	local mapped = hue:map(function(p2)
		return Color3.fromHSV(p2, 1, 1)
	end)

	local ref = React.useRef(nil)
	local v4 = React.useCallback(function(vector2: Vector2)
		local current = ref.current

		if not current then
			return
		end

		local svFromPosition, v4 = colorUtils.calculateSVFromPosition(
			vector2,
			current.AbsolutePosition,
			current.AbsoluteSize
		)

		onChanged(svFromPosition, v4)
	end, { onChanged })

	local v5 = React.useCallback(function(_, vector2: Vector2)
		if onDragStarted then
			onDragStarted()
		end

		v4(vector2)
	end, { v4, onDragStarted })

	local v6 = React.useCallback(function(_, vector2: Vector2)
		v4(vector2)
	end, { v4 })

	local createElement = React.createElement

	local v7 = withCommonProps(v2, {
		tag = "size-full radius-small",
		ref = ref,
		ClipsDescendants = true
	})

	local children = {
		DragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v5,
			[React.Event.DragContinue] = v6,
			[React.Event.DragEnd] = onDragEnded
		}),
		Base = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v3.Color.Extended.White.White_100.Color3,
			ZIndex = 1,
			BorderSizePixel = 0
		}),
		Saturation = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = mapped,
				ZIndex = 2,
				BorderSizePixel = 0
			},
			{
				Gradient = React.createElement("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			}
		),
		Value = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v3.Color.Extended.Black.Black_100.Color3,
				ZIndex = 3,
				BorderSizePixel = 0
			},
			{
				Gradient = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			}
		),
		Knob = 0
	}
	local knob

	if v2.showSelectionKnob then
		knob = React.createElement(Knob, {
			size = InputSize.Medium,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = React.joinBindings({ saturation, value }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return UDim2.fromScale(item, 1 - item2)
			end),
			style = React.joinBindings({ hue, saturation, value }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				local item3 = list[3]
				return {
					Color3 = Color3.fromHSV(item, item2, item3),
					Transparency = 0
				}
			end),
			stroke = {
				Color = v3.Color.System.Contrast.Color3,
				Thickness = v3.Stroke.Thicker,
				Transparency = v3.Color.System.Contrast.Transparency
			},
			hasShadow = true,
			ZIndex = 4
		})
	end

	children.Knob = knob
	return createElement(View, v7, children)
end

return SVPicker
