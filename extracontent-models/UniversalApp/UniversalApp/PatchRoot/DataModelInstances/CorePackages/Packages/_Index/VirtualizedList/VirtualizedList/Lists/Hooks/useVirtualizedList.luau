local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)

local function calculateBounds(virtualizedItems, state: number, p: number)
	local v = (math.max)(p, 0)
	local total = 0
	local v2 = 0
	local v3 = 0

	for k, item in virtualizedItems do
		if total <= v then
			v2 = k
		end

		total += item.height

		if v <= total then
			v3 = k
		end

		if v + state <= total then
			break
		end
	end

	return (Vector3.new(v2, v3))
end

local function useVirtualizedList(props)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(function()
		return calculateBounds(props.virtualizedItems, state, 0)
	end)

	local ref = React.useRef(0)
	local v = React.useCallback(function(current: number)
		if ref.current == current then
			return
		end

		ref.current = current
		setState2(calculateBounds(props.virtualizedItems, state, current))
	end, { state, props.virtualizedItems })

	React.useEffect(function()
		local current = props.scrollingFrameRef.current

		if current == nil then
			return
		end

		setState(current.AbsoluteWindowSize.Y)
		v(current.CanvasPosition.Y)

		local absoluteWindowSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
			setState(current.AbsoluteWindowSize.Y)
		end)

		local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			v(current.CanvasPosition.Y)
		end)

		return function()
			absoluteWindowSizeChangedConnection:Disconnect()
			canvasPositionChangedConnection:Disconnect()
		end
	end, { v })

	local v2 = React.useMemo(function()
		local total = 0

		for _, virtualizedItem in props.virtualizedItems do
			total += virtualizedItem.height
		end

		return total
	end, { props.virtualizedItems })

	React.useEffect(function()
		local current = props.scrollingFrameRef.current

		if current then
			current.CanvasSize = UDim2.new(1, 0, 0, v2)
		end
	end, { v2 })

	React.useLayoutEffect(function()
		setState2(calculateBounds(props.virtualizedItems, state, ref.current))
	end, { state, props.virtualizedItems })

	local v3 = React.useCallback(function(p: string)
		local current = props.scrollingFrameRef.current
		assert(current ~= nil, "VirtualizedList has not been mounted yet")
		local total = 0

		for _, virtualizedItem in props.virtualizedItems do
			if virtualizedItem.key == p then
				current.CanvasPosition = Vector2.new(0, total)
				break
			end

			total += virtualizedItem.height
		end
	end, { props.virtualizedItems })

	local children = {}
	local total = 0

	for i = 1, state2.X - 1 do
		local virtualizedItem = props.virtualizedItems[i]

		if virtualizedItem == nil then
			break
		end

		total += virtualizedItem.height
	end

	for i = state2.X, state2.Y do
		local virtualizedItem = props.virtualizedItems[i]

		if virtualizedItem == nil then
			break
		end

		children[virtualizedItem.key] = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, total),
				Size = UDim2.new(1, 0, 0, virtualizedItem.height)
			},
			props.renderItem(virtualizedItem)
		)

		total += virtualizedItem.height
	end

	return children, v3
end

return useVirtualizedList
