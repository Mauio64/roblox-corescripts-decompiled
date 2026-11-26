local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local view = Foundation.View
local image = Foundation.Image

local useExperienceBannerImage = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useExperienceBannerImage")
local useGameInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useGameInfo")

local function ExperienceDetailsBannerImageSkeleton()
	return React.createElement(view, { tag = "size-full bg-surface-100" })
end

local function ExperienceDetailsBannerImageError(p2)
	local v5 = useGameInfo(p2.universeId)
	local v6 = useExperienceBannerImage(p2.universeId)

	local v7 = v5 and v5.isUnavailable == true
	local v8 = v6.status == "Success" and v6.url

	if v7 or not v8 then
		return React.createElement(ExperienceDetailsBannerImageSkeleton)
	end

	return React.createElement(image, {
		Image = v6.url,
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Crop
	})
end

return {
	Skeleton = React.memo(ExperienceDetailsBannerImageSkeleton),
	Error = React.memo(ExperienceDetailsBannerImageError)
}
