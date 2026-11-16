local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local CapturesCommon = require(parent2.CapturesCommon)
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)
local Checkbox = Foundation.Checkbox

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local UIBlox = require(parent2.UIBlox)

local Images = UIBlox.App.ImageSet.Images
local Text = Foundation.Text

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local CaptureType = require(parent.Enums.CaptureType)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local getContentFromObject = CapturesCommon.Utils.getContentFromObject
local getCropSize = CapturesCommon.Utils.getCropSize
local getFormatTime = require(parent.Utils.getFormatTime)
local SelectCapture = require(parent.Thunks.SelectCapture)
require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(p)
	local v = useAnalytics()
	local v2 = useDispatch()
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local state3, setState3 = React.useState(UDim2.fromScale(1, 1))
	local state4, setState4 = React.useState(false)

	local v3 = useSelector(function(p2)
		return p2[Constants.RoduxKey].CaptureManager.SelectedCaptures
	end)

	local onActivated = React.useCallback(function()
		setState4(not state4)
		v.fireEvent(EventNames.CapturesManagerItemActivated)
		v2(SelectCapture(p.capture))
	end, { state4, p.capture })

	local v4 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, {})

	local v5 = React.useCallback(function(p2)
		setState2(p2.Resolution)
	end, {})

	React.useEffect(function()
		setState3(getCropSize(state, state2))
	end, { state, state2 })

	React.useEffect(function()
		setState4(Cryo.List.find(v3, p.capture) ~= nil)
	end, { v3, p.capture })

	local createElement = React.createElement
	local image

	if not FFlagEnableCapturesGalleryRetrievalCoreScript then
		if p.capture.type == CaptureType.Screenshot then
			image = p.capture.contentId
		elseif FFlagUseRbxstorageInGallery then
			image = p.capture.thumbnailKey
		end
	end

	local imageContent

	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		imageContent = getContentFromObject(p.capture)
	end

	local v6 = {
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Image = image,
		ImageContent = imageContent,
		ImageTransparency = state4 and 0.5 or 0,
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1)
	}
	local absoluteSize = React.Change.AbsoluteSize

	if FFlagUseRbxstorageInGallery then
		v4 = nil
	end

	v6[absoluteSize] = v4
	v6[React.Event.Activated] = onActivated

	local createElement2 = React.createElement
	local v7 = {
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -34, 0, 8),
		Size = UDim2.fromOffset(26, 26),
		ZIndex = 2
	}
	local checkbox

	if state4 then
		checkbox = React.createElement(Checkbox, {
			isChecked = true,
			isDisabled = false,
			LayoutOrder = 1,
			label = "",
			onActivated = onActivated
		})
	else
		checkbox = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			Image = Images["squircles/hollow"].Image,
			ImageRectOffset = Images["squircles/hollow"].ImageRectOffset,
			ImageRectSize = Images["squircles/hollow"].ImageRectSize,
			ImageTransparency = 0.7,
			Size = UDim2.fromOffset(26, 26),
			[React.Event.Activated] = onActivated
		})
	end

	local v8 = {
		CheckboxFrame = createElement2("Frame", v7, { Checkbox = checkbox }),
		TimeLength = 0,
		VideoPreview = 0
	}
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

	v8.TimeLength = timeLength
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

	v8.VideoPreview = videoPreview
	return createElement("ImageButton", v6, v8)
end
