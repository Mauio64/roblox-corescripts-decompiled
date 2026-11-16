local RunService = game:GetService("RunService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/ReactUtils")

local view = Foundation.View
local useEventConnection = ReactUtils.useEventConnection
local useTokens = Foundation.Hooks.useTokens

local function RingingIndicator(p2)
	local v5 = useTokens()
	local v6, v7 = React.useBinding(0)

	useEventConnection(RunService.Heartbeat, function(p3)
		v7((v6:getValue() + p3) % 1.2)
	end)

	local default = v5.Color.Content.Default
	local v8 = React.useMemo(function()
		return v6:map(function(p3)
			return math.floor(p3 / 1.2 * 3) + 1
		end)
	end, { v6 })
	local v9 = React.useMemo(function()
		local children = {}

		for i = 1, 3 do
			children[`Dot{i}`] = React.createElement(view, {
				LayoutOrder = i,
				Size = UDim2.fromOffset(3, 3),
				backgroundStyle = v8:map(function(p3)
					return {
						Color3 = default.Color3,
						Transparency = p3 ~= i and 0.7 or default.Transparency
					}
				end),
				tag = "radius-circle"
			})
		end

		return children
	end, { v8, default })

	return React.createElement(
		view,
		{
			LayoutOrder = p2.LayoutOrder,
			tag = "row align-x-center align-y-center gap-xxsmall size-400-400",
			testId = p2.testId
		},
		v9
	)
end

return RingingIndicator
