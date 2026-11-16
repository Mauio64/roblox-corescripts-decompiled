local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local MomentMediaView = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Components/MomentMediaView")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
local useVideoPosterFrame = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/useVideoPosterFrame")

local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius

local function MomentMediaTile(p2)
	local mediaItem = p2.mediaItem
	local cornerRadius = mediaItem.cornerRadius
	local v5 = mediaItem.captureType == Enum.CaptureType.Video
	local v6 = if v5 then mediaItem.content else nil
	local v7 = useVideoPosterFrame(v6)

	if not v5 then
		v7 = mediaItem.posterContent
	end

	if p2.isActive and v5 then
		return React.createElement(MomentMediaView, {
			momentId = mediaItem.momentId,
			posterContent = v7,
			cornerRadius = cornerRadius,
			suppressTapToToggle = true,
			holdPosterUntilPlaying = true,
			tag = "size-full clip"
		})
	end

	local createElement = React.createElement
	local v9 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

	local createElement2 = React.createElement
	local v13 = if cornerRadius then radius.Large else radius.None
	local v10 = {
		Shimmer = createElement2(skeleton, {
			radius = v13,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1
		}),
		Poster = 0
	}
	local v14

	if v7 ~= nil then
		local createElement3 = React.createElement
		local v16 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ImageContent = v7,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 2
		}

		local v18 = if cornerRadius ~= nil then React.createElement("UICorner", {
			CornerRadius = UDim.new(0, cornerRadius)
		}) else nil
		v14 = createElement3("ImageLabel", v16, { Corner = v18 })
	end

	v10.Poster = v14
	return createElement("Frame", v9, v10)
end

return MomentMediaTile
