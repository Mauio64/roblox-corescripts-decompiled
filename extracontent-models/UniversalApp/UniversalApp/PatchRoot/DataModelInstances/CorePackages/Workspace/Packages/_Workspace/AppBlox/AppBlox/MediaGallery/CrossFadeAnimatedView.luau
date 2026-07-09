local Parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local useStyle = require(Parent.UIBlox).Core.Style.useStyle

require(script.Parent.MediaGalleryTypes)

local t1 = {
	zIndex = 1,
	overlayTransparency = 0.5,
	animationConfig = {
		dampingRatio = 1,
		frequency = 6.666666666666667
	}
}

local function CrossFadeAnimatedView(t2: {[any]: any}) -- line: 52
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), ReactOtter (copy)
	local v9 = Cryo.Dictionary.join(t1, t2)
	local v10 = #v9.items
	local v11 = useStyle()
	local v12 = React.useCallback(function() -- line: 58
		-- upvalues: v9 (copy)
		if v9.crossAnim.isCrossFade then
			v9.crossAnim.setCrossFade(false)
			v9.crossAnim.setCurrentIndex(v9.crossAnim.nextIndex)
		end
	end, {
		v9.crossAnim.isCrossFade,
		v9.crossAnim.nextIndex,
		v9.crossAnim.setCrossFade,
		v9.crossAnim.setCurrentIndex
	})
	local v13, v14 = ReactOtter.useAnimatedBinding(0, v12)

	React.useEffect(function() -- line: 74
		-- upvalues: v10 (copy), v9 (copy), v14 (copy), ReactOtter (copy)
		if v10 < 2 then
			return
		end

		if v9.crossAnim.isCrossFade then
			v14(ReactOtter.spring(1, v9.animationConfig))

			return
		end

		v14((ReactOtter.instant(0)))
	end, {
		v9.crossAnim.isCrossFade,
		v9.crossAnim.nextIndex,
		v9.animationConfig
	})

	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = v9.zIndex,
		Image = v9.items[v9.crossAnim.currentIndex].imageId,
		ScaleType = Enum.ScaleType.Crop,
		ImageTransparency = v13
	}, {
		NextImage = if not (v10 >= 2) then nil else React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromScale(1, 1),
			Image = v9.items[v9.crossAnim.nextIndex].imageId,
			ScaleType = Enum.ScaleType.Crop,
			ImageTransparency = v13:map(function(p1) -- line: 107
				return 1 - p1
			end)
		}),
		Overlay = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = v9.overlayTransparency,
			BackgroundColor3 = v11.Theme.Overlay.Color
		})
	})
end

return CrossFadeAnimatedView
