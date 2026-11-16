local RunService = game:GetService("RunService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils")

local useCallback = React.useCallback
local useBinding = React.useBinding
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens
local useEventConnection = ReactUtils.useEventConnection

local v5 = { speed = 20, direction = Enum.TextDirection.LeftToRight }

local function calculateInstances(p2, p3)
	if p2 == 0 then
		return 2
	end

	local v6 = math.max(math.ceil(p3 / p2) + 1, 2)

	if v6 == v6 then
		return v6
	end

	return 2
end

local function MarqueeScroller(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useTokens()
	local v7 = if joined.padding then joined.padding else v6.Margin.Large
	local v8 = joined.direction == Enum.TextDirection.LeftToRight

	local v9, v10 = useBinding(0)
	local state, setState = useState(Vector2.new(1e999, 1e999))
	local state2, setState2 = useState(Vector2.new(1e999, 1e999))
	local v11 = state.X + v7

	local v12 = useCallback(function(p3)
		setState(p3.AbsoluteSize)
	end, {})

	local v13 = useCallback(function(p3)
		setState2(p3.AbsoluteSize)
	end, {})

	local children = {}
	local x = state.X
	local x2 = state2.X
	local v14

	if x == 0 then
		v14 = 2
	else
		local v15 = math.max(math.ceil(x2 / x) + 1, 2)
		v14 = v15 ~= v15 and 2 or v15
	end

	for i = 1, v14 do
		local formatted = `Content{i}`
		local createElement = React.createElement
		local view = Foundation.View

		local v16 = if i == 1 then v12 else nil
		children[formatted] = createElement(
			view,
			{ tag = "auto-xy", onAbsoluteSizeChanged = v16, LayoutOrder = i },
			joined.children
		)
	end

	useEventConnection(RunService.Heartbeat, function(p3)
		if joined.speed > 0 then
			local v15 = v9:getValue() + joined.speed * p3

			if v11 <= v15 then
				v15 -= v11
			end

			v10(v15)
		end
	end, { joined.speed, v11 })

	return React.createElement(
		Foundation.View,
		{
			tag = "size-full auto-y clip",
			onAbsoluteSizeChanged = v13,
			LayoutOrder = joined.LayoutOrder
		},
		{
			Scroller = React.createElement(Foundation.View, {
				tag = "auto-xy row data-testid=scroller",
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v7)
				},
				Position = v9:map(function(p3)
					if v8 then
						return UDim2.new(0, -1 * p3, 0, 0)
					end

					return UDim2.new(-1, p3, 0, 0)
				end)
			}, children)
		}
	)
end

return MarqueeScroller
