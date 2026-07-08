local Songbird = script:FindFirstAncestor("Songbird")
local RunService = game:GetService("RunService")
local Cryo = require(Songbird.Parent.Cryo)
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local useCallback = React.useCallback
local useBinding = React.useBinding
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens
local useEventConnection = ReactUtils.useEventConnection
local t1 = {
	speed = 20,
	direction = Enum.TextDirection.LeftToRight
}

local function calculateInstances(n1: number, n2: number) -- line: 31
	if n1 == 0 then
		return 2
	end

	local v17 = math.max(math.ceil(n2 / n1) + 1, 2)

	if v17 ~= v17 then
		return 2
	end

	return v17
end
local function MarqueeScroller(t2: {[any]: any}) -- line: 45
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), useBinding (copy), useState (copy), useCallback (copy), React (copy), Foundation (copy), useEventConnection (copy), RunService (copy)
	local v19 = Cryo.Dictionary.join(t1, t2)
	local v20 = useTokens()
	local v21 = if not v19.padding then v20.Margin.Large else v19.padding
	local v22 = v19.direction == Enum.TextDirection.LeftToRight
	local v23, v24 = useBinding(0)
	local v25, v26 = useState(Vector2.new(1e999, 1e999))
	local v27, v28 = useState(Vector2.new(1e999, 1e999))
	local v29 = v25.X + v21
	local v30 = useCallback(function(p1) -- line: 57
		-- upvalues: v26 (copy)
		v26(p1.AbsoluteSize)
	end, {})
	local v31 = useCallback(function(p2) -- line: 61
		-- upvalues: v28 (copy)
		v28(p2.AbsoluteSize)
	end, {})
	local t3 = {}
	local X = v25.X
	local X2 = v27.X
	local n3

	if X == 0 then
		n3 = 2
	else
		local v36 = math.max(math.ceil(X2 / X) + 1, 2)

		n3 = if v36 == v36 then v36 else 2
	end

	for i = 1, n3 do
		t3[`Content{ i }`] = React.createElement(Foundation.View, {
			tag = "auto-xy",
			onAbsoluteSizeChanged = if i ~= 1 then nil else v30,
			LayoutOrder = i
		}, v19.children)
	end

	useEventConnection(RunService.Heartbeat, function(p3) -- line: 76
		-- upvalues: v19 (copy), v23 (copy), v29 (copy), v24 (copy)
		if v19.speed > 0 then
			local v41 = v23:getValue() + v19.speed * p3

			if v41 >= v29 then
				v41 -= v29
			end

			v24(v41)
		end
	end, {
		v19.speed,
		v29
	})

	return React.createElement(Foundation.View, {
		tag = "size-full auto-y clip",
		onAbsoluteSizeChanged = v31,
		LayoutOrder = v19.LayoutOrder
	}, {
		Scroller = React.createElement(Foundation.View, {
			tag = "auto-xy row data-testid=scroller",
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v21)
			},
			Position = v23:map(function(n4: number) -- line: 97
				-- upvalues: v22 (copy)
				if v22 then
					return UDim2.new(0, n4 * -1, 0, 0)
				end

				return UDim2.new(-1, n4, 0, 0)
			end)
		}, t3)
	})
end

return MarqueeScroller
