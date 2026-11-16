local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactOtter")

local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox").Core.Style.useStyle

require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/MediaGalleryTypes")

local v5 = {
	zIndex = 1,
	overlayTransparency = 0.5,
	animationConfig = {
		dampingRatio = 1,
		frequency = 20 / 3
	}
}

local function CrossFadeAnimatedView(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local count = #joined.items
	local v6 = useStyle()

	local v7 = React.useCallback(function()
		if joined.crossAnim.isCrossFade then
			joined.crossAnim.setCrossFade(false)
			joined.crossAnim.setCurrentIndex(joined.crossAnim.nextIndex)
		end
	end, {
		joined.crossAnim.isCrossFade,
		joined.crossAnim.nextIndex,
		joined.crossAnim.setCrossFade,
		joined.crossAnim.setCurrentIndex
	})

	local v8, v9 = ReactOtter.useAnimatedBinding(0, v7)
	React.useEffect(function()
		if count < 2 then
			return
		end

		if joined.crossAnim.isCrossFade then
			v9(ReactOtter.spring(1, joined.animationConfig))
		else
			v9(ReactOtter.instant(0))
		end
	end, { joined.crossAnim.isCrossFade, joined.crossAnim.nextIndex, joined.animationConfig })

	local createElement = React.createElement
	local v11 = {
		Size = UDim2.fromScale(1, 1),
		ZIndex = joined.zIndex,
		Image = joined.items[joined.crossAnim.currentIndex].imageId,
		ScaleType = Enum.ScaleType.Crop,
		BackgroundTransparency = 1,
		ImageTransparency = v8
	}
	local v13

	if count >= 2 then
		v13 = React.createElement("ImageLabel", {
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromScale(1, 1),
			Image = joined.items[joined.crossAnim.nextIndex].imageId,
			ScaleType = Enum.ScaleType.Crop,
			BackgroundTransparency = 1,
			ImageTransparency = v8:map(function(p3)
				return 1 - p3
			end)
		})
	end

	return createElement("ImageLabel", v11, {
		NextImage = v13,
		Overlay = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = joined.overlayTransparency,
			BackgroundColor3 = v6.Theme.Overlay.Color
		})
	})
end

return CrossFadeAnimatedView
