local Parent = script:FindFirstAncestor("AdPlayer").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function LinearProgressComponent(t1: {[any]: any}) -- line: 16
	-- upvalues: useTokens (copy), React (copy)
	local v6 = useTokens()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint,
		Size = t1.Size,
		ZIndex = t1.ZIndex,
		BackgroundColor3 = v6.Color.Extended.White.White_30.Color3,
		BackgroundTransparency = v6.Color.Extended.White.White_30.Transparency
	}, {
		progressFill = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = t1.alpha:map(function(p1) -- line: 31
				return UDim2.fromScale(p1, 1)
			end),
			BackgroundColor3 = v6.Color.Extended.White.White_100.Color3
		})
	})
end

return LinearProgressComponent
