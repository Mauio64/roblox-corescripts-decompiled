local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Dash")

local v5 = {
	offset = Vector2.new(),
	rotation = 90,
	transparency = NumberSequence.new(0)
}

local function BackgroundGradient(p2)
	local joined = Dash.join(v5, p2)

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = joined.ZIndex,
		[React.Tag] = joined.tag
	}, {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = joined.cornerRadius
		}),
		UIGradient = React.createElement("UIGradient", {
			Color = joined.colorSequence,
			Offset = joined.offset,
			Rotation = joined.rotation,
			Transparency = joined.transparency
		})
	})
end

return BackgroundGradient
