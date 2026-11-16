local parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

require(script.Parent.MediaGalleryTypes)

local v = {
	zIndex = 1,
	overlayTransparency = 0.5,
	animationConfig = {
		dampingRatio = 1,
		frequency = 20 / 3
	}
}

local function CrossFadeAnimatedView(p)
	local joined = Cryo.Dictionary.join(v, p)
	local count = #joined.items
	local v2 = useStyle()

	local v3 = React.useCallback(function()
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

	local imageTransparency, v4 = ReactOtter.useAnimatedBinding(0, v3)
	React.useEffect(function()
		if count < 2 then
			return
		end

		if joined.crossAnim.isCrossFade then
			v4(ReactOtter.spring(1, joined.animationConfig))
		else
			v4((ReactOtter.instant(0)))
		end
	end, { joined.crossAnim.isCrossFade, joined.crossAnim.nextIndex, joined.animationConfig })

	local createElement = React.createElement
	local v5 = {
		Size = UDim2.fromScale(1, 1),
		ZIndex = joined.zIndex,
		Image = joined.items[joined.crossAnim.currentIndex].imageId,
		ScaleType = Enum.ScaleType.Crop,
		BackgroundTransparency = 1,
		ImageTransparency = imageTransparency
	}
	local nextImage

	if count >= 2 then
		nextImage = React.createElement("ImageLabel", {
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromScale(1, 1),
			Image = joined.items[joined.crossAnim.nextIndex].imageId,
			ScaleType = Enum.ScaleType.Crop,
			BackgroundTransparency = 1,
			ImageTransparency = imageTransparency:map(function(p2)
				return 1 - p2
			end)
		})
	end

	return createElement("ImageLabel", v5, {
		NextImage = nextImage,
		Overlay = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = joined.overlayTransparency,
			BackgroundColor3 = v2.Theme.Overlay.Color
		})
	})
end

return CrossFadeAnimatedView
