local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Packages
local React = require(Packages.React)
local UIBlox = require(Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local udim = UDim2.fromOffset(4, 4)
local vector2 = Vector2.new(0.5, 0.5)
local udim2 = UDim2.fromScale(0.8, 0.8)

local function CameraStatusDot(props)
	local v = useStyle()

	local createElement = React.createElement
	local v2 = {
		AnchorPoint = props.AnchorPoint or vector2,
		Size = 0,
		BackgroundColor3 = 0,
		Position = 0,
		ZIndex = 0
	}
	local size = if props.Size then props.Size else udim
	v2.Size = size
	v2.BackgroundColor3 = v.Theme.OnlineStatus.Color
	v2.Position = props.Position or udim2
	v2.ZIndex = props.ZIndex
	return createElement("Frame", v2, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})
end

return CameraStatusDot
