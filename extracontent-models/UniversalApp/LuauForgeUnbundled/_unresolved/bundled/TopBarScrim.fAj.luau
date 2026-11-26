local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function TopBarScrim(p2)
	local v5 = useTokens()
	local surface_0 = v5.Color.Surface.Surface_0

	return React.createElement(
		Foundation.View,
		{
			backgroundStyle = surface_0,
			Size = UDim2.new(1, 0, 1, v5.Size.Size_500),
			ZIndex = p2.ZIndex
		},
		{
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.2),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}
	)
end

return TopBarScrim
