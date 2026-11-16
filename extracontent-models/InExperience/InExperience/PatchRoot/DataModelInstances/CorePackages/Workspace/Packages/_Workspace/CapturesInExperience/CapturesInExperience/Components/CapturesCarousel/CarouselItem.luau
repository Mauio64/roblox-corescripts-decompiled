local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local AppCommonLib = require(parent2.AppCommonLib)
local CapturesCommon = require(parent2.CapturesCommon)
local React = require(parent2.React)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local memoize = AppCommonLib.memoize

local useScreenSize = RobloxAppHooks.useScreenSize
local useStyle = UIBlox.Core.Style.useStyle

local CaptureType = require(parent.Enums.CaptureType)
local getContentFromObject = CapturesCommon.Utils.getContentFromObject
local getCaptureSize = require(parent.Utils.getCaptureSize)
local MediaPlayer = CapturesCommon.Components.MediaPlayer
require(parent.Types)

local SharedFlags = require(parent2.SharedFlags)
local FFlagUseMediaPlayerInCarousel = SharedFlags.FFlagUseMediaPlayerInCarousel
local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local v = memoize(function(vector2: Vector2, vector2_2: Vector2)
	local v = vector2.X / vector2.Y

	local v2 = vector2_2.X
	local v3 = math.floor(v2 / v)

	if vector2_2.Y < v3 then
		v3 = vector2_2.Y
		v2 = math.floor(v3 * v)
	end

	return Vector2.new(v2, v3)
end)

local function getDeleteTransitionSize(p) -- 1 equivalent call inferred from this helper
	return UDim2.fromScale(p, p)
end

local function getDeleteTransitionTransparency(p)
	return if UserGameSettings.ReducedMotion then p else 1
end

local function getCapturesItemSize(p)
	if UserGameSettings.ReducedMotion then
		return (UDim2.fromScale(1, 1))
	end

	return (getDeleteTransitionSize(p)) -- inferred equivalent call
end

local function getFullScreenSize(state, p) -- 1 equivalent call inferred from this helper
	local v2 = state.X / state.Y

	local v3 = p.X / v2

	if v3 <= p.Y then
		return UDim2.fromOffset(p.X, v3)
	end

	local v4 = p.Y * v2
	return UDim2.fromOffset(v4, p.Y)
end

