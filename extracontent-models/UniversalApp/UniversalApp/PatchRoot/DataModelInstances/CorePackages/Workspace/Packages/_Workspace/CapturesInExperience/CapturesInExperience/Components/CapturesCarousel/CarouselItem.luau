local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local AppCommonLib = require(ParentParentParent.AppCommonLib)
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local React = require(ParentParentParent.React)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local memoize = AppCommonLib.memoize
local useScreenSize = RobloxAppHooks.useScreenSize
local useStyle = UIBlox.Core.Style.useStyle
local CaptureType = require(ParentParent.Enums.CaptureType)
local getContentFromObject = CapturesCommon.Utils.getContentFromObject
local getCaptureSize = require(ParentParent.Utils.getCaptureSize)
local MediaPlayer = CapturesCommon.Components.MediaPlayer

require(ParentParent.Types)

local FFlagUseMediaPlayerInCarousel = require(ParentParentParent.SharedFlags).FFlagUseMediaPlayerInCarousel
local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local v19 = memoize(function(vector2: Vector2, vector2_2: Vector2) -- line: 33
	local v26 = vector2.X / vector2.Y
	local vector2_2X = vector2_2.X
	local v28 = math.floor(vector2_2X / v26)

	if v28 > vector2_2.Y then
		v28 = vector2_2.Y
		vector2_2X = math.floor(v28 * v26)
	end

	return Vector2.new(vector2_2X, v28)
end)

local function getDeleteTransitionSize(p1) -- line: 47
	return UDim2.fromScale(p1, p1)
end
local function getDeleteTransitionTransparency(p2) -- line: 51
	-- upvalues: UserGameSettings (copy)
	if UserGameSettings.ReducedMotion then
		return p2
	end

	return 1
end
local function getCapturesItemSize(p3) -- line: 55
	-- upvalues: UserGameSettings (copy)
	if UserGameSettings.ReducedMotion then
		return (UDim2.fromScale(1, 1))
	end

	return (UDim2.fromScale(p3, p3))
end
local function getFullScreenSize(p4, p5) -- line: 59
	local v34 = p4.X / p4.Y
	local v35 = p5.X / v34

	if v35 <= p5.Y then
		return UDim2.fromOffset(p5.X, v35)
	end

	local v36 = p5.Y * v34

	return UDim2.fromOffset(v36, p5.Y)
end

