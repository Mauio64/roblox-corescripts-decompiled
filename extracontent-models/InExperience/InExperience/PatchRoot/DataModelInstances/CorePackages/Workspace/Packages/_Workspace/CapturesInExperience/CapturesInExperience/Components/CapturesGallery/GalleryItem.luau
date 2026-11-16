local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CapturesCommon = require(parent2.CapturesCommon)
local Foundation = require(parent2.Foundation)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local CaptureType = require(parent.Enums.CaptureType)
local CarouselOpened = require(parent.Actions.CarouselOpened)
local EventNames = require(parent.Analytics.EventNames)
local getContentFromObject = CapturesCommon.Utils.getContentFromObject
local getCropSize = CapturesCommon.Utils.getCropSize
local getFormatTime = require(parent.Utils.getFormatTime)
require(parent.Types)

local Text = Foundation.Text

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(p)
	local v = useAnalytics()
	local v2 = useDispatch()

	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local state3, setState3 = React.useState(UDim2.fromScale(1, 1))

	local v3 = React.useCallback(function()
		v.fireEvent(EventNames.CapturesCarouselOpened)
		v2(CarouselOpened(p.captureIndex))
	end, {})

	local v4 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, {})

	local v5 = React.useCallback(function(p2)
		setState2(p2.Resolution)
	end, {})

	React.useEffect(function()
		setState3(getCropSize(state, state2))
	end, { state, state2 })

	local createElement = React.createElement
	local image

	if not FFlagEnableCapturesGalleryRetrievalCoreScript then
		if p.capture.type == CaptureType.Screenshot then
			image = p.capture.contentId
		elseif p.capture.type == CaptureType.Video then
			image = p.capture.thumbnailKey
		end
	end

	local imageContent

	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		imageContent = getContentFromObject(p.capture)
	end

	local v6 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		["Image"] = image,
		ImageContent = imageContent,
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1)
	}
	local absoluteSize = React.Change.AbsoluteSize

	if FFlagUseRbxstorageInGallery then
		v4 = nil
	end

	v6[absoluteSize] = v4
	v6[React.Event.Activated] = v3
	local timeLength

	if FFlagEnableCapturesGalleryRetrievalCoreScript and p.capture.CaptureType == Enum.CaptureType.Video then
		timeLength = React.createElement(Text, {
			LayoutOrder = 2,
			Text = getFormatTime(p.capture.TimeLength),
			tag = "text-title-large content-emphasis auto-xy size-full text-align-x-right text-align-y-bottom padding-x-small padding-y-xsmall"
		})
	elseif not (FFlagEnableCapturesGalleryRetrievalCoreScript and p.capture.CaptureType == Enum.CaptureType.Screenshot or not FFlagUseRbxstorageInGallery or p.capture.type ~= CaptureType.Video) then
		timeLength = React.createElement(Text, {
			LayoutOrder = 2,
			Text = getFormatTime(p.capture.videoCapture.TimeLength),
			tag = "text-title-large content-emphasis auto-xy size-full text-align-x-right text-align-y-bottom padding-x-small padding-y-xsmall"
		})
	end

	local videoPreview

	if not (FFlagUseRbxstorageInGallery or p.capture.type ~= CaptureType.Video) then
		videoPreview = React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Playing = false,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = state3,
			Video = p.capture.contentId,
			[React.Event.Loaded] = v5
		})
	end

	return createElement("ImageButton", v6, { TimeLength = timeLength, VideoPreview = videoPreview })
end
