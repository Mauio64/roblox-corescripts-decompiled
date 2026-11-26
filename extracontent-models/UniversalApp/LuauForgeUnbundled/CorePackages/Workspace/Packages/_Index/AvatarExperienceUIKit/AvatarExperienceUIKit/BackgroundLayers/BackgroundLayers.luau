local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")

local BackgroundGradient = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/BackgroundLayers/BackgroundGradient")
local BackgroundImage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/BackgroundLayers/BackgroundImage")

local fFlagAXBackgroundImageOnLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXBackgroundImageOnLoaded

local function BackgroundLayers(props)
	local children = {}

	for k, backgroundLayer in props.backgroundLayers do
		local v5 = (props.ZIndex or 0) - (#props.backgroundLayers - k)

		if backgroundLayer.type == "GradientBackground" then
			children[`GradientBackground_{k}`] = React.createElement(BackgroundGradient, {
				colorSequence = backgroundLayer.colorSequence,
				cornerRadius = props.cornerRadius,
				offset = backgroundLayer.offset,
				rotation = backgroundLayer.rotation,
				transparency = backgroundLayer.transparency,
				ZIndex = v5,
				tag = backgroundLayer.tag
			})
		elseif backgroundLayer.type == "ImageBackground" then
			local formatted = `ImageBackground_{k}`
			local createElement = React.createElement
			local v7 = {
				anchorPoint = backgroundLayer.anchorPoint,
				color = backgroundLayer.color,
				cornerRadius = props.cornerRadius,
				position = backgroundLayer.position,
				resourceIdentifier = backgroundLayer.resourceIdentifier,
				transparency = backgroundLayer.transparency,
				ZIndex = v5,
				tag = backgroundLayer.tag,
				scaleType = props.imageScaleType,
				onLoaded = 0
			}
			local v8 = if fFlagAXBackgroundImageOnLoaded then props.onImageLoaded else nil
			v7.onLoaded = v8
			children[formatted] = createElement(BackgroundImage, v7)
		end
	end

	return React.createElement(React.Fragment, nil, children)
end

return BackgroundLayers
