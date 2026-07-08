local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Foundation = require(ProfilePlatformParent.Foundation)
local React = require(ProfilePlatformParent.React)
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local FoundationImage = Foundation.Image
local View = Foundation.View
local LoadableVideo = require(ProfilePlatform.Components.Videos.LoadableVideo)
local TimeDurationOverlay = require(ProfilePlatform.Components.Videos.TimeDurationOverlay)

local function MediaPlayer(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), View (copy), StateLayerAffordance (copy), LoadableVideo (copy), FoundationImage (copy), TimeDurationOverlay (copy)
	local v12 = React.useCallback(function() -- line: 34
		-- upvalues: t1 (copy)
		if t1.onExpandCallback then
			t1.onExpandCallback()
		end
	end, { t1.onExpandCallback })
	local v13 = React.useMemo(function() -- line: 40
		-- upvalues: t1 (copy)
		return t1.Video or not t1.thumbnailImage
	end, {
		t1.Video,
		t1.thumbnailImage
	})

	return React.createElement(View, {
		tag = "shrink size-full",
		onActivated = v12,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		ZIndex = t1.ZIndex
	}, {
		VideoPreview = if not v13 then nil else React.createElement(LoadableVideo, {
			cornerRadius = t1.cornerRadius,
			Looped = t1.Looped,
			onLoaded = t1.onVideoLoaded,
			Playing = t1.Playing,
			Position = t1.Position,
			renderOnFailed = t1.renderOnFailed,
			scaleType = t1.scaleType,
			Size = t1.Size,
			Video = t1.Video,
			videoRef = t1.videoRef
		}),
		ThumbnailImage = if not t1.thumbnailImage or t1.Playing then nil else React.createElement(FoundationImage, {
			ZIndex = 2,
			cornerRadius = if not t1.cornerRadius then nil else UDim.new(0, t1.cornerRadius),
			Image = t1.thumbnailImage,
			Size = UDim2.fromScale(1, 1)
		}),
		TimeDurationOverlay = if t1.Playing or (t1.isFullScreen or (not t1.timeLength or not (t1.timeLength > 0))) then nil else React.createElement(TimeDurationOverlay, {
			timeLength = t1.timeLength
		})
	})
end

return MediaPlayer
