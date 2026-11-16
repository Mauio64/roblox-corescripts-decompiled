local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

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

local function createNumberInputElement(props, none, p)
	local value = props.value:getValue()

	if value == nil then
		return React.createElement(NumberInput, Dash.join({
			value = -1,
			onChanged = function(p2: number)
				if p2 ~= -1 then
					props.handler(p2, props.component)
				end
			end,
			controlsVariant = none,
			minimum = props.minimum or 0,
			maximum = props.maximum or 255,
			step = props.step or 1,
			precision = props.precision or 0,
			formatAsString = function(_: number): string
				return ""
			end
		}, p))
	end

	return React.createElement(NumberInput, Dash.join({
		value = value,
		onChanged = function(p2: number)
			props.handler(p2, props.component)
		end,
		controlsVariant = none,
		minimum = props.minimum or 0,
		maximum = props.maximum or 255,
		step = props.step or 1,
		precision = props.precision or 0
	}, p))
end

local function renderInput(_, props, i: number, p: string, testId: string?)
	local v = p == props.key:lower() and "" or `-{props.key:lower()}`
	local v2 = {
		size = InputSize.XSmall,
		label = "",
		width = UDim.new(1, 0),
		LayoutOrder = i,
		testId = `{testId}-{p}{v}`
	}

	if props.key == ColorInputMode.Hex then
		return React.createElement(View, { tag = "grow-1 size-0-full", LayoutOrder = i }, {
			Input = React.createElement(TextInput, {
				text = props.value:getValue(),
				onChanged = function(p2: string)
					props.handler(p2, props.component)
				end,
				placeholder = props.placeholder or "#000000",
				size = InputSize.XSmall,
				label = "",
				width = UDim.new(1, 0),
				testId = `{testId}-{p}`
			})
		})
	end

	return React.createElement(View, { tag = "grow-1 size-0-full", LayoutOrder = i }, {
		Input = createNumberInputElement(props, NumberInputControlsVariant.None, v2)
	})
end

local v = { alpha = React.createBinding(1) }

