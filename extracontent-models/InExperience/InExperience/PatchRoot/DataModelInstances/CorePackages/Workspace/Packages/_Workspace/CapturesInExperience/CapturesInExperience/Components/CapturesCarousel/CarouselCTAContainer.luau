local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local UIBlox = require(ParentParentParent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRef = React.useRef
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local CaptureType = require(ParentParent.Enums.CaptureType)
local Constants = require(ParentParent.Constants)
local DeleteWarningModalOpened = require(ParentParent.Actions.DeleteWarningModalOpened)
local EventNames = require(ParentParent.Analytics.EventNames)
local ExternalShareSourceType = require(ParentParent.Enums.ExternalShareSourceType)
local getIsDeleteWarningModalOptedOut = require(ParentParent.Utils.getIsDeleteWarningModalOptedOut)
local getSaveToStoragePermission = require(ParentParent.Utils.getSaveToStoragePermission)
local ShareCapture = require(ParentParent.Thunks.ShareCapture)

require(ParentParent.Types)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local uDim = UDim.new(0.12, 0)
local uDim2 = UDim2.fromOffset(36, 36)
local uDim3 = UDim.new(0, 8)

return (CapturesPolicy.connect(function(p1) -- line: 214
	return {
		enableShareCaptureCTA = p1.enableShareCaptureCTA()
	}
end)(function(t1: {[any]: any}) -- line: 48
	-- upvalues: useAnalytics (copy), useDispatch (copy), useStyle (copy), useRef (copy), useSelector (copy), Constants (copy), React (copy), getSaveToStoragePermission (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), EventNames (copy), SocialStopwatch (copy), ShareCapture (copy), ExternalShareSourceType (copy), getIsDeleteWarningModalOptedOut (copy), DeleteWarningModalOpened (copy), uDim3 (copy), uDim (copy), IconButton (copy), Images (copy), uDim2 (copy)
	local v28 = useAnalytics()
	local v29 = useDispatch()
	local v30 = useStyle()
	local v31 = useRef(0)
	local v32 = useSelector(function(p2) -- line: 55
		-- upvalues: Constants (copy)
		local SelectedCaptureIndex = p2[Constants.RoduxKey].Carousel.SelectedCaptureIndex

		return p2[Constants.RoduxKey].Captures[SelectedCaptureIndex]
	end)
	local v33 = React.useCallback(function() -- line: 60
		-- upvalues: t1 (copy), v31 (copy)
		if t1.isDisabled then
			return true
		end

		if DateTime.now().UnixTimestampMillis - v31.current < 500 then
			return true
		end

		return false
	end, { t1.isDisabled })
	local v34 = React.useCallback(function() -- line: 74
		-- upvalues: v31 (copy)
		v31.current = DateTime.now().UnixTimestampMillis
	end, {})
	local v35 = React.useCallback(function() -- line: 79
		-- upvalues: v33 (copy), getSaveToStoragePermission (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), v32 (copy), t1 (copy), v29 (copy), v34 (copy), CaptureType (copy), v28 (copy), EventNames (copy)
		if v33() then
			return
		end

		getSaveToStoragePermission(if not FFlagEnableCapturesGalleryRetrievalCoreScript then v32 else { v32 }, t1.openPermissionModal, v29)
		v34()

		if if not FFlagEnableCapturesGalleryRetrievalCoreScript then v32.type == CaptureType.Video else v32.CaptureType == Enum.CaptureType.Video then
			v28.fireEvent(EventNames.CapturesCarouselVideoSaveToExternalStorageActivated)

			return
		end

		v28.fireEvent(EventNames.CapturesCarouselSaveToExternalStorageActivated)
	end, {
		v32,
		v33,
		v34,
		t1.openPermissionModal
	})
	local v36 = React.useCallback(function() -- line: 101
		-- upvalues: v33 (copy), v34 (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), v32 (copy), CaptureType (copy), v28 (copy), EventNames (copy), SocialStopwatch (copy), v29 (copy), ShareCapture (copy), ExternalShareSourceType (copy)
		if v33() then
			return
		end

		v34()

		if if not FFlagEnableCapturesGalleryRetrievalCoreScript then v32.type == CaptureType.Video else v32.CaptureType == Enum.CaptureType.Video then
			v28.fireEvent(EventNames.CapturesCarouselVideoShareActivated)
		else
			v28.fireEvent(EventNames.CapturesCarouselShareActivated)
		end

		if SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureShared) == nil then
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureShared)
		end

		v29(ShareCapture(v32, ExternalShareSourceType.CapturesCarousel))
	end, {
		v32,
		t1.isDisabled,
		v33,
		v34
	})
	local v37 = React.useCallback(function() -- line: 125
		-- upvalues: v33 (copy), v34 (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), v32 (copy), CaptureType (copy), v28 (copy), EventNames (copy), getIsDeleteWarningModalOptedOut (copy), t1 (copy), v29 (copy), DeleteWarningModalOpened (copy)
		if v33() then
			return
		end

		v34()

		if if not FFlagEnableCapturesGalleryRetrievalCoreScript then v32.type == CaptureType.Video else v32.CaptureType == Enum.CaptureType.Video then
			v28.fireEvent(EventNames.CapturesVideoDeleteActivatedInCarousel)
		else
			v28.fireEvent(EventNames.CapturesDeleteActivatedInCarousel)
		end

		if getIsDeleteWarningModalOptedOut() then
			assert(t1.deleteItem ~= nil, "props.deleteItem should not be nil")
			t1.deleteItem()

			return
		end

		v29(DeleteWarningModalOpened())
	end, {
		v32,
		t1.deleteItem,
		t1.isDisabled,
		v33,
		v34
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundColor3 = v30.Theme.BackgroundContrast.Color,
		BackgroundTransparency = v30.Theme.BackgroundContrast.Transparency,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(1, 0, 0, t1.height),
		ZIndex = t1.ZIndex
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = uDim3
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = uDim,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SaveButton = if not FFlagEnableCapturesGalleryRetrievalCoreScript then React.createElement(IconButton, {
			layoutOrder = 1,
			showBackground = false,
			backgroundColor = v30.Theme.BackgroundUIContrast,
			icon = Images["icons/actions/download_medium"],
			onActivated = v35,
			size = uDim2
		}) else React.createElement(IconButton, {
			layoutOrder = 1,
			showBackground = false,
			backgroundColor = v30.Theme.BackgroundUIContrast,
			icon = Images["icons/actions/download_medium"],
			onActivated = v35,
			size = uDim2
		}),
		ShareButton = t1.enableShareCaptureCTA and React.createElement(IconButton, {
			layoutOrder = 2,
			showBackground = false,
			backgroundColor = v30.Theme.BackgroundUIContrast,
			icon = Images["icons/actions/share"],
			onActivated = v36,
			size = uDim2
		}),
		DeleteButton = React.createElement(IconButton, {
			layoutOrder = 4,
			showBackground = false,
			icon = Images["icons/actions/edit/delete"],
			onActivated = v37,
			size = uDim2
		})
	})
end))
