local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
local useExperienceBannerImage = require(script.Parent.Parent.useExperienceBannerImage)
local useGameInfo = require(script.Parent.Parent.useGameInfo)

local function ExperienceDetailsBannerImageSkeleton() -- line: 12
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "size-full bg-surface-100"
	})
end
local function ExperienceDetailsBannerImageError(t1: {[any]: any}) -- line: 18
	-- upvalues: useGameInfo (copy), useExperienceBannerImage (copy), React (copy), ExperienceDetailsBannerImageSkeleton (copy), FoundationImage (copy)
	local v11 = useGameInfo(t1.universeId)
	local v12 = useExperienceBannerImage(t1.universeId)
	local v13 = v11 and v11.isUnavailable == true
	local v14 = v12.status == "Success" and v12.url

	if v13 or not v14 then
		return React.createElement(ExperienceDetailsBannerImageSkeleton)
	end

	return React.createElement(FoundationImage, {
		Image = v12.url,
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Crop
	})
end

return {
	Skeleton = React.memo(ExperienceDetailsBannerImageSkeleton),
	Error = React.memo(ExperienceDetailsBannerImageError)
}
