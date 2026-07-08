local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
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

local function calculateGridRadius(n1: number) -- line: 49
	for i = 3, 20, 2 do
		if n1 < i * i - math.floor(i / 2) * (math.floor(i / 2) + 1) then
			return i - 2
		end
	end

	return 7
end
local function BottomRowSwatches(t1: {[any]: any}) -- line: 71
	-- upvalues: React (copy), Signal (copy), Connection (copy), Image (copy), View (copy)
	local v19, v20 = React.useState(0)
	local v21 = React.useRef(nil)

	React.useEffect(function() -- line: 75
		-- upvalues: v21 (copy), v19 (copy), v20 (copy), Signal (copy), Connection (copy)
		local current = v21.current

		if not current then
			return
		end

		local v50 = math.round(current.AbsoluteSize.X)

		if v50 ~= v19 then
			v20(v50)
		end

		local v51 = Signal.Connect(current:GetPropertyChangedSignal("AbsoluteSize"), function() -- line: 84
			-- upvalues: v20 (copy), current (copy)
			v20((math.round(current.AbsoluteSize.X)))
		end)

		return function() -- line: 87
			-- upvalues: Connection (copy), v51 (copy)
			Connection.Disconnect(v51)
		end
	end, { v19 })

	local t2 = {}

	if v19 > 0 then
		local v23 = #t1.colors
		local v24 = v19 - t1.paddingHorizontal * 2
		local v25 = math.floor(v24 / v23)
		local v26 = v25 * (v23 - 1)
		local v27 = t1.paddingHorizontal + math.floor((v24 - v26) / 2)

		for i, v in ipairs(t1.colors) do
			local v30 = v27 + v25 * (i - 1)

			t2[`Swatch_{ i }`] = React.createElement(Image, {
				Image = "component_assets/hexagon_24",
				Size = UDim2.fromOffset(t1.swatchWidth, t1.swatchHeight),
				Position = UDim2.fromOffset(v30, t1.swatchCenterY),
				AnchorPoint = Vector2.new(0.5, 0.5),
				imageStyle = {
					Color3 = v.Color
				}
			})
		end
	end

	return React.createElement(View, {
		tag = "size-full",
		ref = v21
	}, t2)
