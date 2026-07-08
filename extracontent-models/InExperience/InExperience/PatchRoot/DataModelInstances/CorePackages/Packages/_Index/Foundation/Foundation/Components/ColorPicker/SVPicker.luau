local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local InputSize = require(Foundation.Enums.InputSize)
local Knob = require(Foundation.Components.Knob)
local View = require(Foundation.Components.View)
local colorUtils = require(Foundation.Components.ColorPicker.colorUtils)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Components.Types)

local t1 = {
	showSelectionKnob = true
}

local function SVPicker(p1) -- line: 31
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), colorUtils (copy), View (copy), withCommonProps (copy), Knob (copy), InputSize (copy)
	local v14 = withDefaults(p1, t1)
	local hue = v14.hue
	local saturation = v14.saturation
	local value = v14.value
	local onChanged = v14.onChanged
	local onDragStarted = v14.onDragStarted
	local onDragEnded = v14.onDragEnded
	local v21 = useTokens()
	local v22 = hue:map(function(p2) -- line: 40
		return Color3.fromHSV(p2, 1, 1)
	end)
	local v23 = React.useRef(nil)
	local v24 = React.useCallback(function(vector2: Vector2) -- line: 45
		-- upvalues: v23 (copy), colorUtils (copy), onChanged (copy)
		local current = v23.current

		if not current then
			return
		end

		local v30, v31 = colorUtils.calculateSVFromPosition(vector2, current.AbsolutePosition, current.AbsoluteSize)

		onChanged(v30, v31)
	end, { onChanged })
	local v25 = React.useCallback(function(_, vector2: Vector2) -- line: 57
		-- upvalues: onDragStarted (copy), v24 (copy)
		if onDragStarted then
			onDragStarted()
		end

		v24(vector2)
	end, {
		v24,
		onDragStarted
	})
	local v26 = React.useCallback(function(_, vector2: Vector2) -- line: 64
		-- upvalues: v24 (copy)
		v24(vector2)
	end, { v24 })

	return React.createElement(View, withCommonProps(v14, {
		tag = "size-full radius-small",
		ClipsDescendants = true,
		ref = v23
	}), {
		DragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v25,
			[React.Event.DragContinue] = v26,
			[React.Event.DragEnd] = onDragEnded
		}),
		Base = React.createElement("Frame", {
			ZIndex = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v21.Color.Extended.White.White_100.Color3
		}),
		Saturation = React.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v22
		}, {
			Gradient = React.createElement("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			})
		}),
		Value = React.createElement("Frame", {
			ZIndex = 3,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v21.Color.Extended.Black.Black_100.Color3
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			})
		}),
		Knob = if not v14.showSelectionKnob then nil else React.createElement(Knob, {
			hasShadow = true,
			ZIndex = 4,
			size = InputSize.Medium,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = React.joinBindings({
				saturation,
				value
			}):map(function(p5) -- line: 119
				local v37 = p5[1]
				local v38 = p5[2]

				return UDim2.fromScale(v37, 1 - v38)
			end),
			style = React.joinBindings({
				hue,
				saturation,
				value
			}):map(function(p6) -- line: 124
				local v40 = p6[1]
				local v41 = p6[2]
				local v42 = p6[3]

				return {
					Transparency = 0,
					Color3 = Color3.fromHSV(v40, v41, v42)
				}
			end),
			stroke = {
				Color = v21.Color.System.Contrast.Color3,
				Thickness = v21.Stroke.Thicker,
				Transparency = v21.Color.System.Contrast.Transparency
			}
		})
	})
end

return SVPicker
