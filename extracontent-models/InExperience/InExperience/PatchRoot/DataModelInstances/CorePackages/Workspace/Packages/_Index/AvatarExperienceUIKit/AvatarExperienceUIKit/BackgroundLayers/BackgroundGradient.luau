local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local t1 = {
	rotation = 90,
	offset = Vector2.new(),
	transparency = NumberSequence.new(0)
}

local function BackgroundGradient(t2: {[any]: any}) -- line: 22
	-- upvalues: Dash (copy), t1 (copy), React (copy)
	local v7 = Dash.join(t1, t2)

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = v7.ZIndex,
		[React.Tag] = v7.tag
	}, {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = v7.cornerRadius
		}),
		UIGradient = React.createElement("UIGradient", {
			Color = v7.colorSequence,
			Offset = v7.offset,
			Rotation = v7.rotation,
			Transparency = v7.transparency
		})
	})
end

return BackgroundGradient
