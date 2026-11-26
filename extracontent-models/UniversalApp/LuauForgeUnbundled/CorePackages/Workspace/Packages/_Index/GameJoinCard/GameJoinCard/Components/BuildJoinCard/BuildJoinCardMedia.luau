local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")

local image = Foundation.Image
local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailType = Foundation.Enums.ThumbnailType
local thumbnailSize = Foundation.Enums.ThumbnailSize

local function BuildJoinCardMedia(p2)
	local v5 = p2.slot == "Banner"
	local createElement = React.createElement

	local v8 = if v5 then getRbxThumb(thumbnailType.Avatar, p2.userId, thumbnailSize.Large) else getRbxThumb(
		thumbnailType.AvatarHeadShot,
		p2.userId,
		thumbnailSize.Medium
	)
	local v7 = {
		Image = v8,
		ScaleType = Enum.ScaleType.Fit,
		tag = {
			["size-full"] = true,
			["radius-small bg-surface-200"] = not v5
		}
	}

	local v10 = if v5 then React.createElement("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.7, 0),
			NumberSequenceKeypoint.new(1, 1)
		})
	}) else nil
	return createElement(image, v7, { BottomFade = v10 })
end

return BuildJoinCardMedia
