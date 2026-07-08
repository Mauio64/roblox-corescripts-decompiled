local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local BackgroundGradient = require(script.Parent.BackgroundGradient)
local BackgroundImage = require(script.Parent.BackgroundImage)
local FFlagAXHeroWidget = AvatarExperienceFlags.FFlagAXHeroWidget

local function BackgroundLayers(t1: {[any]: any}) -- line: 40
	-- upvalues: React (copy), BackgroundGradient (copy), BackgroundImage (copy), FFlagAXHeroWidget (copy)
	local t2 = {}

	for v10, v11 in t1.backgroundLayers do
		local v12 = (t1.ZIndex or 0) - (#t1.backgroundLayers - v10)

		if v11.type == "GradientBackground" then
			t2[`GradientBackground_{ v10 }`] = React.createElement(BackgroundGradient, {
				colorSequence = v11.colorSequence,
				cornerRadius = t1.cornerRadius,
				offset = v11.offset,
				rotation = v11.rotation,
				transparency = v11.transparency,
				ZIndex = v12,
				tag = v11.tag
			})
		elseif v11.type == "ImageBackground" then
			t2[`ImageBackground_{ v10 }`] = React.createElement(BackgroundImage, {
				anchorPoint = v11.anchorPoint,
				color = v11.color,
				cornerRadius = t1.cornerRadius,
				position = v11.position,
				resourceIdentifier = v11.resourceIdentifier,
				transparency = v11.transparency,
				ZIndex = v12,
				tag = v11.tag,
				scaleType = if not FFlagAXHeroWidget then nil else t1.imageScaleType
			})
		end
	end

	return React.createElement(React.Fragment, nil, t2)
end

return BackgroundLayers
