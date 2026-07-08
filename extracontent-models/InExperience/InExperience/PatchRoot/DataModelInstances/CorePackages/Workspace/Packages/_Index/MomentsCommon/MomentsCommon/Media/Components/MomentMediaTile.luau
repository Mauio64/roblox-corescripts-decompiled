local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local React = require(Parent.React)
local MomentMediaView = require(script.Parent.MomentMediaView)

require(script.Parent.Parent.MediaTypes)

local useVideoPosterFrame = require(script.Parent.Parent.useVideoPosterFrame)

local function MomentMediaTile(t1: {[any]: any}) -- line: 23
	-- upvalues: useVideoPosterFrame (copy), React (copy), MomentMediaView (copy)
	local mediaItem = t1.mediaItem
	local cornerRadius = mediaItem.cornerRadius
	local v9 = mediaItem.captureType == Enum.CaptureType.Video
	local v10 = if not v9 then nil else mediaItem.content
	local v11 = useVideoPosterFrame(v10) or mediaItem.posterContent

	if t1.isActive and v9 then
		return React.createElement(MomentMediaView, {
			suppressTapToToggle = true,
			holdPosterUntilPlaying = true,
			tag = "size-full clip",
			momentId = mediaItem.momentId,
			posterContent = v11,
			cornerRadius = cornerRadius
		})
	end

	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ImageContent = v11,
		ScaleType = Enum.ScaleType.Crop
	}, {
		Corner = if cornerRadius == nil then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, cornerRadius)
		})
	})
end

return MomentMediaTile
