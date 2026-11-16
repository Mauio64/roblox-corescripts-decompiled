local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ChromeShared = script.Parent.Parent.ChromeShared
local GetStyleTokens = require(ChromeShared.Utility.GetStyleTokens)

local color = Color3.new(0.918, 0.2, 0.137)

return function(props)
	local v = React.useMemo(function()
		return GetStyleTokens().Size.Size_100
	end, {})
	return React.createElement("Frame", {
		Name = props.name or "RedDot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = props.position,
		Size = UDim2.fromOffset(v, v),
		BackgroundColor3 = color,
		Visible = props.visible
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})
end
