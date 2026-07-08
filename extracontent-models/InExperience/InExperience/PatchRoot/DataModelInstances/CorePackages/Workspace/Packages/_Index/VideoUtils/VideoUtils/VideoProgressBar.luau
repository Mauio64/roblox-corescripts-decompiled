local Parent = script:FindFirstAncestor("VideoUtils").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function VideoProgressBar(t1: {[any]: any}) -- line: 17
	-- upvalues: useTokens (copy), React (copy)
	local v6 = useTokens()
	local Muted = v6.DarkMode.Content.Muted
	local Emphasis = v6.Color.Content.Emphasis

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		AnchorPoint = t1.AnchorPoint,
		Position = t1.Position,
		Size = t1.Size,
		BackgroundColor3 = Muted.Color3,
		BackgroundTransparency = Muted.Transparency,
		LayoutOrder = t1.LayoutOrder
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		ProgressFill = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = t1.progressBinding:map(function(n1: number) -- line: 37
				return UDim2.fromScale(n1, 1)
			end),
			BackgroundColor3 = Emphasis.Color3,
			BackgroundTransparency = Emphasis.Transparency
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		})
	})
end

return VideoProgressBar