return function(t1: {[any]: any}) -- line: 85
	-- upvalues: useStyle (copy), React (copy), useScreenSize (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), getCaptureSize (copy), v19 (copy), UserGameSettings (copy), getContentFromObject (copy), getCapturesItemSize (copy), FFlagUseMediaPlayerInCarousel (copy), MediaPlayer (copy), FFlagUseRbxstorageInGallery (copy), getDeleteTransitionTransparency (copy)
	local v38 = useStyle()
	local itemSize = t1.itemSize
	local v40, v41 = React.useBinding(0)
	local v42, v43 = React.useState(Vector2.new(0, 0))
	local v44 = useScreenSize()
	local v45 = React.useRef(nil)
	local v46 = React.useRef(nil)
	local v47, v48 = React.useState(false)
	local imagePadding = t1.imagePadding
	local itemIndex = t1.itemIndex
	local v51 = React.useCallback(function(p6) -- line: 99
		-- upvalues: v41 (copy)
		v41(p6.AbsolutePosition.X)
	end, { v41 })

	React.useEffect(function() -- line: 103
		-- upvalues: v46 (copy)
		return function() -- line: 104
			-- upvalues: v46 (copy)
			if v46.current then
				v46.current.Video = ""
			end
		end
	end, {})
	React.useEffect(function() -- line: 111
		-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), t1 (copy), v43 (copy), itemSize (copy), CaptureType (copy), getCaptureSize (copy)
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			if t1.capture.CaptureType == Enum.CaptureType.Screenshot then
				v43(itemSize)
			end

			return
		end

		if t1.capture.type == CaptureType.Video then
			return
		end

		task.spawn(function() -- line: 123
			-- upvalues: getCaptureSize (copy), t1 (copy), v43 (copy), itemSize (copy)
			local v110 = getCaptureSize(t1.capture.contentId)

			if v110 then
				v43(v110)

				return
			end

			v43(itemSize)
		end)
	end, {
		itemSize,
		t1.capture
	})

	local v52 = React.useCallback(function(p7) -- line: 134
		-- upvalues: v46 (copy), v43 (copy)
		v46.current = p7

		local Resolution = p7.Resolution

		v43(Vector2.new(Resolution.X, Resolution.Y))
	end, {})
	local v53 = React.useCallback(function(n1: number) -- line: 140
		-- upvalues: itemSize (copy), v44 (copy)
		local v79 = itemSize.X / 2
		local v80 = v44.X / 2
		local v81 = n1 + v79
		local v82 = math.abs(v80 - v81)
		local v83 = if not (v82 < 25) then v82 - 25 else 0

		return math.sign(v80 - v81), (math.min(1, v83 / (itemSize.X - 25)))
	end, {
		itemSize,
		itemIndex,
		v44
	})
	local v54 = React.useCallback(function(n2: number) -- line: 158
		-- upvalues: v53 (copy), v19 (copy), v42 (copy), itemSize (copy), t1 (copy)
		local _, v86 = v53(n2)
		local v87 = v19(v42, itemSize)

		if v86 == 0 then
			return UDim2.fromOffset(v87.X, v87.Y)
		end

		local v88 = 1 - v86 * (1 - t1.unfocusedSizeMultiplier)
		local v89 = v87.Y * v88
		local v90 = v87.X * v88
		local v91 = math.floor(v89)
		local v92 = math.floor(v90)

		return UDim2.fromOffset(v92, v91)
	end, {
		v42,
		itemSize,
		t1.unfocusedSizeMultiplier,
		v53
	})
	local v55 = React.useCallback(function(n3: number) -- line: 177
		-- upvalues: v53 (copy), v54 (copy), itemSize (copy), imagePadding (copy)
		local v94, v95 = v53(n3)

		if v95 == 0 then
			return UDim2.fromScale(0.5, 0.5)
		end

		local XOffset = v54(n3).X.Offset
		local v97 = (itemSize.X / 2 - imagePadding - XOffset / 2) * v95

		return UDim2.new(0.5, v97 * v94, 0.5, 0)
	end, {
		v42,
		imagePadding,
		itemSize,
		v44,
		v53,
		v54
	})
	local OverlayTransparency = v38.Theme.Overlay.Transparency
	local v57 = React.useCallback(function(n4: number) -- line: 198
		-- upvalues: v53 (copy), OverlayTransparency (copy)
		local _, v100 = v53(n4)

		return 1 - (1 - OverlayTransparency) * v100
	end, {
		OverlayTransparency,
		v53
	})
	local v58 = React.useCallback(function(p8) -- line: 203
		-- upvalues: UserGameSettings (copy), v57 (copy)
		local absoluteXPosition = p8.absoluteXPosition
		local fadeOutBinding = p8.fadeOutBinding

		if UserGameSettings.ReducedMotion and fadeOutBinding then
			return 1
		end

		if fadeOutBinding then
			return (math.min(v57(absoluteXPosition), fadeOutBinding))
		end

		return v57(absoluteXPosition)
	end, { v57 })
	local v59 = React.useCallback(function() -- line: 217
		-- upvalues: t1 (copy), v48 (copy), v47 (copy)
		if t1.onExpandCallback then
			t1.onExpandCallback(t1.itemIndex)
		end

		v48(not v47)
	end, {
		v47,
		t1.onExpandCallback,
		t1.itemIndex
	})
	local v60 = React.useCallback(function() -- line: 224
		-- upvalues: t1 (copy)
		if t1.onMuteCallback then
			t1.onMuteCallback()
		end
	end, { t1.onMuteCallback })
	local v61 = React.useCallback(function() -- line: 230
		-- upvalues: React (copy)
		return (React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1)
		}))
	end, {})
	local v62 = if not FFlagEnableCapturesGalleryRetrievalCoreScript then t1.capture.type == CaptureType.Screenshot else t1.capture.CaptureType == Enum.CaptureType.Screenshot
	local v63 = if not FFlagEnableCapturesGalleryRetrievalCoreScript then t1.capture.type == CaptureType.Video else t1.capture.CaptureType == Enum.CaptureType.Video
	local v64 = if not FFlagEnableCapturesGalleryRetrievalCoreScript then t1.capture.contentId else getContentFromObject(t1.capture)
	local v65 = if not FFlagEnableCapturesGalleryRetrievalCoreScript then t1.capture.videoCapture else t1.capture
	local createElement = React.createElement
	local t2 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		[React.Change.AbsolutePosition] = v51
	}
	local t3 = {
		FullScreenOffset = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, not v47 and 0 or 16)
		})
	}
	local createElement2 = React.createElement
	local t4 = {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = if not v47 then v40:map(v55) else UDim2.fromScale(0.5, 0.5)
	}
	local uDim2

	if v47 then
		local v71 = v42.X / v42.Y
		local v72 = v44.X / v71

		if v72 <= v44.Y then
			uDim2 = UDim2.fromOffset(v44.X, v72)
		else
			local v74 = v44.Y * v71

			uDim2 = UDim2.fromOffset(v74, v44.Y)
		end
	else
		uDim2 = v40:map(v54)
	end

	t4.Size = uDim2
	t3.CaptureContainer = createElement2("Frame", t4, {
		CaptureImage = if not v62 then nil else React.createElement("ImageLabel", {
			BorderSizePixel = 0,
			ZIndex = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v38.Theme.BackgroundContrast.Color,
			BackgroundTransparency = not FFlagEnableCapturesGalleryRetrievalCoreScript and 1 or 0,
			Image = if not FFlagEnableCapturesGalleryRetrievalCoreScript then v64 else nil,
			ImageContent = if not FFlagEnableCapturesGalleryRetrievalCoreScript then nil else v64,
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = if not FFlagEnableCapturesGalleryRetrievalCoreScript then Enum.ScaleType.Crop else Enum.ScaleType.Fit,
			Size = if not t1.fadeOutBinding then UDim2.fromScale(1, 1) else t1.fadeOutBinding:map(getCapturesItemSize),
			Visible = v42 ~= Vector2.new(0, 0)
		}),
		CaptureVideo = if not v63 then nil else if not FFlagUseMediaPlayerInCarousel then React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Playing = v40:map(function(p9) -- line: 321
				-- upvalues: v53 (copy)
				local _, v109 = v53(p9)

				return v109 < 0.5
			end),
			Position = UDim2.fromScale(0.5, 0.5),
			Looped = true,
			Size = if not t1.fadeOutBinding then UDim2.fromScale(1, 1) else t1.fadeOutBinding:map(getCapturesItemSize),
			Video = if FFlagUseRbxstorageInGallery then nil else t1.capture.contentId,
			VideoContent = if not FFlagUseRbxstorageInGallery then nil else getContentFromObject(t1.capture.videoCapture),
			Volume = 0,
			ZIndex = 1,
			[React.Event.Loaded] = v52
		}) else React.createElement(MediaPlayer, {
			BorderSizePixel = 0,
			Looped = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v38.Theme.BackgroundContrast.Color,
			BackgroundTransparency = not FFlagEnableCapturesGalleryRetrievalCoreScript and 1 or 0,
			isOverlayDisabled = not t1.isSelected or t1.isDisabled,
			isTimeHidden = v44.X > v44.Y and (v42.Y > v42.X and not v47),
			onExpandCallback = v59,
			onMuteCallback = v60,
			onLoaded = v52,
			Playing = t1.isSelected and v40:map(function(p10) -- line: 305
				-- upvalues: v53 (copy)
				local _, v106 = v53(p10)

				return v106 < 0.5
			end),
			Position = UDim2.fromScale(0.5, 0.5),
			renderOnFailed = v61,
			Size = if not t1.fadeOutBinding then UDim2.fromScale(1, 1) else t1.fadeOutBinding:map(getCapturesItemSize),
			VideoContent = getContentFromObject(v65),
			videoRef = v45,
			ZIndex = not v47 and 1 or 5
		}),
		Overlay = React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v38.Theme.Overlay.Color,
			BackgroundTransparency = React.joinBindings({
				absoluteXPosition = v40,
				fadeOutBinding = t1.fadeOutBinding
			}):map(v58),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = if not t1.fadeOutBinding then UDim2.fromScale(1, 1) else t1.fadeOutBinding:map(getCapturesItemSize)
		}),
		TransitionOverlay = React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 3,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v38.Theme.BackgroundContrast.Color,
			BackgroundTransparency = not t1.transitionBinding and 1 or t1.transitionBinding:map(getDeleteTransitionTransparency),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1)
		}),
		FullScreenBackground = if not FFlagUseMediaPlayerInCarousel or not v47 then nil else React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ZIndex = 4,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = v38.Theme.BackgroundContrast.Color,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(v44.X, v44.Y)
		})
	})

	return createElement("Frame", t2, t3)
end
