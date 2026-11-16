local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Image = require(Foundation.Components.Image)

local MediaAspectRatio = require(Foundation.Enums.MediaAspectRatio)

local MediaOrientation = require(Foundation.Enums.MediaOrientation)

require(Foundation.Components.Types)

local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	[MediaAspectRatio.Ratio1x1] = 1,
	[MediaAspectRatio.Ratio5x4] = 1.25,
	[MediaAspectRatio.Ratio4x3] = 4 / 3,
	[MediaAspectRatio.Ratio3x2] = 1.5,
	[MediaAspectRatio.Ratio16x9] = 16 / 9,
	[MediaAspectRatio.Ratio2x1] = 2
}

local v2 = {
	aspectRatio = MediaAspectRatio.Ratio1x1,
	orientation = MediaOrientation.Landscape,
	testId = "--foundation-media"
}

local function Media(p)
	local v3 = withDefaults(p, v2)

	local aspectRatio = React.useMemo(function()
		local aspectRatio = v[v3.aspectRatio]

		if v3.orientation == MediaOrientation.Portrait then
			aspectRatio = 1 / aspectRatio
		end

		return {
			AspectRatio = aspectRatio,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Width
		}
	end, { v3.aspectRatio, v3.orientation })

	local content = v3.content
	local image

	if content and content.type == "Image" then
		image = content.source
	end

	return React.createElement(
		Image,
		withCommonProps(v3, {
			Image = image,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 0),
			aspectRatio = aspectRatio
		})
	)
end

return React.memo(Media)
