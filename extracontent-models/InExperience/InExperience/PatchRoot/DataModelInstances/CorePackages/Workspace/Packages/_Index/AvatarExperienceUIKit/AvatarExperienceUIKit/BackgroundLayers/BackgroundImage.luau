local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local connectImageLoaded = require(script.Parent.connectImageLoaded)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXBackgroundImageOnLoaded = AvatarExperienceFlags.FFlagAXBackgroundImageOnLoaded

local v = {
	anchorPoint = Vector2.new(0.5, 0.5),
	color = Color3.fromRGB(255, 255, 255),
	position = UDim2.fromScale(0.5, 0.5),
	resourceIdentifier = "",
	scaleType = Enum.ScaleType.Fit
}

local function BackgroundImage(p)
	local joined = Dash.join(v, p)
	local ref2

	if FFlagAXBackgroundImageOnLoaded then
		local onLoaded = joined.onLoaded
		local resourceIdentifier = joined.resourceIdentifier

		local ref = React.useRef(nil)
		ref2 = React.useCallback(function(p2)
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end

			if not p2 or not onLoaded or resourceIdentifier == "" then
				return
			end

			ref.current = connectImageLoaded(p2, onLoaded)
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

	if not (FFlagAXBackgroundImageOnLoaded and joined.onLoaded) then
		ref2 = nil
	end

	tagsByTag.ref = ref2
	return createElement("ImageLabel", tagsByTag, {
		CornerRadius = React.createElement("UICorner", { CornerRadius = joined.cornerRadius })
	})
end

return BackgroundImage
