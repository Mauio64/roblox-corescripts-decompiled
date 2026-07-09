local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local UIBlox = require(ParentParentParent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
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

local v26 = game:DefineFastInt("CapturesSaveToExternalStorageLimit", 10)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local uDim2 = UDim2.new(0.33, 0, 0, 36)

return (CapturesPolicy.connect(function(p1) -- line: 279
	return {
		enableShareCaptureCTA = p1.enableShareCaptureCTA()
	}
end)(function(t1: {[any]: any}) -- line: 55
	-- upvalues: useAnalytics (copy), useDispatch (copy), useStyle (copy), useRef (copy), useSelector (copy), Constants (copy), React (copy), v26 (copy), useLocalization (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), getSaveToStoragePermission (copy), EventNames (copy), SocialStopwatch (copy), ShareCapture (copy), ExternalShareSourceType (copy), getIsDeleteWarningModalOptedOut (copy), DeleteWarningModalOpened (copy), IconButton (copy), Images (copy), IconSize (copy), uDim2 (copy)
	local v30 = useAnalytics()
	local v31 = useDispatch()
	local v32 = useStyle()
	local v33 = useRef(0)
	local v34 = useSelector(function(p2) -- line: 62
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].CaptureManager.SelectedCaptures
	end)
	local v35, v36 = React.useState(false)
	local v37 = #v34
	local v38 = #v34 == 0 or #v34 > 1
	local v39 = #v34 == 0 or #v34 > v26
	local v40 = #v34 == 0
	local v41 = if not t1.isHorizontal then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal
	local v42 = if not t1.isHorizontal then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left
	local v43 = if not t1.isHorizontal then UDim2.new(1, 0, 0, 38) else UDim2.new(0, t1.width - 279, 0, t1.height)
	local v44 = if not t1.isHorizontal then UDim2.new(1, 0, 0, 44) else UDim2.new(0, 279, 0, t1.height)
	local v45 = useLocalization({
		selectCaptureLabel = "Feature.Captures.Label.SelectCapture",
		oneCaptureSelectedLabel = "Feature.Captures.Label.OneCaptureSelected",
		multipleCapturesSelectedLabel = {
			"Feature.Captures.Label.MultipleCapturesSelected",
			numberOfCaptures = v37
		}
	})

	React.useEffect(function() -- line: 90
		-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), v34 (copy), CaptureType (copy), v36 (copy)
		local v54 = false

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			for _, v56 in v34 do
				if v56.CaptureType == Enum.CaptureType.Video then
					v54 = true

					break
				end
			end
		else
			for _, v58 in v34 do
				if v58.type == CaptureType.Video then
					v54 = true

					break
				end
			end
		end

		v36(v54)
	end, { v34 })

	local v46 = React.useCallback(function() -- line: 110
		-- upvalues: v37 (copy), v45 (copy)
		if v37 == 0 then
			return v45.selectCaptureLabel
		end

		if v37 == 1 then
			return v45.oneCaptureSelectedLabel
		end

		return v45.multipleCapturesSelectedLabel
	end, { v37 })
	local v47 = React.useCallback(function() -- line: 120
		-- upvalues: t1 (copy), v33 (copy)
		if t1.isDisabled then
			return true
		end

		if DateTime.now().UnixTimestampMillis - v33.current < 500 then
			return true
		end

		return false
	end, { t1.isDisabled })
	local v48 = React.useCallback(function() -- line: 134
		-- upvalues: v33 (copy)
		v33.current = DateTime.now().UnixTimestampMillis
	end, {})
	local v49 = React.useCallback(function() -- line: 138
		-- upvalues: v47 (copy), v34 (copy), getSaveToStoragePermission (copy), t1 (copy), v31 (copy), v30 (copy), EventNames (copy), v48 (copy)
		if v47() or #v34 == 0 then
			return
		end

		getSaveToStoragePermission(v34, t1.openPermissionModal, v31)
		v30.fireEvent(EventNames.CapturesManagerBulkSaveToExternalStorageActivated)
		v48()
	end, {
		v34,
		v47,
		v48,
		t1.openPermissionModal
	})
	local v50 = React.useCallback(function() -- line: 149
		-- upvalues: v47 (copy), v38 (copy), v34 (copy), v48 (copy), v35 (copy), v30 (copy), EventNames (copy), SocialStopwatch (copy), v31 (copy), ShareCapture (copy), ExternalShareSourceType (copy)
		if v47() or v38 then
			return
		end

		local v59 = v34[1]

		v48()

		if v35 then
			v30.fireEvent(EventNames.CapturesManagerShareVideoActivated)
		end

		v30.fireEvent(EventNames.CapturesManagerShareActivated)

		if not SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureShared) then
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureShared)
		end

		v31(ShareCapture(v59, ExternalShareSourceType.CapturesManager))
	end, {
		v47,
		v38,
		v35,
		t1.isDisabled,
		v48,
		v34
	})
	local v51 = React.useCallback(function() -- line: 177
		-- upvalues: v47 (copy), v40 (copy), v48 (copy), v30 (copy), EventNames (copy), getIsDeleteWarningModalOptedOut (copy), t1 (copy), v31 (copy), DeleteWarningModalOpened (copy)
		if v47() or v40 then
			return
		end

		v48()
		v30.fireEvent(EventNames.CapturesDeleteActivatedInCaptureManager)

		if getIsDeleteWarningModalOptedOut() then
			assert(t1.deleteItem ~= nil, "props.deleteItem should not be nil")
			t1.deleteItem()

			return
		end

		v31(DeleteWarningModalOpened())
	end, {
		v47,
		v40,
		t1.deleteItem,
		t1.isDisabled,
		v48
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = v32.Theme.BackgroundContrast.Color,
		BackgroundTransparency = v32.Theme.BackgroundContrast.Transparency,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(1, 0, 0, t1.height),
		ZIndex = t1.ZIndex
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = v41,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Padding = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 16)
		}),
		CapturesLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ZIndex = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			AutomaticSize = Enum.AutomaticSize.X,
			Font = v32.Font.Header2.Font,
			Position = UDim2.new(1, 0, 1, 0),
			Size = v43,
			Text = v46(),
			TextColor3 = v32.Theme.TextEmphasis.Color,
			TextSize = v32.Font.BaseSize * v32.Font.CaptionHeader.RelativeSize,
			TextXAlignment = v42,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		CTAContainer = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = v32.Theme.BackgroundContrast.Color,
			BackgroundTransparency = v32.Theme.BackgroundContrast.Transparency,
			LayoutOrder = t1.LayoutOrder,
			Size = v44,
			ZIndex = t1.ZIndex
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			BulkSaveButton = React.createElement(IconButton, {
				layoutOrder = 1,
				backgroundColor = v32.Theme.BackgroundUIContrast,
				icon = Images["icons/actions/download_medium"],
				iconSize = IconSize.Medium,
				isDisabled = v39,
				onActivated = v49,
				size = uDim2
			}),
			BulkShareButton = t1.enableShareCaptureCTA and React.createElement(IconButton, {
				layoutOrder = 1,
				backgroundColor = v32.Theme.BackgroundUIContrast,
				icon = Images["icons/actions/share"],
				iconSize = IconSize.Medium,
				isDisabled = v38,
				onActivated = v50,
				size = uDim2
			}),
			BulkDeleteButton = React.createElement(IconButton, {
				layoutOrder = 2,
				icon = Images["icons/actions/edit/delete"],
				iconSize = IconSize.Medium,
				isDisabled = v40,
				onActivated = v51,
				size = uDim2
			})
		})
	})
end))
