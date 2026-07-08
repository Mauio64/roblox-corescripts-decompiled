local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local Dropdown = require(Foundation.Components.Dropdown)
local NumberInput = require(Foundation.Components.NumberInput)
local TextInput = require(Foundation.Components.TextInput)
local View = require(Foundation.Components.View)
local ColorInputMode = require(Foundation.Enums.ColorInputMode)
local InputSize = require(Foundation.Enums.InputSize)
local NumberInputControlsVariant = require(Foundation.Enums.NumberInputControlsVariant)
local colorInputUtils = require(Foundation.Components.ColorPicker.colorInputUtils)
local colorUtils = require(Foundation.Components.ColorPicker.colorUtils)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Providers.Style.Tokens)

local useTokens = require(Foundation.Providers.Style.useTokens)

local function createNumberInputElement(p1, p2, p3) -- line: 38
	-- upvalues: React (copy), NumberInput (copy), Dash (copy)
	local v24 = p1.value:getValue()

	if v24 == nil then
		return React.createElement(NumberInput, Dash.join({
			value = -1,
			onChanged = function(n1: number) -- line: 51
				-- upvalues: p1 (copy)
				if n1 ~= -1 then
					p1.handler(n1, p1.component)
				end
			end,
			controlsVariant = p2,
			minimum = p1.minimum or 0,
			maximum = p1.maximum or 255,
			step = p1.step or 1,
			precision = p1.precision or 0,
			formatAsString = function(_: number) -- line: 61
				return ""
			end
		}, p3))
	end

	return React.createElement(NumberInput, Dash.join({
		value = v24,
		onChanged = function(n3: number) -- line: 72
			-- upvalues: p1 (copy)
			p1.handler(n3, p1.component)
		end,
		controlsVariant = p2,
		minimum = p1.minimum or 0,
		maximum = p1.maximum or 255,
		step = p1.step or 1,
		precision = p1.precision or 0
	}, p3))
end
local function renderInput(_, p5, n4: number, s1: string, s2: string?) -- line: 84
	-- upvalues: InputSize (copy), ColorInputMode (copy), React (copy), View (copy), TextInput (copy), createNumberInputElement (copy), NumberInputControlsVariant (copy)
	local v30 = if s1 ~= p5.key:lower() then `-{ p5.key:lower() }` else ""
	local t1 = {
		label = "",
		size = InputSize.XSmall,
		width = UDim.new(1, 0),
		LayoutOrder = n4,
		testId = `{ s2 }-{ s1 }{ v30 }`
	}

	if p5.key == ColorInputMode.Hex then
		return React.createElement(View, {
			tag = "grow-1 size-0-full",
			LayoutOrder = n4
		}, {
			Input = React.createElement(TextInput, {
				label = "",
				text = p5.value:getValue(),
				onChanged = function(s3: string) -- line: 109
					-- upvalues: p5 (copy)
					p5.handler(s3, p5.component)
				end,
				placeholder = p5.placeholder or "#000000",
				size = InputSize.XSmall,
				width = UDim.new(1, 0),
				testId = `{ s2 }-{ s1 }`
			})
		})
	end

	return React.createElement(View, {
		tag = "grow-1 size-0-full",
		LayoutOrder = n4
	}, {
		Input = createNumberInputElement(p5, NumberInputControlsVariant.None, t1)
	})
end

local t2 = {
	alpha = React.createBinding(1)
}

