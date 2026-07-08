local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
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

local t1 = {
	initialAlpha = 1,
	testId = "--foundation-color-picker",
	initialMode = ColorInputMode.RGB
}

local function resolveInitialHSV(p1) -- line: 40
	if type(p1) == "table" then
		return p1.H / 360, (p1.S or 100) / 100, (p1.V or 100) / 100
	end

	return p1:ToHSV()
end
local function ColorPicker(p2) -- line: 48
	-- upvalues: ColorInputMode (copy), withDefaults (copy), t1 (copy), useTokens (copy), React (copy), colorUtils (copy), View (copy), withCommonProps (copy), ColorInputs (copy), BrickColorPicker (copy), SVPicker (copy), ColorSlider (copy), ColorSliderType (copy)
	local v20 = p2.availableModes or {
		ColorInputMode.RGB,
		ColorInputMode.HSV,
		ColorInputMode.Hex,
		ColorInputMode.Brick
	}
	local v21 = withDefaults(p2, t1)
	local Magenta_700Color3 = useTokens().Color.Extended.Magenta.Magenta_700.Color3
	local v23 = v21.initialColor or Magenta_700Color3
	local v24, v25 = React.useBinding(v23)
	local v26, v27, v28

	if type(v23) == "table" then
		v26 = v23.H / 360
		v27 = (v23.S or 100) / 100
		v28 = (v23.V or 100) / 100
	else
		v26, v27, v28 = v23:ToHSV()
	end

	local v29, v30 = React.useBinding(v26)
	local v31, v32 = React.useBinding(v27)
	local v33, v34 = React.useBinding(v28)
	local v35, v36 = React.useBinding(v21.initialAlpha or 1)
	local v37, v38 = React.useState(v21.initialMode or ColorInputMode.RGB)
	local v39 = v24:map(colorUtils.toColor3)
	local v40 = v24:map(function(p3) -- line: 70
		-- upvalues: colorUtils (copy)
		return not colorUtils.isPartialHSV(p3)
	end)
	local v41 = React.useRef(false)

	React.useEffect(function() -- line: 76
		-- upvalues: v21 (copy), v20 (copy), v38 (copy)
		local initialMode = v21.initialMode

		if initialMode then
			local v51 = false

			for _, v53 in v20 do
				if v53 == initialMode then
					v51 = true

					break
				end
			end

			if not v51 then
				warn(`ColorPicker: initialMode { initialMode } is not in availableModes. Using first available mode.`)
				v38(v20[1])
			end
		end
	end, { v21.initialMode })

	local v42 = React.useCallback(function(color3: Color3, p4) -- line: 95
		-- upvalues: v25 (copy), v21 (copy)
		v25(color3)
		v21.onColorChanged(color3, p4)
	end, { v21.onColorChanged })
	local v43 = React.useCallback(function(p5) -- line: 100
		-- upvalues: v36 (copy), v21 (copy)
		v36(p5)

		if v21.onAlphaChanged then
			v21.onAlphaChanged(p5)
		end
	end, { v21.onAlphaChanged })
	local v44 = React.useCallback(function(p6) -- line: 107
		-- upvalues: v42 (copy)
		v42(p6.Color, p6)
	end, { v42 })
	local v45 = v21.onAlphaChanged ~= nil
	local v46 = React.useCallback(function(p7) -- line: 113
		-- upvalues: v42 (copy)
		v42(p7, nil)
	end, { v42 })
	local v47 = React.useCallback(colorUtils.createHSVUpdateHandler(v30, v32, v34, v46, v41), {
		v46,
		v30,
		v32,
		v34,
		v25
	})
	local v48 = React.useCallback(colorUtils.createColorInputChangeHandler(v46, v41, v30, v32, v34), {
		v46,
		v41,
		v30,
		v32,
		v34
	})

	React.useEffect(function() -- line: 139
		-- upvalues: v39 (copy), v30 (copy), v32 (copy), v34 (copy)
		local v59, v60, v61 = v39:getValue():ToHSV()

		v30(v59)
		v32(v60)
		v34(v61)
	end, {})

	return React.createElement(View, withCommonProps(v21, {
		tag = "col gap-small size-full-0 auto-y padding-small"
	}), {
		ColorInputs = React.createElement(ColorInputs, {
			LayoutOrder = 1,
			color = v24,
			alpha = v35,
			onColorChanged = v48,
			onAlphaChanged = if not v45 then nil else v43,
			mode = v37,
			onModeChanged = v38,
			availableModes = v20,
			testId = `{ v21.testId }--input`
		}),
		BrickPicker = if v37 ~= ColorInputMode.Brick then nil else React.createElement(BrickColorPicker, {
			LayoutOrder = 2,
			selectedColor = v39,
			onBrickColorChanged = v44,
			testId = `{ v21.testId }--brick-picker`
		}),
		SVPickerContainer = if v37 == ColorInputMode.Brick then nil else React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 156)
		}, {
			SVPicker = React.createElement(SVPicker, {
				hue = v29,
				saturation = v31,
				value = v33,
				onChanged = function(p8, p9) -- line: 182
					-- upvalues: v47 (copy), v29 (copy)
					v47(v29:getValue(), p8, p9)
				end,
				onDragStarted = v21.onDragStarted,
				onDragEnded = v21.onDragEnded,
				showSelectionKnob = v40:getValue(),
				testId = `{ v21.testId }--sv-picker`
			})
		}),
		HueSlider = if v37 == ColorInputMode.Brick then nil else React.createElement(ColorSlider, {
			LayoutOrder = 3,
			sliderType = ColorSliderType.Hue,
			value = v29,
			onValueChanged = function(p10) -- line: 197
				-- upvalues: v47 (copy), v31 (copy), v33 (copy)
				v47(p10, v31:getValue(), v33:getValue())
			end,
			onDragStarted = v21.onDragStarted,
			onDragEnded = v21.onDragEnded,
			testId = `{ v21.testId }--hue-slider`
		}),
		AlphaSlider = if not v45 then nil else React.createElement(ColorSlider, {
			LayoutOrder = 4,
			sliderType = ColorSliderType.Alpha,
			value = v35,
			baseColor = v39,
			onValueChanged = v43,
			onDragStarted = v21.onDragStarted,
			onDragEnded = v21.onDragEnded,
			testId = `{ v21.testId }--alpha-slider`
		})
	})
end

return ColorPicker