end
local function BrickColorPicker(p1) -- line: 122
	-- upvalues: useTokens (copy), React (copy), BrickColorConstants (copy), calculateGridRadius (copy), Image (copy), View (copy), withCommonProps (copy), StateLayerAffordance (copy), BottomRowSwatches (copy)
	local v32 = useTokens()
	local Size_200 = v32.Size.Size_200
	local Size_350 = v32.Size.Size_350
	local Size_400 = v32.Size.Size_400
	local Size_100 = v32.Size.Size_100
	local Size_350_2 = v32.Size.Size_350
	local Size_400_2 = v32.Size.Size_400
	local Size_200_2 = v32.Size.Size_200
	local v40 = React.useMemo(function() -- line: 134
		-- upvalues: BrickColorConstants (copy)
		return BrickColorConstants.MAIN
	end, {})
	local v41 = React.useMemo(function() -- line: 138
		-- upvalues: BrickColorConstants (copy)
		return BrickColorConstants.BOTTOM
	end, {})
	local v42 = React.useMemo(function() -- line: 142
		-- upvalues: calculateGridRadius (copy), v40 (copy)
		local v52 = calculateGridRadius(#v40)

		if v52 < 3 then
			warn("BrickColorPicker: Calculated grid radius is too small, falling back to minimum")

			return 3
		end

		return v52
	end, {})
	local v43, v44 = React.useMemo(function() -- line: 153
		-- upvalues: v42 (copy), Size_200 (copy), v40 (copy), Size_350 (copy), Size_400 (copy)
		local t3 = {}
		local n2 = 1
		local v55 = v42
		local v56 = Size_200 + 1
		local v57 = Size_200
		local v58 = math.round(v56 * 1.5)

		for i = 0, v55 - 1 do
			for j = 0, 2 * v55 - 1 - 1 do
				if v55 > math.abs(math.floor(v55 / 2) - i) + math.abs(math.floor((2 * v55 - 1) / 2) - j) and i % 2 == j % 2 and n2 <= #v40 then
					local v61 = v57 * j
					local v62 = if not v58 then math.round(v56 * 1.5 * i) else v58 * i

					table.insert(t3, {
						brickColor = v40[n2],
						x = v61,
						y = v62
					})
					n2 += 1
				end
			end
		end

		local n3 = 1e999
		local n4 = -1e999
		local n5 = 1e999
		local n6 = -1e999

		for _, v68 in t3 do
			n3 = math.min(n3, v68.x - Size_350 / 2)
			n4 = math.max(n4, v68.x + Size_350 / 2)
			n5 = math.min(n5, v68.y - Size_400 / 2)
			n6 = math.max(n6, v68.y + Size_400 / 2)
		end

		return t3, {
			width = n4 - n3,
			height = n6 - n5,
			offset = Vector2.new(n3, n5)
		}
	end, {
		v42,
		Size_200,
		v40,
		v41,
		v32.Size.Size_100,
		v32.Size.Size_50
	})
	local v45 = React.useCallback(function(p2, p3) -- line: 207
		-- upvalues: v44 (copy), v43 (copy), Size_200 (copy), p1 (copy)
		if p3.UserInputType == Enum.UserInputType.MouseButton1 then
			local v71 = nil
			local n7 = 1e999
			local v73 = p3.Position.X - p2.AbsolutePosition.X
			local v74 = p3.Position.Y - p2.AbsolutePosition.Y
			local v75 = v73 + v44.offset.X
			local v76 = v74 + v44.offset.Y

			for _, v78 in v43 do
				local v79 = (v75 - v78.x) ^ 2 + (v76 - v78.y) ^ 2

				if v79 < n7 then
					n7 = v79
					v71 = v78
				end
			end

			if v71 and n7 < Size_200 * Size_200 then
				p1.onBrickColorChanged(v71.brickColor)

				if p1.onColorChanged then
					p1.onColorChanged(v71.brickColor.Color)
				end
			end
		end
	end, {
		v43,
		v44,
		Size_200,
		p1.onBrickColorChanged,
		p1.onColorChanged
	})
	local v46 = React.useCallback(function(p4, p5) -- line: 233
		-- upvalues: Size_100 (copy), v41 (copy), p1 (copy)
		if p5.UserInputType == Enum.UserInputType.MouseButton1 then
			local v82 = p5.Position.X - p4.AbsolutePosition.X
			local v83 = p4.AbsoluteSize.X - 2 * Size_100
			local v84 = v82 - Size_100

			if v84 >= 0 and v84 <= v83 then
				local v85 = v41[math.clamp(math.floor(v84 / v83 * #v41) + 1, 1, #v41)]

				p1.onBrickColorChanged(v85)

				if p1.onColorChanged then
					p1.onColorChanged(v85.Color)
				end
			end
		end
	end, {
		v41,
		p1.onBrickColorChanged,
		p1.onColorChanged
	})
	local v47 = React.useCallback(function(t4: {[any]: any}, b1: boolean) -- line: 252
		-- upvalues: v44 (copy), React (copy), Image (copy), Size_350 (copy), Size_200_2 (copy), Size_400 (copy), v32 (copy)
		local uDim2 = UDim2.fromOffset(t4.x - v44.offset.X, t4.y - v44.offset.Y)
		local t5 = {}

		if b1 then
			t5.outline = React.createElement(Image, {
				Image = "component_assets/hexagon_24",
				ZIndex = 1,
				Size = UDim2.fromOffset(Size_350 + Size_200_2, Size_400 + Size_200_2),
				Position = uDim2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				imageStyle = v32.Color.ActionEmphasis.Background
			})
		end

		t5.hexagon = React.createElement(Image, {
			Image = "component_assets/hexagon_24",
			ZIndex = 2,
			Size = UDim2.fromOffset(Size_350, Size_400),
			Position = uDim2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			imageStyle = {
				Color3 = t4.brickColor.Color
			}
		})

		return t5
	end, {
		v44.offset.X,
		v44.offset.Y,
		Size_350,
		Size_400
	})
	local v48 = React.useCallback(function() -- line: 285
		-- upvalues: p1 (copy), v43 (copy), v47 (copy)
		local t6 = {}
		local v91 = p1.selectedColor and p1.selectedColor:getValue() or nil

		for v92, v93 in v43 do
			local v94 = v91 ~= nil and v91 == v93.brickColor.Color

			for v95, v96 in (v47(v93, v94)) do
				t6[`{ v95 }_{ v92 }`] = v96
			end
		end

		return t6
	end, { p1.selectedColor })

	return React.createElement(View, withCommonProps(p1, {
		tag = "col align-x-center gap-small size-full-0 auto-y"
	}), {
		ColorGrid = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v44.width, v44.height),
			onActivated = v45,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, (v48())),
		BottomRow = React.createElement(View, {
			tag = "stroke-standard stroke-muted radius-circle bg-surface-100",
			LayoutOrder = 2,
			Size = UDim2.new(1, -v32.Size.Size_400, 0, v32.Size.Size_500),
			onActivated = v46,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, {
			Swatches = React.createElement(BottomRowSwatches, {
				colors = v41,
				paddingHorizontal = Size_100,
				swatchWidth = Size_350_2,
				swatchHeight = Size_400_2,
				swatchCenterY = v32.Size.Size_250
			})
		})
	})
end

return BrickColorPicker
