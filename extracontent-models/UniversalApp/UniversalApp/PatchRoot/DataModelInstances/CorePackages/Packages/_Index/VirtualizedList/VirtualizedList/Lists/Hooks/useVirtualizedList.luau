local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)

local function calculateBounds(t1: {[any]: any}, n1: number, n2: number) -- line: 17
	local v8 = math.max(n2, 0)
	local n3 = 0
	local n4 = 0
	local n5 = 0

	for v12, v13 in t1 do
		if n3 <= v8 then
			n4 = v12
		end

		n3 += v13.height

		if v8 <= n3 then
			n5 = v12
		end

		if n3 >= v8 + n1 then
			return (Vector3.new(n4, n5))
		end
	end

	return (Vector3.new(n4, n5))
end
local function useVirtualizedList(t2: {[any]: any}) -- line: 56
	-- upvalues: React (copy), calculateBounds (copy)
	local v15, v16 = React.useState(0)
	local v17, v18 = React.useState(function() -- line: 58
		-- upvalues: calculateBounds (copy), t2 (copy), v15 (copy)
		return (calculateBounds(t2.virtualizedItems, v15, 0))
	end)
	local v19 = React.useRef(0)
	local v20 = React.useCallback(function(n6: number) -- line: 63
		-- upvalues: v19 (copy), v18 (copy), calculateBounds (copy), t2 (copy), v15 (copy)
		if n6 == v19.current then
			return
		end

		v19.current = n6
		v18((calculateBounds(t2.virtualizedItems, v15, n6)))
	end, {
		v15,
		t2.virtualizedItems
	})

	React.useEffect(function() -- line: 72
		-- upvalues: t2 (copy), v16 (copy), v20 (copy)
		local current = t2.scrollingFrameRef.current

		if current == nil then
			return
		end

		local connection = current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 80
			-- upvalues: v16 (copy), current (copy)
			v16(current.AbsoluteWindowSize.Y)
		end)
		local connection2 = current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 86
			-- upvalues: v20 (copy), current (copy)
			v20(current.CanvasPosition.Y)
		end)

		return function() -- line: 90
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { v20 })

	local v21 = React.useMemo(function() -- line: 97
		-- upvalues: t2 (copy)
		local n7 = 0

		for _, v35 in t2.virtualizedItems do
			n7 += v35.height
		end

		return n7
	end, { t2.virtualizedItems })

	React.useEffect(function() -- line: 108
		-- upvalues: t2 (copy), v21 (copy)
		local current = t2.scrollingFrameRef.current

		if current then
			current.CanvasSize = UDim2.new(1, 0, 0, v21)
		end
	end, { v21 })
	React.useLayoutEffect(function() -- line: 115
		-- upvalues: v18 (copy), calculateBounds (copy), t2 (copy), v15 (copy), v19 (copy)
		v18((calculateBounds(t2.virtualizedItems, v15, v19.current)))
	end, {
		v15,
		t2.virtualizedItems
	})

	local v22 = React.useCallback(function(s1: string) -- line: 119
		-- upvalues: t2 (copy)
		local current = t2.scrollingFrameRef.current

		assert(current ~= nil, "VirtualizedList has not been mounted yet")

		local n8 = 0

		for _, v41 in t2.virtualizedItems do
			if s1 == v41.key then
				current.CanvasPosition = Vector2.new(0, n8)

				return
			end

			n8 += v41.height
		end
	end, { t2.virtualizedItems })
	local t3 = {}
	local n9 = 0

	for i = 1, v17.X - 1 do
		local v26 = t2.virtualizedItems[i]

		if v26 == nil then
			break
		end

		n9 += v26.height
	end

	for i = v17.X, v17.Y do
		local v28 = t2.virtualizedItems[i]

		if v28 == nil then
			return t3, v22
		end

		t3[v28.key] = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, n9),
			Size = UDim2.new(1, 0, 0, v28.height)
		}, t2.renderItem(v28))
		n9 += v28.height
	end

	return t3, v22
end

return useVirtualizedList