return function(props)
	local v2 = useStyle()

	local itemSize = props.itemSize
	local absoluteXPosition2, v3 = React.useBinding(0)
	local state, setState = React.useState(Vector2.new(0, 0))
	local v4 = useScreenSize()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local state2, setState2 = React.useState(false)

	local imagePadding = props.imagePadding
	local itemIndex = props.itemIndex

	local v5 = React.useCallback(function(p)
		v3(p.AbsolutePosition.X)
	end, { v3 })

	React.useEffect(function()
		return function()
			if ref2.current then
				ref2.current.Video = ""
			end
		end
	end, {})

	React.useEffect(function()
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			if props.capture.CaptureType == Enum.CaptureType.Screenshot then
				setState(itemSize)
			end
		else
			if props.capture.type == CaptureType.Video then
				return
			end

			task.spawn(function()
				local captureSize = getCaptureSize(props.capture.contentId)

				if captureSize then
					setState(captureSize)
				else
					setState(itemSize)
				end
			end)
		end
	end, { itemSize, props.capture })

	local onLoaded = React.useCallback(function(current)
		ref2.current = current
		local resolution = current.Resolution
		setState(Vector2.new(resolution.X, resolution.Y))
	end, {})

	local v6 = React.useCallback(function(p: number)
		local v6 = itemSize.X / 2
		local v7 = v4.X / 2
		local v8 = p + v6

		local v9 = math.abs(v7 - v8)
		local v10 = v9 < 25 and 0 or v9 - 25

		return math.sign(v7 - v8), (math.min(1, v10 / (itemSize.X - 25)))
	end, { itemSize, itemIndex, v4 })

	local v7 = React.useCallback(function(p: number)
		local _, v7 = v6(p)
		local v8 = v(state, itemSize)

		if v7 == 0 then
			return UDim2.fromOffset(v8.X, v8.Y)
		end

		local v9 = 1 - v7 * (1 - props.unfocusedSizeMultiplier)

		local v10 = v8.Y * v9
		local v11 = v8.X * v9

		local v12 = math.floor(v10)
		local v13 = math.floor(v11)

		return UDim2.fromOffset(v13, v12)
	end, { state, itemSize, props.unfocusedSizeMultiplier, v6 })

	local v8 = React.useCallback(function(p: number)
		local v8, v9 = v6(p)

		if v9 == 0 then
			return UDim2.fromScale(0.5, 0.5)
		end

		local offset = v7(p).X.Offset
		local v10 = (itemSize.X / 2 - imagePadding - offset / 2) * v9

		return UDim2.new(0.5, v10 * v8, 0.5, 0)
	end, { state, imagePadding, itemSize, v4, v6, v7 })

	local transparency = v2.Theme.Overlay.Transparency

	local v9 = React.useCallback(function(p: number)
		local _, v9 = v6(p)
		return 1 - (1 - transparency) * v9
	end, { transparency, v6 })

	local v10 = React.useCallback(function(p)
		local absoluteXPosition = p.absoluteXPosition
		local fadeOutBinding = p.fadeOutBinding

		if UserGameSettings.ReducedMotion and fadeOutBinding then
			return 1
		end

		if fadeOutBinding then
			return (math.min(v9(absoluteXPosition), fadeOutBinding))
		end

		return v9(absoluteXPosition)
	end, { v9 })

	local onExpandCallback = React.useCallback(function()
		if props.onExpandCallback then
			props.onExpandCallback(props.itemIndex)
		end

		setState2(not state2)
	end, { state2, props.onExpandCallback, props.itemIndex })

	local onMuteCallback = React.useCallback(function()
		if props.onMuteCallback then
			props.onMuteCallback()
		end
	end, { props.onMuteCallback })

	local renderOnFailed = React.useCallback(function()
		return (React.createElement("Frame", { Size = UDim2.fromScale(1, 1) }))
	end, {})
	local v11

	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		v11 = props.capture.CaptureType == Enum.CaptureType.Screenshot
	else
		v11 = props.capture.type == CaptureType.Screenshot
	end

	local v12

	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		v12 = props.capture.CaptureType == Enum.CaptureType.Video
	else
		v12 = props.capture.type == CaptureType.Video
	end

	local imageContent

	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		imageContent = getContentFromObject(props.capture)
	else
		imageContent = props.capture.contentId
	end

	local v13

	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		v13 = props.capture
	else
		v13 = props.capture.videoCapture
	end

	local createElement = React.createElement
	local v14 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		[React.Change.AbsolutePosition] = v5
	}
	local v15 = {
		FullScreenOffset = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, state2 and 16 or 0)
		}),
		CaptureContainer = 0
	}

	local createElement2 = React.createElement
	local v16 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = 0,
		Size = 0
	}
	local position

	if state2 then
		position = UDim2.fromScale(0.5, 0.5)
	else
		position = absoluteXPosition2:map(v8)
	end

	v16.Position = position
	local size

	if state2 then
		size = getFullScreenSize(state, v4) -- inferred equivalent call
	else
		size = absoluteXPosition2:map(v7)
	end

	v16.Size = size
	local captureImage

	if v11 then
		local createElement3 = React.createElement
		local v17 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v2.Theme.BackgroundContrast.Color,
			BackgroundTransparency = FFlagEnableCapturesGalleryRetrievalCoreScript and 0 or 1,
			BorderSizePixel = 0,
			Image = 0,
			ImageContent = 0,
			Position = 0,
			ScaleType = 0,
			Size = 0,
			Visible = 0,
			ZIndex = 1
		}
		local image

		if not FFlagEnableCapturesGalleryRetrievalCoreScript then
			image = imageContent
		end

		v17.Image = image

		if not FFlagEnableCapturesGalleryRetrievalCoreScript then
			imageContent = nil
		end

		v17.ImageContent = imageContent
		v17.Position = UDim2.fromScale(0.5, 0.5)
		local scaleType

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			scaleType = Enum.ScaleType.Fit
		else
			scaleType = Enum.ScaleType.Crop
		end

		v17.ScaleType = scaleType
		local size2

		if props.fadeOutBinding then
			size2 = props.fadeOutBinding:map(getCapturesItemSize)
		else
			size2 = UDim2.fromScale(1, 1)
		end

		v17.Size = size2

		v17.Visible = state ~= Vector2.new(0, 0)
		captureImage = createElement3("ImageLabel", v17)
	end

	local captureVideo

	if v12 then
		if FFlagUseMediaPlayerInCarousel then
			local createElement3 = React.createElement
			local v17 = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = v2.Theme.BackgroundContrast.Color,
				BackgroundTransparency = FFlagEnableCapturesGalleryRetrievalCoreScript and 0 or 1,
				BorderSizePixel = 0,
				isOverlayDisabled = not props.isSelected or props.isDisabled,
				isTimeHidden = v4.X > v4.Y and state.Y > state.X and not state2,
				Looped = true,
				onExpandCallback = onExpandCallback,
				onMuteCallback = onMuteCallback,
				onLoaded = onLoaded,
				Playing = props.isSelected and absoluteXPosition2:map(function(p): boolean
					local _, v17 = v6(p)
					return v17 < 0.5
				end),
				Position = UDim2.fromScale(0.5, 0.5),
				renderOnFailed = renderOnFailed,
				Size = 0,
				VideoContent = 0,
				videoRef = 0,
				ZIndex = 0
			}
			local size2

			if props.fadeOutBinding then
				size2 = props.fadeOutBinding:map(getCapturesItemSize)
			else
				size2 = UDim2.fromScale(1, 1)
			end

			v17.Size = size2

			v17.VideoContent = getContentFromObject(v13)
			v17.videoRef = ref
			v17.ZIndex = state2 and 5 or 1
			captureVideo = createElement3(MediaPlayer, v17)
		else
			local createElement3 = React.createElement
			local v17 = {}
			v17.AnchorPoint = Vector2.new(0.5, 0.5)
			v17.BackgroundTransparency = 1
			v17.Playing = absoluteXPosition2:map(function(p): boolean
				local _, v18 = v6(p)
				return v18 < 0.5
			end)

			v17.Position = UDim2.fromScale(0.5, 0.5)
			v17.Looped = true
			local size2

			if props.fadeOutBinding then
				size2 = props.fadeOutBinding:map(getCapturesItemSize)
			else
				size2 = UDim2.fromScale(1, 1)
			end

			v17.Size = size2
			local video

			if not FFlagUseRbxstorageInGallery then
				video = props.capture.contentId
			end

			v17.Video = video
			local videoContent

			if FFlagUseRbxstorageInGallery then
				videoContent = getContentFromObject(props.capture.videoCapture)
			end

			v17.VideoContent = videoContent

			v17.Volume = 0
			v17.ZIndex = 1
			v17[React.Event.Loaded] = onLoaded
			captureVideo = createElement3("VideoFrame", v17)
		end
	end

	local createElement3 = React.createElement
	local v17 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = v2.Theme.Overlay.Color,
		BackgroundTransparency = React.joinBindings({
			absoluteXPosition = absoluteXPosition2,
			fadeOutBinding = props.fadeOutBinding
		}):map(v10),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = 0,
		ZIndex = 2
	}
	local size2

	if props.fadeOutBinding then
		size2 = props.fadeOutBinding:map(getCapturesItemSize)
	else
		size2 = UDim2.fromScale(1, 1)
	end

	v17.Size = size2
	local children = {
		CaptureImage = captureImage,
		CaptureVideo = captureVideo,
		Overlay = createElement3("Frame", v17),
		TransitionOverlay = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v2.Theme.BackgroundContrast.Color,
			BackgroundTransparency = not props.transitionBinding and 1 or props.transitionBinding:map(getDeleteTransitionTransparency),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			ZIndex = 3
		}),
		FullScreenBackground = 0
	}
	local fullScreenBackground

	if FFlagUseMediaPlayerInCarousel and state2 then
		fullScreenBackground = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v2.Theme.BackgroundContrast.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(v4.X, v4.Y),
			ZIndex = 4
		})
	end

	children.FullScreenBackground = fullScreenBackground
	v15.CaptureContainer = createElement2("Frame", v16, children)
	return createElement("Frame", v14, v15)
end
