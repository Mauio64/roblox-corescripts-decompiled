local parent = script:FindFirstAncestor("VideoUtils").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function VideoProgressBar(props)
	local v = useTokens()

	local muted = v.DarkMode.Content.Muted
	local emphasis = v.Color.Content.Emphasis

	return React.createElement("Frame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		BackgroundColor3 = muted.Color3,
		BackgroundTransparency = muted.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		ProgressFill = React.createElement("Frame", {
			Size = props.progressBinding:map(function(p: number)
				return UDim2.fromScale(p, 1)
			end),
			BackgroundColor3 = emphasis.Color3,
			BackgroundTransparency = emphasis.Transparency,
			BorderSizePixel = 0
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
		})
	})
end

return VideoProgressBar
