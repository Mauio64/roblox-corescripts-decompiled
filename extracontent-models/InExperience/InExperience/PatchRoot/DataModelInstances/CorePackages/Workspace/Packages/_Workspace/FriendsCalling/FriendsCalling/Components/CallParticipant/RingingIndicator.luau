local parent = script:FindFirstAncestor("FriendsCalling").Parent

local RunService = game:GetService("RunService")

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local View = Foundation.View
local useEventConnection = ReactUtils.useEventConnection
local useTokens = Foundation.Hooks.useTokens

local function RingingIndicator(p)
	local v = useTokens()
	local v2, v3 = React.useBinding(0)

	useEventConnection(RunService.Heartbeat, function(p2: number)
		v3((v2:getValue() + p2) % 1.2)
	end)

	local default = v.Color.Content.Default
	local v4 = React.useMemo(function()
		return v2:map(function(p2: number)
			return math.floor(p2 / 1.2 * 3) + 1
		end)
	end, { v2 })
	local v5 = React.useMemo(function()
		local children = {}

		for i = 1, 3 do
			children[`Dot{i}`] = React.createElement(View, {
				LayoutOrder = i,
				Size = UDim2.fromOffset(3, 3),
				backgroundStyle = v4:map(function(p2: number)
					return {
						Color3 = default.Color3,
						Transparency = p2 ~= i and 0.7 or default.Transparency
					}
				end),
				tag = "radius-circle"
			})
		end

		return children
	end, { v4, default })

	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			tag = "row align-x-center align-y-center gap-xxsmall size-400-400",
			testId = p.testId
		},
		v5
	)
end

return RingingIndicator
