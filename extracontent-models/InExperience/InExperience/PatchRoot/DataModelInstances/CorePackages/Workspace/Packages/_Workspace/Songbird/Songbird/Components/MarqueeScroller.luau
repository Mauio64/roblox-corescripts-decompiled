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

local v = { speed = 20, direction = Enum.TextDirection.LeftToRight }

local function calculateInstances(x: number, x2: number) -- 1 equivalent call inferred from this helper
	if x == 0 then
		return 2
	end

	local v2 = math.max(math.ceil(x2 / x) + 1, 2)
	return if v2 == v2 then v2 else 2
end

local function MarqueeScroller(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useTokens()
	local v3

	if joined.padding then
		v3 = joined.padding
	else
		v3 = v2.Margin.Large
	end

	local v4 = joined.direction == Enum.TextDirection.LeftToRight

	local v5, v6 = useBinding(0)
	local state, setState = useState(Vector2.new(1e999, 1e999))
	local state2, setState2 = useState(Vector2.new(1e999, 1e999))
	local v7 = state.X + v3

	local v8 = useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, {})

	local onAbsoluteSizeChanged = useCallback(function(p2)
		setState2(p2.AbsoluteSize)
	end, {})

	local children = {}
	local instances = calculateInstances(state.X, state2.X) -- inferred equivalent call

	for i = 1, instances do
		local formatted = `Content{i}`
		local createElement = React.createElement
		local view = Foundation.View
		local onAbsoluteSizeChanged2

		if i == 1 then
			onAbsoluteSizeChanged2 = v8
		end

		children[formatted] = createElement(
			view,
			{ tag = "auto-xy", onAbsoluteSizeChanged = onAbsoluteSizeChanged2, LayoutOrder = i },
			joined.children
		)
	end

	useEventConnection(RunService.Heartbeat, function(p2)
		if joined.speed > 0 then
			local v9 = v5:getValue() + joined.speed * p2

			if v7 <= v9 then
				v9 -= v7
			end

			v6(v9)
		end
	end, { joined.speed, v7 })

	return React.createElement(
		Foundation.View,
		{
			tag = "size-full auto-y clip",
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			LayoutOrder = joined.LayoutOrder
		},
		{
			Scroller = React.createElement(Foundation.View, {
				tag = "auto-xy row data-testid=scroller",
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v3)
				},
				Position = v5:map(function(p2: number)
					if v4 then
						return UDim2.new(0, p2 * -1, 0, 0)
					end

					return UDim2.new(-1, p2, 0, 0)
				end)
			}, children)
		}
	)
end

return MarqueeScroller
