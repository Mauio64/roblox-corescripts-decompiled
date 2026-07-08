local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)
local Image = require(Foundation.Components.Image)
local Knob = require(Foundation.Components.Knob)
local Slider = require(Foundation.Components.Slider)
local View = require(Foundation.Components.View)
local ColorSliderType = require(Foundation.Enums.ColorSliderType)
local InputSize = require(Foundation.Enums.InputSize)
local SliderVariant = require(Foundation.Enums.SliderVariant)
local Visibility = require(Foundation.Enums.Visibility)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local colorSequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
	ColorSequenceKeypoint.new(0.16666666666666666, Color3.new(1, 1, 0)),
	ColorSequenceKeypoint.new(0.3333333333333333, Color3.new(0, 1, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 1)),
	ColorSequenceKeypoint.new(0.6666666666666666, Color3.new(0, 0, 1)),
	ColorSequenceKeypoint.new(0.8333333333333334, Color3.new(1, 0, 1)),
	ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
})

local function createAlphaGradient(p1) -- line: 44
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, p1),
		ColorSequenceKeypoint.new(1, p1)
	})
end

local t1 = {
	sliderType = ColorSliderType.Hue,
	baseColor = React.createBinding(Color3.new(1, 1, 1))
}

local function ColorSlider(p2) -- line: 56
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), ColorSliderType (copy), colorSequence (copy), createAlphaGradient (copy), React (copy), Slider (copy), InputSize (copy), SliderVariant (copy), Visibility (copy), Knob (copy), View (copy), withCommonProps (copy), Image (copy)
	local v21 = withDefaults(p2, t1)
	local v22 = useTokens()
	local sliderType = v21.sliderType
	local value = v21.value
	local onValueChanged = v21.onValueChanged
	local v26 = if sliderType ~= ColorSliderType.Hue then v21.baseColor:map(createAlphaGradient) else colorSequence
	local v27 = nil
	local numberSequence = nil

	if sliderType == ColorSliderType.Hue then
		v27 = value:map(function(p3) -- line: 71
			return {
				Transparency = 0,
				Color3 = Color3.fromHSV(p3, 1, 1)
			}
		end)
	elseif sliderType == ColorSliderType.Alpha then
		numberSequence = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0)
		})
		v27 = React.joinBindings({
			baseColor = v21.baseColor,
			value = value
		}):map(function(p4) -- line: 82
			return {
				Color3 = p4.baseColor,
				Transparency = 1 - p4.value
			}
		end)
	end

	local v29 = sliderType == ColorSliderType.Alpha
	local v30 = React.createElement(Slider, {
		isContained = true,
		value = value,
		onValueChanged = onValueChanged,
		onDragStarted = v21.onDragStarted,
		onDragEnded = v21.onDragEnded,
		size = InputSize.Medium,
		variant = SliderVariant.Utility,
		width = UDim.new(1, 0),
		knobVisibility = Visibility.Always,
		knob = React.createElement(Knob, {
			hasShadow = true,
			size = InputSize.Small,
			style = v27,
			stroke = {
				Color = v22.Color.System.Contrast.Color3,
				Thickness = v22.Stroke.Thicker,
				Transparency = v22.Color.System.Contrast.Transparency
			}
		})
	})

	if v29 then
		return React.createElement(View, withCommonProps(v21, {
			tag = "size-full-300"
		}), {
			Background = React.createElement(View, {
				tag = "size-full stroke-standard stroke-emphasis radius-circle",
				ClipsDescendants = true,
				ZIndex = 1
			}, {
				Checkerboard = React.createElement(Image, {
					Image = "component_assets/checkerboard_12",
					tag = "size-full",
					ZIndex = 1,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(v22.Size.Size_300, v22.Size.Size_300),
					cornerRadius = UDim.new(1, 0)
				}),
				GradientOverlay = React.createElement(View, {
					tag = "size-full",
					ZIndex = 2,
					backgroundStyle = {
						Transparency = 0,
						Color3 = Color3.new(1, 1, 1)
					},
					cornerRadius = UDim.new(1, 0)
				}, {
					Gradient = React.createElement("UIGradient", {
						Color = v26,
						Transparency = numberSequence
					})
				})
			}),
			SliderContainer = React.createElement(View, {
				tag = "row align-y-center size-full",
				ZIndex = 2
			}, {
				Slider = v30
			})
		})
	end

	return React.createElement(View, withCommonProps(v21, {
		tag = "row align-y-center size-full-300 stroke-standard stroke-emphasis radius-circle",
		backgroundStyle = v22.Color.Extended.White.White_100
	}), {
		Gradient = React.createElement("UIGradient", {
			Color = v26
		}),
		Slider = v30
	})
end

return ColorSlider
