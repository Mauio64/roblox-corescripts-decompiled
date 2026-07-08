local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local useScreenSize = require(ProfilePlatformParent.RobloxAppHooks).useScreenSize
local View = Foundation.View
local LoadableImage = require(ProfilePlatformParent.UIBlox).App.Loading.LoadableImage
local Enums = require(ProfilePlatform.Common.Enums)

local function interpolateHeight(n1: number, n2: number, n3: number) -- line: 30
	return n1 + (n2 - n1) * n3
end
local function CoverPhoto(t1: {[any]: any}) -- line: 34
	-- upvalues: Enums (copy), useScreenSize (copy), React (copy), View (copy), LoadableImage (copy)
	local v15 = t1.profileFormFactorInfo.formFactor == Enums.ProfileFormFactor.Wide
	local v16 = t1.profileFormFactorInfo.formFactor == Enums.ProfileFormFactor.PeekView
	local isFullView = t1.profileFormFactorInfo.isFullView
	local v18 = useScreenSize()
	local v19 = React.useMemo(function() -- line: 40
		-- upvalues: v16 (copy)
		if v16 then
			return 393
		end

		return 456
	end, {
		v16,
		isFullView,
		t1.peekViewOpenPercent
	})
	local v20 = React.useMemo(function() -- line: 48
		-- upvalues: v16 (copy), isFullView (copy), t1 (copy), v19 (copy)
		if v16 and not isFullView then
			return t1.peekViewOpenPercent * 98 + 295
		end

		return v19
	end, {
		v16,
		isFullView,
		t1.peekViewOpenPercent,
		v19
	})
	local v21 = v20 - 100
	local v22 = v20 - t1.parallaxOffset
	local v23 = v21 - t1.parallaxOffset
	local v24 = if not isFullView then UDim.new(1, 0) else UDim.new(0, v18.X)

	return React.createElement(View, {
		ZIndex = -1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(v24, UDim.new(0, v21))
	}, {
		ParallaxWrapper = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, v23),
			Position = UDim2.new(0, 0, 0, t1.parallaxOffset)
		}, {
			CoverPhotoWrapper = React.createElement(View, {
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 0, v22)
			}, {
				CoverPhoto = React.createElement(LoadableImage, {
					BackgroundTransparency = 1,
					useShimmerAnimationWhileLoading = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = t1.coverPhotoThumbnail,
					Position = UDim2.fromScale(0.5, 0.5),
					ScaleType = Enum.ScaleType.Crop,
					Size = UDim2.new(1, 0, 0, v19)
				})
			}),
			GradientWrapper = React.createElement(View, {
				Size = UDim2.new(1, 0, 0, 100),
				Position = UDim2.new(0, 0, 0, v23),
				tag = not v15 and not isFullView and "bg-surface-100" or "bg-surface-0"
			}, {
				Gradient = React.createElement("UIGradient", {
					Rotation = 270,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.25, 0),
						NumberSequenceKeypoint.new(0.5, 0.1),
						NumberSequenceKeypoint.new(0.75, 0.5),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			})
		})
	})
end

return CoverPhoto
