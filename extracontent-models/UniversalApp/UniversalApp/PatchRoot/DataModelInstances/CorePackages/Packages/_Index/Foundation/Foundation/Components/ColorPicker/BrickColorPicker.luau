local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

local Image = require(Foundation.Components.Image)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local BrickColorConstants = require(Foundation.Components.ColorPicker.BrickColorConstants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local Wrappers = require(Foundation.Utility.Wrappers)
local Connection = Wrappers.Connection
local Signal = Wrappers.Signal

local function calculateGridRadius(p: number)
	for i = 3, 20, 2 do
		if p < i * i - math.floor(i / 2) * (math.floor(i / 2) + 1) then
			return i - 2
		end
	end

	return 7
end

local function BottomRowSwatches(props)
	local state, setState = React.useState(0)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local current = ref.current

		if not current then
			return
		end

		local x = math.round(current.AbsoluteSize.X)

		if x ~= state then
			setState(x)
		end

		local v = Signal.Connect(current:GetPropertyChangedSignal("AbsoluteSize"), function()
			setState((math.round(current.AbsoluteSize.X)))
		end)
		return function()
			Connection.Disconnect(v)
		end
	end, { state })

	local children = {}

	if state > 0 then
		local count = #props.colors

		local v = state - props.paddingHorizontal * 2
		local v2 = math.floor(v / count)
		local v3 = v2 * (count - 1)
		local v4 = props.paddingHorizontal + math.floor((v - v3) / 2)

		for i, color in ipairs(props.colors) do
			local v5 = v4 + v2 * (i - 1)

			children[`Swatch_{i}`] = React.createElement(Image, {
				Size = UDim2.fromOffset(props.swatchWidth, props.swatchHeight),
				Position = UDim2.fromOffset(v5, props.swatchCenterY),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = "component_assets/hexagon_24",
				imageStyle = { Color3 = color.Color }
			})
		end
	end

	return React.createElement(View, { tag = "size-full", ref = ref }, children)
end

