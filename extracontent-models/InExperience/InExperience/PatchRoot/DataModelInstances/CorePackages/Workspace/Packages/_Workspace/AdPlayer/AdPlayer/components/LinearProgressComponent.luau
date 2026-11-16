local parent = script:FindFirstAncestor("AdPlayer").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function LinearProgressComponent(props)
	local v = useTokens()

	return React.createElement("Frame", {
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Size = props.Size,
		ZIndex = props.ZIndex,
		BackgroundColor3 = v.Color.Extended.White.White_30.Color3,
		BackgroundTransparency = v.Color.Extended.White.White_30.Transparency,
		BorderSizePixel = 0
	}, {
		progressFill = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = props.alpha:map(function(p)
				return UDim2.fromScale(p, 1)
			end),
			BackgroundColor3 = v.Color.Extended.White.White_100.Color3
		})
	})
end

return LinearProgressComponent
