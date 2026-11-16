local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

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
	ColorSequenceKeypoint.new(1 / 6, Color3.new(1, 1, 0)),
	ColorSequenceKeypoint.new(1 / 3, Color3.new(0, 1, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 1)),
	ColorSequenceKeypoint.new(2 / 3, Color3.new(0, 0, 1)),
	ColorSequenceKeypoint.new(5 / 6, Color3.new(1, 0, 1)),
	ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
})

local function createAlphaGradient(p)
	return ColorSequence.new({ ColorSequenceKeypoint.new(0, p), ColorSequenceKeypoint.new(1, p) })
end

local v = {
	sliderType = ColorSliderType.Hue,
	baseColor = React.createBinding(Color3.new(1, 1, 1))
}

local function ColorSlider(p)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()

	local sliderType = v2.sliderType
	local value = v2.value
	local onValueChanged = v2.onValueChanged
	local color

	if sliderType == ColorSliderType.Hue then
		color = colorSequence
	else
		color = v2.baseColor:map(createAlphaGradient)
	end

	local style = nil
	local numberSequence = nil

	if sliderType == ColorSliderType.Hue then
		style = value:map(function(p2)
			return { Color3 = Color3.fromHSV(p2, 1, 1), Transparency = 0 }
		end)
	elseif sliderType == ColorSliderType.Alpha then
		numberSequence = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })

		style = React.joinBindings({ baseColor = v2.baseColor, value = value }):map(function(p2)
			return {
				Color3 = p2.baseColor,
				Transparency = 1 - p2.value
			}
		end)
	end

	local v4 = sliderType == ColorSliderType.Alpha

	local element = React.createElement(Slider, {
		value = value,
		onValueChanged = onValueChanged,
		onDragStarted = v2.onDragStarted,
		onDragEnded = v2.onDragEnded,
		size = InputSize.Medium,
		variant = SliderVariant.Utility,
		isContained = true,
		width = UDim.new(1, 0),
		knobVisibility = Visibility.Always,
		knob = React.createElement(Knob, {
			size = InputSize.Small,
			style = style,
			stroke = {
				Color = v3.Color.System.Contrast.Color3,
				Thickness = v3.Stroke.Thicker,
				Transparency = v3.Color.System.Contrast.Transparency
			},
			hasShadow = true
		})
	})

	if v4 then
		return React.createElement(View, withCommonProps(v2, { tag = "size-full-300" }), {
			Background = React.createElement(
				View,
				{
					tag = "size-full stroke-standard stroke-emphasis radius-circle",
					ClipsDescendants = true,
					ZIndex = 1
				},
				{
					Checkerboard = React.createElement(Image, {
						Image = "component_assets/checkerboard_12",
						ScaleType = Enum.ScaleType.Tile,
						TileSize = UDim2.fromOffset(v3.Size.Size_300, v3.Size.Size_300),
						cornerRadius = UDim.new(1, 0),
						tag = "size-full",
						ZIndex = 1
					}),
					GradientOverlay = React.createElement(View, {
						tag = "size-full",
						backgroundStyle = { Color3 = Color3.new(1, 1, 1), Transparency = 0 },
						cornerRadius = UDim.new(1, 0),
						ZIndex = 2
					}, {
						Gradient = React.createElement("UIGradient", {
							Color = color,
							Transparency = numberSequence
						})
					})
				}
			),
			SliderContainer = React.createElement(View, {
				tag = "row align-y-center size-full",
				ZIndex = 2
			}, {
				Slider = element
			})
		})
	end

	return React.createElement(
		View,
		withCommonProps(v2, {
			tag = "row align-y-center size-full-300 stroke-standard stroke-emphasis radius-circle",
			backgroundStyle = v3.Color.Extended.White.White_100
		}),
		{
			Gradient = React.createElement("UIGradient", { Color = color }),
			Slider = element
		}
	)
end

return ColorSlider