local function BrickColorPicker(props)
	local v = useTokens()

	local size_200 = v.Size.Size_200
	local size_350 = v.Size.Size_350
	local size_400 = v.Size.Size_400
	local size_100 = v.Size.Size_100
	local size_350_2 = v.Size.Size_350
	local size_400_2 = v.Size.Size_400
	local size_200_2 = v.Size.Size_200

	local v2 = React.useMemo(function()
		return BrickColorConstants.MAIN
	end, {})

	local colors = React.useMemo(function()
		return BrickColorConstants.BOTTOM
	end, {})

	local v3 = React.useMemo(function()
		local v3 = calculateGridRadius(#v2)

		if v3 < 3 then
			warn("BrickColorPicker: Calculated grid radius is too small, falling back to minimum")
			return 3
		end

		return v3
	end, {})

	local v4, v5 = React.useMemo(function()
		local v4 = v3
		local v5 = size_200 + 1

		local v6 = math.round(v5 * 1.5)
		local v7 = 1
		local result = {}

		for i = 0, v4 - 1 do
			for j = 0, 2 * v4 - 1 - 1 do
				if not (math.abs(math.floor(v4 / 2) - i) + math.abs(math.floor((2 * v4 - 1) / 2) - j) < v4) then
					continue
				end

				if not (i % 2 == j % 2 and v7 <= #v2) then
					continue
				end

				local v8 = size_200 * j
				local v9

				if v6 then
					v9 = v6 * i
				else
					v9 = math.round(v5 * 1.5 * i)
				end

				table.insert(result, { brickColor = v2[v7], x = v8, y = v9 })

				v7 += 1
			end
		end

		local minValue = 1e999
		local maxValue = -1e999
		local minValue2 = 1e999
		local maxValue2 = -1e999

		for _, v8 in result do
			minValue = math.min(minValue, v8.x - size_350 / 2)
			maxValue = math.max(maxValue, v8.x + size_350 / 2)
			minValue2 = math.min(minValue2, v8.y - size_400 / 2)
			maxValue2 = math.max(maxValue2, v8.y + size_400 / 2)
		end

		return result, {
			width = maxValue - minValue,
			height = maxValue2 - minValue2,
			offset = Vector2.new(minValue, minValue2)
		}
	end, { v3, size_200, v2, colors, v.Size.Size_100, v.Size.Size_50 })

	local onActivated = React.useCallback(function(p, p2)
		if p2.UserInputType == Enum.UserInputType.MouseButton1 then
			local v6 = p2.Position.X - p.AbsolutePosition.X
			local v7 = p2.Position.Y - p.AbsolutePosition.Y
			local v8 = v6 + v5.offset.X
			local v9 = v7 + v5.offset.Y
			local v10 = 1e999
			local v11 = nil

			for _, v12 in v4 do
				local v13 = (v8 - v12.x) ^ 2 + (v9 - v12.y) ^ 2

				if not (v13 < v10) then
					continue
				end

				v11 = v12
				v10 = v13
			end

			if v11 and v10 < size_200 * size_200 then
				props.onBrickColorChanged(v11.brickColor)

				if props.onColorChanged then
					props.onColorChanged(v11.brickColor.Color)
				end
			end
		end
	end, { v4, v5, size_200, props.onBrickColorChanged, props.onColorChanged })

	local onActivated2 = React.useCallback(function(p, p2)
		if p2.UserInputType == Enum.UserInputType.MouseButton1 then
			local v6 = p2.Position.X - p.AbsolutePosition.X
			local v7 = p.AbsoluteSize.X - 2 * size_100
			local v8 = v6 - size_100

			if v8 >= 0 and v8 <= v7 then
				local v9 = colors[math.clamp(math.floor(v8 / v7 * #colors) + 1, 1, #colors)]
				props.onBrickColorChanged(v9)

				if props.onColorChanged then
					props.onColorChanged(v9.Color)
				end
			end
		end
	end, { colors, props.onBrickColorChanged, props.onColorChanged })

	local v6 = React.useCallback(function(props2, flag: boolean)
		local udim = UDim2.fromOffset(props2.x - v5.offset.X, props2.y - v5.offset.Y)

		local children = {}

		if flag then
			children.outline = React.createElement(Image, {
				Size = UDim2.fromOffset(size_350 + size_200_2, size_400 + size_200_2),
				Position = udim,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = "component_assets/hexagon_24",
				imageStyle = v.Color.System.Emphasis,
				ZIndex = 1
			})
		end

		children.hexagon = React.createElement(Image, {
			Size = UDim2.fromOffset(size_350, size_400),
			Position = udim,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = "component_assets/hexagon_24",
			imageStyle = { Color3 = props2.brickColor.Color },
			ZIndex = 2
		})

		return children
	end, { v5.offset.X, v5.offset.Y, size_350, size_400, v })

	local v7 = React.useCallback(function()
		local v7 = props.selectedColor and props.selectedColor:getValue() or nil
		local result = {}

		for k, v8 in v4 do
			local v9

			if v7 == nil then
				v9 = false
			else
				v9 = v7 == v8.brickColor.Color
			end

			local v10 = v6(v8, v9)

			for k2, v11 in v10 do
				result[`{k2}_{k}`] = v11
			end
		end

		return result
	end, { props.selectedColor })

	return React.createElement(
		View,
		withCommonProps(props, { tag = "col align-x-center gap-small size-full-0 auto-y" }),
		{
			ColorGrid = React.createElement(View, {
				Size = UDim2.fromOffset(v5.width, v5.height),
				LayoutOrder = 1,
				onActivated = onActivated,
				stateLayer = { affordance = StateLayerAffordance.None }
			}, (v7())),
			BottomRow = React.createElement(View, {
				Size = UDim2.new(1, -v.Size.Size_400, 0, v.Size.Size_500),
				tag = "stroke-standard stroke-muted radius-circle bg-surface-100",
				LayoutOrder = 2,
				onActivated = onActivated2,
				stateLayer = { affordance = StateLayerAffordance.None }
			}, {
				Swatches = React.createElement(BottomRowSwatches, {
					colors = colors,
					paddingHorizontal = size_100,
					swatchWidth = size_350_2,
					swatchHeight = size_400_2,
					swatchCenterY = v.Size.Size_250
				})
			})
		}
	)
end

return BrickColorPicker
