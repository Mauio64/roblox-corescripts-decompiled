local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Dash")
local connectImageLoaded = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/BackgroundLayers/connectImageLoaded")

local fFlagAXBackgroundImageOnLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXBackgroundImageOnLoaded

local v5 = {
	anchorPoint = Vector2.new(0.5, 0.5),
	color = Color3.fromRGB(255, 255, 255),
	position = UDim2.fromScale(0.5, 0.5),
	resourceIdentifier = "",
	scaleType = Enum.ScaleType.Fit
}

local function BackgroundImage(p2)
	local joined = Dash.join(v5, p2)
	local v6

	if fFlagAXBackgroundImageOnLoaded then
		local onLoaded = joined.onLoaded
		local resourceIdentifier = joined.resourceIdentifier

		local ref = React.useRef(nil)
		v6 = React.useCallback(function(p3)
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end

			if not p3 or not onLoaded or resourceIdentifier == "" then
				return
			end

			ref.current = connectImageLoaded(p3, onLoaded)
		end, { onLoaded, resourceIdentifier })
	end

	local createElement = React.createElement
	local tagsByTag = {
		AnchorPoint = joined.anchorPoint,
		Position = joined.position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = joined.resourceIdentifier,
		ImageColor3 = joined.color,
		ImageTransparency = joined.transparency,
		ScaleType = joined.scaleType,
		Size = UDim2.fromScale(1, 1),
		ZIndex = joined.ZIndex,
		[React.Tag] = joined.tag
	}

	if not (fFlagAXBackgroundImageOnLoaded and joined.onLoaded) then
		v6 = nil
	end

	tagsByTag.ref = v6
	return createElement("ImageLabel", tagsByTag, {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = joined.cornerRadius
		})
	})
end

return BackgroundImage
