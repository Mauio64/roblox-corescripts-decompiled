local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Image = Foundation.Image
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize

local function BuildJoinCardMedia(p)
	local v = p.slot == "Banner"
	local createElement = React.createElement
	local image

	if v then
		image = getRbxThumb(ThumbnailType.Avatar, p.userId, ThumbnailSize.Large)
	else
		image = getRbxThumb(ThumbnailType.AvatarHeadShot, p.userId, ThumbnailSize.Medium)
	end

	local v2 = {
		Image = image,
		ScaleType = Enum.ScaleType.Fit,
		tag = {
			["size-full"] = true,
			["radius-small bg-surface-200"] = not v
		}
	}
	local bottomFade

	if v then
		bottomFade = React.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.7, 0),
				NumberSequenceKeypoint.new(1, 1)
			})
		})
	end

	return createElement(Image, v2, { BottomFade = bottomFade })
end

return BuildJoinCardMedia
