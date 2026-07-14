local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local VideoFrameWrapper = require(VideoUtils.VideoFrameWrapper)
local ArgCheck = require(VideoUtilsParent.ArgCheck)
local LoadableImage = require(VideoUtilsParent.UIBlox).App.Loading.LoadableImage
local React = require(VideoUtilsParent.React)
local Foundation = require(VideoUtilsParent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local FFlagLuaAppEdpMediaGalleryAutoAdvance = require(VideoUtilsParent.SharedFlags).FFlagLuaAppEdpMediaGalleryAutoAdvance
local FFlagLuaAppEdpMediaGalleryFullScreen = require(VideoUtilsParent.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FFlagLuaAppEdpConsoleMediaGalleryVideo = require(VideoUtilsParent.SharedFlags).FFlagLuaAppEdpConsoleMediaGalleryVideo
local FFlagLuaAppEnableHomepageOneByTwoTile = require(VideoUtilsParent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile
local FFlagLuaAppHomePageFirstImageLoadObserver = require(VideoUtilsParent.SharedFlags).FFlagLuaAppHomePageFirstImageLoadObserver

local function LoadableVideoFrame(t1: {[any]: any}, p1) -- line: 38
	-- upvalues: React (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppEdpConsoleMediaGalleryVideo (copy), FFlagLuaAppEnableHomepageOneByTwoTile (copy), ArgCheck (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), VideoFrameWrapper (copy), LoadableImage (copy), Skeleton (copy), EnumsRadius (copy)
	local v18, v19 = React.useState(false)
	local v20 = if not FFlagLuaAppEdpMediaGalleryAutoAdvance and (not FFlagLuaAppEdpMediaGalleryFullScreen and (not FFlagLuaAppEdpConsoleMediaGalleryVideo and not FFlagLuaAppEnableHomepageOneByTwoTile)) then React.useRef(nil) else nil
	local v21 = React.useRef(nil)

	if t1.shouldStartPlayback and v21.current == nil then
		v21.current = tick()
	elseif not t1.shouldStartPlayback then
		v21.current = nil
	end

	local v22 = t1.thumbnail ~= nil and t1.thumbnail ~= ""
	local v23 = React.useCallback(function() -- line: 59
		-- upvalues: FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), FFlagLuaAppEdpConsoleMediaGalleryVideo (copy), FFlagLuaAppEnableHomepageOneByTwoTile (copy), p1 (copy), v20 (copy), ArgCheck (copy), v21 (copy), t1 (copy), v19 (copy)
		local current = nil

		if FFlagLuaAppEdpMediaGalleryAutoAdvance or (FFlagLuaAppEdpMediaGalleryFullScreen or FFlagLuaAppEdpConsoleMediaGalleryVideo or FFlagLuaAppEnableHomepageOneByTwoTile) then
			if typeof(p1) == "table" then
				current = p1.current
			else
				warn(`unsupported ref type: { typeof(p1) }`)
			end
		else
			current = v20.current
		end

		if current ~= nil then
			local timestamp = tick()

			ArgCheck.assert(v21.current and timestamp >= v21.current)

			local v28 = (not v21.current or not (timestamp >= v21.current)) and -1 or timestamp - v21.current

			if t1.onVideoLoaded then
				t1.onVideoLoaded(current.TimeLength, v28)
			end

			v19(true)
		end
	end, {
		t1.onVideoLoaded,
		if not FFlagLuaAppEdpMediaGalleryAutoAdvance and (not FFlagLuaAppEdpMediaGalleryFullScreen and (not FFlagLuaAppEdpConsoleMediaGalleryVideo and not FFlagLuaAppEnableHomepageOneByTwoTile)) then v20 else p1,
		v21
	})
	local v24 = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else React.useCallback(function() -- line: 104
		-- upvalues: t1 (copy)
		if t1.onVideoEnded then
			t1.onVideoEnded()
		end
	end, { t1.onVideoEnded })
	local v25 = React.useCallback(function() -- line: 111
		-- upvalues: t1 (copy)
		if t1.onVideoLooped then
			t1.onVideoLooped()
		end
	end, { t1.onVideoLooped })

	return React.createElement("Frame", {
		[React.Tag] = if not FFlagLuaAppHomePageFirstImageLoadObserver then nil else "observed-image",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true
	}, {
		VideoFrame = React.createElement(VideoFrameWrapper, {
			zIndex = 4,
			videoFrameRef = if not FFlagLuaAppEdpMediaGalleryAutoAdvance and (not FFlagLuaAppEdpMediaGalleryFullScreen and (not FFlagLuaAppEdpConsoleMediaGalleryVideo and not FFlagLuaAppEnableHomepageOneByTwoTile)) then v20 else p1,
			video = t1.video,
			isPlaying = t1.shouldStartPlayback,
			looped = t1.looped,
			volume = if not t1.muted then nil else 0,
			onLoaded = v23,
			onLooped = v25,
			onEnded = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else v24,
			cornerRadius = t1.cornerRadius
		}),
		VideoThumbnail = if not v22 then nil else React.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 2,
			Image = t1.thumbnail,
			Size = UDim2.new(1, 0, 1, t1.ScaleType ~= Enum.ScaleType.Tile and 0 or t1.cornerRadius),
			cornerRadius = UDim.new(0, t1.cornerRadius),
			ScaleType = t1.ScaleType,
			TileSize = if t1.ScaleType ~= Enum.ScaleType.Tile or not t1.cornerRadius then nil else UDim2.new(1, 0, 1, -t1.cornerRadius)
		}),
		Skeleton = if not t1.shouldStartPlayback or v18 then nil else React.createElement(Skeleton, {
			ZIndex = 3,
			Size = UDim2.fromScale(1, 1),
			radius = if not t1.cornerRadius then nil else EnumsRadius.Medium
		})
	})
end

if FFlagLuaAppEdpMediaGalleryAutoAdvance or (FFlagLuaAppEdpMediaGalleryFullScreen or FFlagLuaAppEdpConsoleMediaGalleryVideo or FFlagLuaAppEnableHomepageOneByTwoTile) then
	return React.forwardRef(LoadableVideoFrame)
end

return LoadableVideoFrame
