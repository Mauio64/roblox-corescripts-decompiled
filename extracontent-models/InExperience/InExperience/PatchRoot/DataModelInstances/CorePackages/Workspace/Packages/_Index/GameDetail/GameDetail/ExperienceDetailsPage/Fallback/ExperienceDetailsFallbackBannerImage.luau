local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Image = Foundation.Image

local useExperienceBannerImage = require(script.Parent.Parent.useExperienceBannerImage)
local useGameInfo = require(script.Parent.Parent.useGameInfo)

local function ExperienceDetailsBannerImageSkeleton()
	return React.createElement(View, { tag = "size-full bg-surface-100" })
end

local function ExperienceDetailsBannerImageError(p)
	local v = useGameInfo(p.universeId)
	local v2 = useExperienceBannerImage(p.universeId)

	local v3 = v and v.isUnavailable == true
	local v4 = v2.status == "Success" and v2.url

	if v3 or not v4 then
		return React.createElement(ExperienceDetailsBannerImageSkeleton)
	end

	return React.createElement(Image, {
		Image = v2.url,
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Crop
	})
end

return {
	Skeleton = React.memo(ExperienceDetailsBannerImageSkeleton),
	Error = React.memo(ExperienceDetailsBannerImageError)
}
