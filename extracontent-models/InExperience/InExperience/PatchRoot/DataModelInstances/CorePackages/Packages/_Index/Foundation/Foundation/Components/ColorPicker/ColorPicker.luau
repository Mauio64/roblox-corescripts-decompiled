local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

local BrickColorPicker = require(Foundation.Components.ColorPicker.BrickColorPicker)
local ColorInputMode = require(Foundation.Enums.ColorInputMode)
local ColorInputs = require(Foundation.Components.ColorPicker.ColorInputs)
local ColorSlider = require(Foundation.Components.ColorPicker.ColorSlider)
local ColorSliderType = require(Foundation.Enums.ColorSliderType)
local SVPicker = require(Foundation.Components.ColorPicker.SVPicker)
local View = require(Foundation.Components.View)

local colorUtils = require(Foundation.Components.ColorPicker.colorUtils)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Components.Types)

local v = {
	initialAlpha = 1,
	initialMode = ColorInputMode.RGB,
	testId = "--foundation-color-picker"
}

local function resolveInitialHSV(data)
	if type(data) == "table" then
		return data.H / 360, (data.S or 100) / 100, (data.V or 100) / 100
	end

	return data:ToHSV()
end

local function ColorPicker(p)
	local availableModes = p.availableModes
		or { ColorInputMode.RGB, ColorInputMode.HSV, ColorInputMode.Hex, ColorInputMode.Brick }

	local v2 = withDefaults(p, v)
	local color3 = useTokens().Color.Extended.Magenta.Magenta_700.Color3

	local initialColor = v2.initialColor or color3

	local color2, v3 = React.useBinding(initialColor)
	local v4, v5, v6

	if type(initialColor) == "table" then
		v4 = initialColor.H / 360
		v5 = (initialColor.S or 100) / 100
		v6 = (initialColor.V or 100) / 100
	else
		v4, v5, v6 = initialColor:ToHSV()
	end

	local hue, v7 = React.useBinding(v4)
	local saturation, v8 = React.useBinding(v5)
	local v9, v10 = React.useBinding(v6)
	local alpha, v11 = React.useBinding(v2.initialAlpha or 1)
	local state, setState = React.useState(v2.initialMode or ColorInputMode.RGB)

	local mapped = color2:map(colorUtils.toColor3)

	local mapped2 = color2:map(function(p2): boolean
		return not colorUtils.isPartialHSV(p2)
	end)

	local ref = React.useRef(false)

	React.useEffect(function()
		local initialMode = v2.initialMode

		if initialMode then
			local v12 = false

			for _, availableMode in availableModes do
				if availableMode == initialMode then
					v12 = true
					break
				end
			end

			if not v12 then
				warn(`ColorPicker: initialMode {initialMode} is not in availableModes. Using first available mode.`)
				setState(availableModes[1])
			end
		end
	end, { v2.initialMode })

	local v12 = React.useCallback(function(color: Color3, p2)
		v3(color)
		v2.onColorChanged(color, p2)
	end, { v2.onColorChanged })

	local onValueChanged = React.useCallback(function(p2)
		v11(p2)

		if v2.onAlphaChanged then
			v2.onAlphaChanged(p2)
		end
	end, { v2.onAlphaChanged })

	local onBrickColorChanged = React.useCallback(function(p2)
		v12(p2.Color, p2)
	end, { v12 })

	local v13 = v2.onAlphaChanged ~= nil

	local v14 = React.useCallback(function(p2)
		v12(p2, nil)
	end, { v12 })

	local v15 = React.useCallback(colorUtils.createHSVUpdateHandler(v7, v8, v10, v14, ref), {
		v14,
		v7,
		v8,
		v10,
		v3
	})

	local onColorChanged = React.useCallback(colorUtils.createColorInputChangeHandler(v14, ref, v7, v8, v10), {
		v14,
		ref,
		v7,
		v8,
		v10
	})

	React.useEffect(function()
		local hsv, v16, v17 = mapped:getValue():ToHSV()
		v7(hsv)
		v8(v16)
		v10(v17)
	end, {})

	local createElement = React.createElement

	local v16 = withCommonProps(v2, { tag = "col gap-small size-full-0 auto-y padding-small" })

	local createElement2 = React.createElement
	local onAlphaChanged

	if v13 then
		onAlphaChanged = onValueChanged
	end

	local v17 = {
		ColorInputs = createElement2(ColorInputs, {
			color = color2,
			alpha = alpha,
			onColorChanged = onColorChanged,
			onAlphaChanged = onAlphaChanged,
			mode = state,
			onModeChanged = setState,
			availableModes = availableModes,
			LayoutOrder = 1,
			testId = `{v2.testId}--input`
		}),
		BrickPicker = 0,
		SVPickerContainer = 0,
		HueSlider = 0,
		AlphaSlider = 0
	}
	local brickPicker

	if state == ColorInputMode.Brick then
		brickPicker = React.createElement(BrickColorPicker, {
			selectedColor = mapped,
			onBrickColorChanged = onBrickColorChanged,
			LayoutOrder = 2,
			testId = `{v2.testId}--brick-picker`
		})
	end

	v17.BrickPicker = brickPicker
	local svPickerContainer

	if state ~= ColorInputMode.Brick then
		svPickerContainer = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 156),
			LayoutOrder = 2
		}, {
			SVPicker = React.createElement(SVPicker, {
				hue = hue,
				saturation = saturation,
				value = v9,
				onChanged = function(p2, p3)
					v15(hue:getValue(), p2, p3)
				end,
				onDragStarted = v2.onDragStarted,
				onDragEnded = v2.onDragEnded,
				showSelectionKnob = mapped2:getValue(),
				testId = `{v2.testId}--sv-picker`
			})
		})
	end

	v17.SVPickerContainer = svPickerContainer
	local hueSlider

	if state ~= ColorInputMode.Brick then
		hueSlider = React.createElement(ColorSlider, {
			sliderType = ColorSliderType.Hue,
			value = hue,
			onValueChanged = function(p2)
				v15(p2, saturation:getValue(), v9:getValue())
			end,
			onDragStarted = v2.onDragStarted,
			onDragEnded = v2.onDragEnded,
			LayoutOrder = 3,
			testId = `{v2.testId}--hue-slider`
		})
	end

	v17.HueSlider = hueSlider
	local alphaSlider

	if v13 then
		alphaSlider = React.createElement(ColorSlider, {
			sliderType = ColorSliderType.Alpha,
			value = alpha,
			baseColor = mapped,
			onValueChanged = onValueChanged,
			onDragStarted = v2.onDragStarted,
			onDragEnded = v2.onDragEnded,
			LayoutOrder = 4,
			testId = `{v2.testId}--alpha-slider`
		})
	end

	v17.AlphaSlider = alphaSlider
	return createElement(View, v16, v17)
end

return ColorPicker
