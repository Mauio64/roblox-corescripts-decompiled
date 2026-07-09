local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local FFlagAXHeroWidget = AvatarExperienceFlags.FFlagAXHeroWidget
local t1 = {
	resourceIdentifier = "",
	anchorPoint = Vector2.new(0.5, 0.5),
	color = Color3.fromRGB(255, 255, 255),
	position = UDim2.fromScale(0.5, 0.5),
	scaleType = if not FFlagAXHeroWidget then nil else Enum.ScaleType.Fit
}

local function BackgroundImage(t2: {[any]: any}) -- line: 31
	-- upvalues: Dash (copy), t1 (copy), React (copy), FFlagAXHeroWidget (copy)
	local v9 = Dash.join(t1, t2)

	return React.createElement("ImageLabel", {
		AnchorPoint = v9.anchorPoint,
		Position = v9.position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = v9.resourceIdentifier,
		ImageColor3 = v9.color,
		ImageTransparency = v9.transparency,
		ScaleType = if not FFlagAXHeroWidget then Enum.ScaleType.Fit else v9.scaleType,
		Size = UDim2.fromScale(1, 1),
		ZIndex = v9.ZIndex,
		[React.Tag] = v9.tag
	}, {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = v9.cornerRadius
		})
	})
end

return BackgroundImage
