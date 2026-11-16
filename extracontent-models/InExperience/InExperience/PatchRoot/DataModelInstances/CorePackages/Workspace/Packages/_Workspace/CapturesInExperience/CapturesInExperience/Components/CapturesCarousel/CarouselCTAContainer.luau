local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local SocialStopwatch = require(parent2.SocialStopwatch)
local UIBlox = require(parent2.UIBlox)

local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRef = React.useRef
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local CapturesPolicy = require(parent.App.CapturesPolicy)
local CaptureType = require(parent.Enums.CaptureType)
local Constants = require(parent.Constants)
local DeleteWarningModalOpened = require(parent.Actions.DeleteWarningModalOpened)
local EventNames = require(parent.Analytics.EventNames)
local ExternalShareSourceType = require(parent.Enums.ExternalShareSourceType)
local getIsDeleteWarningModalOptedOut = require(parent.Utils.getIsDeleteWarningModalOptedOut)
local getSaveToStoragePermission = require(parent.Utils.getSaveToStoragePermission)
local ShareCapture = require(parent.Thunks.ShareCapture)
require(parent.Types)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local udim = UDim.new(0.12, 0)
local udim2 = UDim2.fromOffset(36, 36)
local udim3 = UDim.new(0, 8)

return (CapturesPolicy.connect(function(p)
	return { enableShareCaptureCTA = p.enableShareCaptureCTA() }
end)(function(props)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useStyle()

	local v4 = useRef(0)

	local v5 = useSelector(function(p)
		local selectedCaptureIndex = p[Constants.RoduxKey].Carousel.SelectedCaptureIndex
		return p[Constants.RoduxKey].Captures[selectedCaptureIndex]
	end)

	local v6 = React.useCallback(function(): boolean
		if props.isDisabled then
			return true
		end

		return DateTime.now().UnixTimestampMillis - v4.current < 500
	end, { props.isDisabled })

	local v7 = React.useCallback(function()
		v4.current = DateTime.now().UnixTimestampMillis
	end, {})

	local onActivated = React.useCallback(function()
		if v6() then
			return
		end

		local v8

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			v8 = { v5 }
		else
			v8 = v5
		end

		getSaveToStoragePermission(v8, props.openPermissionModal, v2)

		v7()
		local v9

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			v9 = v5.CaptureType == Enum.CaptureType.Video
		else
			v9 = v5.type == CaptureType.Video
		end

		if v9 then
			v.fireEvent(EventNames.CapturesCarouselVideoSaveToExternalStorageActivated)
		else
			v.fireEvent(EventNames.CapturesCarouselSaveToExternalStorageActivated)
		end
	end, { v5, v6, v7, props.openPermissionModal })

	local onActivated2 = React.useCallback(function()
		if v6() then
			return
		end

		v7()
		local v8

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			v8 = v5.CaptureType == Enum.CaptureType.Video
		else
			v8 = v5.type == CaptureType.Video
		end

		if v8 then
			v.fireEvent(EventNames.CapturesCarouselVideoShareActivated)
		else
			v.fireEvent(EventNames.CapturesCarouselShareActivated)
		end

		if SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureShared) == nil then
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureShared)
		end

		v2(ShareCapture(v5, ExternalShareSourceType.CapturesCarousel))
	end, { v5, props.isDisabled, v6, v7 })

	local onActivated3 = React.useCallback(function()
		if v6() then
			return
		end

		v7()
		local v8

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			v8 = v5.CaptureType == Enum.CaptureType.Video
		else
			v8 = v5.type == CaptureType.Video
		end

		if v8 then
			v.fireEvent(EventNames.CapturesVideoDeleteActivatedInCarousel)
		else
			v.fireEvent(EventNames.CapturesDeleteActivatedInCarousel)
		end

		if not getIsDeleteWarningModalOptedOut() then
			v2(DeleteWarningModalOpened())

			return
		end

		assert(props.deleteItem ~= nil, "props.deleteItem should not be nil")
		props.deleteItem()
	end, { v5, props.deleteItem, props.isDisabled, v6, v7 })

	local createElement = React.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundColor3 = v3.Theme.BackgroundContrast.Color,
		BackgroundTransparency = v3.Theme.BackgroundContrast.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, props.height),
		ZIndex = props.ZIndex
	}
	local v9 = {
		UICorner = React.createElement("UICorner", { CornerRadius = udim3 }),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = udim,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SaveButton = 0,
		ShareButton = 0,
		DeleteButton = 0
	}

	if FFlagEnableCapturesGalleryRetrievalCoreScript then
	end

	v9.SaveButton = React.createElement(IconButton, {
		backgroundColor = v3.Theme.BackgroundUIContrast,
		icon = Images["icons/actions/download_medium"],
		layoutOrder = 1,
		onActivated = onActivated,
		showBackground = false,
		size = udim2
	})

	v9.ShareButton = props.enableShareCaptureCTA and React.createElement(IconButton, {
		backgroundColor = v3.Theme.BackgroundUIContrast,
		icon = Images["icons/actions/share"],
		layoutOrder = 2,
		onActivated = onActivated2,
		showBackground = false,
		size = udim2
	})

	v9.DeleteButton = React.createElement(IconButton, {
		icon = Images["icons/actions/edit/delete"],
		layoutOrder = 4,
		onActivated = onActivated3,
		showBackground = false,
		size = udim2
	})
	return createElement("Frame", v8, v9)
end))