local function ColorInputs(p)
	local availableModes = p.availableModes
		or { ColorInputMode.RGB, ColorInputMode.HSV, ColorInputMode.Hex, ColorInputMode.Brick }

	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local mode = v2.mode or ColorInputMode.RGB
	local color = v2.color
	local alpha = v2.alpha

	local v4 = React.useCallback(function(p2)
		if v2.onColorChanged then
			v2.onColorChanged(p2)
		end
	end, { v2.onColorChanged })

	local onAlphaChanged = v2.onAlphaChanged
	local v5 = v2.onAlphaChanged ~= nil

	local mapped = color:map(function(p2)
		if colorUtils.isPartialHSV(p2) then
			return { r = nil, g = nil, b = nil }
		end

		local color3 = colorUtils.toColor3(p2)
		return {
			r = math.round(color3.R * 255),
			g = math.round(color3.G * 255),
			b = math.round(color3.B * 255)
		}
	end)

	local mapped2 = color:map(function(data)
		if type(data) == "table" then
			return { h = data.H, s = data.S, v = data.V }
		end

		local hsv, v6, v7 = data:ToHSV()
		return {
			h = math.round(hsv * 360),
			s = math.round(v6 * 100),
			v = math.round(v7 * 100)
		}
	end)

	local mapped3 = mapped:map(function(data)
		if data.r == nil or data.g == nil or data.b == nil then
			return ""
		end

		return string.format("#%02X%02X%02X", data.r, data.g, data.b)
	end)

	local v6 = React.useCallback(function(value: number, p2: string?)
		local v6 = math.clamp(value, 0, 255)

		local clone = table.clone(mapped:getValue())
		clone[p2] = v6

		if clone.r == nil or clone.g == nil or clone.b == nil then
			return
		end

		v4((Color3.fromRGB(clone.r, clone.g, clone.b)))
	end, { mapped, v4 })

	local v7 = React.useCallback(function(p2: number)
		if onAlphaChanged then
			onAlphaChanged(p2)
		end
	end, { onAlphaChanged })

	local v8 = React.useCallback(function(value: number, p2: string?)
		local clone = table.clone(mapped2:getValue())

		if clone[p2] == nil and value == 0 then
			return
		end

		clone[p2] = math.clamp(value, 0, p2 == "h" and 360 or 100)

		v4((Color3.fromHSV(clone.h / 360, (clone.s or 100) / 100, (clone.v or 100) / 100)))
	end, { mapped2, v4 })

	local v9 = React.useCallback(function(value: string)
		local upper = value:gsub("#", ""):upper()

		if upper:match("^%x%x%x%x%x%x$") then
			local v9 = tonumber(upper:sub(1, 2), 16)
			local v10 = tonumber(upper:sub(3, 4), 16)
			local v11 = tonumber(upper:sub(5, 6), 16)

			if v9 and v10 and v11 then
				v4((Color3.fromRGB(v9, v10, v11)))
			end
		end
	end, { v4 })

	local items = React.useMemo(function()
		local v10 = {
			{ id = ColorInputMode.RGB, text = ColorInputMode.RGB },
			{ id = ColorInputMode.HSV, text = ColorInputMode.HSV },
			{ id = ColorInputMode.Hex, text = ColorInputMode.Hex },
			{ id = ColorInputMode.Brick, text = ColorInputMode.Brick }
		}

		if v5 then
			table.insert(v10, 2, { id = ColorInputMode.RGBA, text = ColorInputMode.RGBA })
		end

		local v11 = availableModes

		if not v11 then
			return v10
		end

		local result = {}

		for _, v12 in v10 do
			local id = v12.id

			for _, v13 in v11 do
				local v14

				if id == v13 then
					v14 = true
				elseif id == ColorInputMode.RGBA and v13 == ColorInputMode.RGB then
					v14 = v5
				else
					v14 = false
				end

				if v14 then
					table.insert(result, v12)
					break
				end
			end
		end

		return result
	end, { v5 })

	React.useEffect(function()
		if mode == ColorInputMode.RGBA and not v5 and v2.onModeChanged then
			v2.onModeChanged(ColorInputMode.RGB)
		end
	end, { mode, v5 })

	local function fn()
		if mode == ColorInputMode.Brick then
			return {
				BrickColorName = React.createElement(View, {
					tag = "grow-1 size-0-full",
					LayoutOrder = 1
				}, {
					Input = React.createElement(TextInput, {
						text = BrickColor.new(color:getValue()).Name,
						onChanged = function() end,
						isDisabled = true,
						size = InputSize.XSmall,
						label = "",
						width = UDim.new(1, 0),
						testId = `{v2.testId}-brick-name`
					})
				})
			}
		end

		local v10 = colorInputUtils.createInputConfigs(mapped, mapped2, mapped3, alpha, v6, v8, v9, v7, v3)[mode]

		if not v10 then
			return nil
		end

		local result = {}

		for i, v11 in ipairs(v10) do
			result[v11.key .. "Input"] = renderInput(v3, v11, i, mode:lower(), v2.testId)
		end

		return result
	end

	local createElement = React.createElement

	local v10 = withCommonProps(v2, { tag = "row gap-xsmall size-full-600" })

	local join = Dash.join
	local modeDropdown

	if #items > 1 then
		modeDropdown = React.createElement(Dropdown.Root, {
			items = items,
			value = mode,
			onItemChanged = function(p2)
				if v2.onModeChanged then
					v2.onModeChanged(p2)
				end
			end,
			size = InputSize.XSmall,
			label = "",
			width = UDim.new(0, v3.Size.Size_1600),
			testId = `{v2.testId}--mode-dropdown`
		})
	end

	return createElement(View, v10, join({ ModeDropdown = modeDropdown }, fn()))
end

return ColorInputs
