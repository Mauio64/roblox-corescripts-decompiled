local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local CaptureType = require(ParentParent.Enums.CaptureType)
local CarouselOpened = require(ParentParent.Actions.CarouselOpened)
local EventNames = require(ParentParent.Analytics.EventNames)
local getContentFromObject = CapturesCommon.Utils.getContentFromObject
local getCropSize = CapturesCommon.Utils.getCropSize
local getFormatTime = require(ParentParent.Utils.getFormatTime)

require(ParentParent.Types)

local FoundationText = Foundation.Text
local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useAnalytics (copy), useDispatch (copy), React (copy), EventNames (copy), CarouselOpened (copy), getCropSize (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), getContentFromObject (copy), FFlagUseRbxstorageInGallery (copy), FoundationText (copy), getFormatTime (copy)
	local v19 = useAnalytics()
	local v20 = useDispatch()
	local v21, v22 = React.useState(Vector2.new(0, 0))
	local v23, v24 = React.useState(Vector2.new(0, 0))
	local v25, v26 = React.useState(UDim2.fromScale(1, 1))
	local v27 = React.useCallback(function() -- line: 38
		-- upvalues: v19 (copy), EventNames (copy), v20 (copy), CarouselOpened (copy), t1 (copy)
		v19.fireEvent(EventNames.CapturesCarouselOpened)
		v20(CarouselOpened(t1.captureIndex))
	end, {})
	local v28 = React.useCallback(function(p1) -- line: 43
		-- upvalues: v22 (copy)
		v22(p1.AbsoluteSize)
	end, {})
	local v29 = React.useCallback(function(p2) -- line: 47
		-- upvalues: v24 (copy)
		local Resolution = p2.Resolution

		v24(Resolution)
	end, {})

	React.useEffect(function() -- line: 52
		-- upvalues: v26 (copy), getCropSize (copy), v21 (copy), v23 (copy)
		v26(getCropSize(v21, v23))
	end, {
		v21,
		v23
	})

	return React.createElement("ImageButton", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Image = if not FFlagEnableCapturesGalleryRetrievalCoreScript then if t1.capture.type ~= CaptureType.Screenshot then if t1.capture.type ~= CaptureType.Video then nil else t1.capture.thumbnailKey else t1.capture.contentId else nil,
		ImageContent = if not FFlagEnableCapturesGalleryRetrievalCoreScript then nil else getContentFromObject(t1.capture),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		[React.Change.AbsoluteSize] = if FFlagUseRbxstorageInGallery then nil else v28,
		[React.Event.Activated] = v27
	}, {
		TimeLength = if not FFlagEnableCapturesGalleryRetrievalCoreScript or t1.capture.CaptureType ~= Enum.CaptureType.Video then if not FFlagEnableCapturesGalleryRetrievalCoreScript or t1.capture.CaptureType ~= Enum.CaptureType.Screenshot then if not FFlagUseRbxstorageInGallery or t1.capture.type ~= CaptureType.Video then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "text-title-large content-emphasis auto-xy size-full text-align-x-right text-align-y-bottom padding-x-small padding-y-xsmall",
			Text = getFormatTime(t1.capture.videoCapture.TimeLength)
		}) else nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "text-title-large content-emphasis auto-xy size-full text-align-x-right text-align-y-bottom padding-x-small padding-y-xsmall",
			Text = getFormatTime(t1.capture.TimeLength)
		}),
		VideoPreview = if FFlagUseRbxstorageInGallery or t1.capture.type ~= CaptureType.Video then nil else React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Playing = false,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = v25,
			Video = t1.capture.contentId,
			[React.Event.Loaded] = v29
		})
	})
end
