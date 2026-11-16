local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)

local BackgroundGradient = require(script.Parent.BackgroundGradient)
local BackgroundImage = require(script.Parent.BackgroundImage)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXBackgroundImageOnLoaded = AvatarExperienceFlags.FFlagAXBackgroundImageOnLoaded

local function BackgroundLayers(props)
	local children = {}

	for k, backgroundLayer in props.backgroundLayers do
		local zIndex = (props.ZIndex or 0) - (#props.backgroundLayers - k)

		if backgroundLayer.type == "GradientBackground" then
			children[`GradientBackground_{k}`] = React.createElement(BackgroundGradient, {
				colorSequence = backgroundLayer.colorSequence,
				cornerRadius = props.cornerRadius,
				offset = backgroundLayer.offset,
				rotation = backgroundLayer.rotation,
				transparency = backgroundLayer.transparency,
				ZIndex = zIndex,
				tag = backgroundLayer.tag
			})
		elseif backgroundLayer.type == "ImageBackground" then
			local formatted = `ImageBackground_{k}`
			local createElement = React.createElement
			local v = {
				anchorPoint = backgroundLayer.anchorPoint,
				color = backgroundLayer.color,
				cornerRadius = props.cornerRadius,
				position = backgroundLayer.position,
				resourceIdentifier = backgroundLayer.resourceIdentifier,
				transparency = backgroundLayer.transparency,
				ZIndex = zIndex,
				tag = backgroundLayer.tag,
				scaleType = props.imageScaleType,
				onLoaded = 0
			}
			local onLoaded

			if FFlagAXBackgroundImageOnLoaded then
				onLoaded = props.onImageLoaded
			end

			v.onLoaded = onLoaded
			children[formatted] = createElement(BackgroundImage, v)
		end
	end

	return React.createElement(React.Fragment, nil, children)
end

return BackgroundLayers