local function ColorInputs(p6) -- line: 143
	-- upvalues: ColorInputMode (copy), withDefaults (copy), t2 (copy), useTokens (copy), React (copy), colorUtils (copy), View (copy), TextInput (copy), InputSize (copy), colorInputUtils (copy), renderInput (copy), withCommonProps (copy), Dash (copy), Dropdown (copy)
	local v33 = p6.availableModes or {
		ColorInputMode.RGB,
		ColorInputMode.HSV,
		ColorInputMode.Hex,
		ColorInputMode.Brick
	}
	local v34 = withDefaults(p6, t2)
	local v35 = useTokens()
	local v36 = v34.mode or ColorInputMode.RGB
	local color = v34.color
	local alpha = v34.alpha
	local v39 = React.useCallback(function(p7) -- line: 153
		-- upvalues: v34 (copy)
		if v34.onColorChanged then
			v34.onColorChanged(p7)
		end
	end, { v34.onColorChanged })
	local onAlphaChanged = v34.onAlphaChanged
	local v41 = v34.onAlphaChanged ~= nil
	local v42 = color:map(function(p8) -- line: 163
		-- upvalues: colorUtils (copy)
		if colorUtils.isPartialHSV(p8) then
			return {
				r = nil,
				g = nil,
				b = nil
			}
		end

		local v56 = colorUtils.toColor3(p8)

		return {
			r = math.round(v56.R * 255),
			g = math.round(v56.G * 255),
			b = math.round(v56.B * 255)
		}
	end)
	local v43 = color:map(function(p9) -- line: 176
		if type(p9) == "table" then
			return {
				h = p9.H,
				s = p9.S,
				v = p9.V
			}
		end

		local v58, v59, v60 = p9:ToHSV()

		return {
			h = math.round(v58 * 360),
			s = math.round(v59 * 100),
			v = math.round(v60 * 100)
		}
	end)
	local v44 = v42:map(function(t3: {[any]: any}) -- line: 189
		if t3.r ~= nil and (t3.g ~= nil and t3.b ~= nil) then
			return string.format("#%02X%02X%02X", t3.r, t3.g, t3.b)
		end

		return ""
	end)
	local v45 = React.useCallback(function(n5: number, s4: string?) -- line: 197
		-- upvalues: v42 (copy), v39 (copy)
		local v64 = math.clamp(n5, 0, 255)
		local v65 = table.clone(v42:getValue())

		v65[s4] = v64

		if v65.r == nil or v65.g == nil or v65.b == nil then
			return
		end

		local color3 = Color3.fromRGB(v65.r, v65.g, v65.b)

		v39(color3)
	end, {
		v42,
		v39
	})
	local v46 = React.useCallback(function(n6: number) -- line: 213
		-- upvalues: onAlphaChanged (copy)
		if onAlphaChanged then
			onAlphaChanged(n6)
		end
	end, { onAlphaChanged })
	local v47 = React.useCallback(function(n7: number, s5: string?) -- line: 219
		-- upvalues: v43 (copy), v39 (copy)
		local v70 = table.clone(v43:getValue())

		if v70[s5] == nil and n7 == 0 then
			return
		end

		v70[s5] = math.clamp(n7, 0, s5 ~= "h" and 100 or 360)

		local color3 = Color3.fromHSV(v70.h / 360, (v70.s or 100) / 100, (v70.v or 100) / 100)

		v39(color3)
	end, {
		v43,
		v39
	})
	local v48 = React.useCallback(function(s6: string) -- line: 233
		-- upvalues: v39 (copy)
		local v73 = s6:gsub("#", ""):upper()

		if v73:match("^%x%x%x%x%x%x$") then
			local num = tonumber(v73:sub(1, 2), 16)
			local num2 = tonumber(v73:sub(3, 4), 16)
			local num3 = tonumber(v73:sub(5, 6), 16)

			if num and num2 and num3 then
				local color3 = Color3.fromRGB(num, num2, num3)

				v39(color3)
			end
		end
	end, { v39 })
	local v49 = React.useMemo(function() -- line: 249
		-- upvalues: ColorInputMode (copy), v41 (copy), v33 (copy)
		local t4 = {
			{
				id = ColorInputMode.RGB,
				text = ColorInputMode.RGB
			},
			{
				id = ColorInputMode.HSV,
				text = ColorInputMode.HSV
			},
			{
				id = ColorInputMode.Hex,
				text = ColorInputMode.Hex
			},
			{
				id = ColorInputMode.Brick,
				text = ColorInputMode.Brick
			}
		}

		if v41 then
			table.insert(t4, 2, {
				id = ColorInputMode.RGBA,
				text = ColorInputMode.RGBA
			})
		end

		local v79 = v33

		if not v79 then
			return t4
		end

		local t5 = {}

		for _, v82 in t4 do
			local id = v82.id

			for _, v85 in v79 do
				if id == v85 or id == ColorInputMode.RGBA and (v85 == ColorInputMode.RGB and v41) then
					table.insert(t5, v82)

					break
				end
			end
		end

		return t5
	end, { v41 })

	React.useEffect(function() -- line: 284
		-- upvalues: v36 (copy), ColorInputMode (copy), v41 (copy), v34 (copy)
		if v36 == ColorInputMode.RGBA and (not v41 and v34.onModeChanged) then
			v34.onModeChanged(ColorInputMode.RGB)
		end
	end, {
		v36,
		v41
	})

	return React.createElement(View, withCommonProps(v34, {
		tag = "row gap-xsmall size-full-600"
	}), Dash.join({
		ModeDropdown = if not (#v49 > 1) then nil else React.createElement(Dropdown.Root, {
			label = "",
			items = v49,
			value = v36,
			onItemChanged = function(p10) -- line: 344
				-- upvalues: v34 (copy)
				if v34.onModeChanged then
					v34.onModeChanged(p10)
				end
			end,
			size = InputSize.XSmall,
			width = UDim.new(0, v35.Size.Size_1600),
			testId = `{ v34.testId }--mode-dropdown`
		})
	}, ((function() -- line: 292
		-- upvalues: v36 (copy), ColorInputMode (copy), React (copy), View (copy), TextInput (copy), color (copy), InputSize (copy), v34 (copy), colorInputUtils (copy), v42 (copy), v43 (copy), v44 (copy), alpha (copy), v45 (copy), v47 (copy), v48 (copy), v46 (copy), v35 (copy), renderInput (copy)
		if v36 == ColorInputMode.Brick then
			return {
				BrickColorName = React.createElement(View, {
					tag = "grow-1 size-0-full",
					LayoutOrder = 1
				}, {
					Input = React.createElement(TextInput, {
						isDisabled = true,
						label = "",
						text = BrickColor.new(color:getValue()).Name,
						onChanged = function() -- line: 301
						end,
						size = InputSize.XSmall,
						width = UDim.new(1, 0),
						testId = `{ v34.testId }-brick-name`
					})
				})
			}
		end

		local v86 = colorInputUtils.createInputConfigs(v42, v43, v44, alpha, v45, v47, v48, v46, v35)[v36]

		if not v86 then
			return nil
		end

		local t6 = {}

		for i, v in ipairs(v86) do
			t6[v.key .. "Input"] = renderInput(v35, v, i, v36:lower(), v34.testId)
		end

		return t6
	end)())))
end

return ColorInputs
