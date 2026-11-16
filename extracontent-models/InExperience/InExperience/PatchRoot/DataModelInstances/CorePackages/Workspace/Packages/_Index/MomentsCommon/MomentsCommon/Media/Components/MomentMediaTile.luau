local parent = script:FindFirstAncestor("MomentsCommon").Parent
local Foundation = require(parent.Foundation)

local React = require(parent.React)

local MomentMediaView = require(script.Parent.MomentMediaView)
require(script.Parent.Parent.MediaTypes)
local useVideoPosterFrame = require(script.Parent.Parent.useVideoPosterFrame)

local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius

local function MomentMediaTile(p)
	local mediaItem = p.mediaItem
	local cornerRadius = mediaItem.cornerRadius
	local v = mediaItem.captureType == Enum.CaptureType.Video
	local v2

	if v then
		v2 = mediaItem.content
	end

	local v3 = useVideoPosterFrame(v2)

	if not v then
		v3 = mediaItem.posterContent
	end

	if p.isActive and v then
		return React.createElement(MomentMediaView, {
			momentId = mediaItem.momentId,
			posterContent = v3,
			cornerRadius = cornerRadius,
			suppressTapToToggle = true,
			holdPosterUntilPlaying = true,
			tag = "size-full clip"
		})
	end

	local createElement = React.createElement
	local v4 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

	local createElement2 = React.createElement
	local radius = if cornerRadius then Radius.Large else Radius.None
	local v5 = {
		Shimmer = createElement2(Skeleton, {
			radius = radius,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1
		}),
		Poster = 0
	}
	local poster

	if v3 ~= nil then
		local createElement3 = React.createElement
		local v6 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ImageContent = v3,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 2
		}
		local corner

		if cornerRadius ~= nil then
			corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, cornerRadius) })
		end

		poster = createElement3("ImageLabel", v6, { Corner = corner })
	end

	v5.Poster = poster
	return createElement("Frame", v4, v5)
end

return MomentMediaTile
