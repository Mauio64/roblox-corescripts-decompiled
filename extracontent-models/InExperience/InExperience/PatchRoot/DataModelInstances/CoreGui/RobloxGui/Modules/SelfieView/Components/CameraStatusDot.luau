local Packages = game:GetService("CorePackages").Packages
local React = require(Packages.React)
local useStyle = require(Packages.UIBlox).Core.Style.useStyle
local uDim2 = UDim2.fromOffset(4, 4)
local vector2 = Vector2.new(0.5, 0.5)
local uDim2_2 = UDim2.fromScale(0.8, 0.8)

local function CameraStatusDot(t1: {[any]: any}) -- line: 18
	-- upvalues: useStyle (copy), React (copy), vector2 (copy), uDim2 (copy), uDim2_2 (copy)
	local v9 = useStyle()

	return React.createElement("Frame", {
		AnchorPoint = t1.AnchorPoint or vector2,
		Size = if not t1.Size then uDim2 else t1.Size,
		BackgroundColor3 = v9.Theme.OnlineStatus.Color,
		Position = t1.Position or uDim2_2,
		ZIndex = t1.ZIndex
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})
	})
end

return CameraStatusDot
