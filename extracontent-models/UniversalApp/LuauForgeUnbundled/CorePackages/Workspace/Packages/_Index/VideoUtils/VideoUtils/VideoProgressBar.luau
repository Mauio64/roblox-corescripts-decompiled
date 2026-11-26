local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Foundation").Hooks.useTokens

local function VideoProgressBar(props)
	local v5 = useTokens()

	local muted = v5.DarkMode.Content.Muted
	local emphasis = v5.Color.Content.Emphasis

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
			Size = props.progressBinding:map(function(p2)
				return UDim2.fromScale(p2, 1)
			end),
			BackgroundColor3 = emphasis.Color3,
			BackgroundTransparency = emphasis.Transparency,
			BorderSizePixel = 0
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		})
	})
end

return VideoProgressBar
