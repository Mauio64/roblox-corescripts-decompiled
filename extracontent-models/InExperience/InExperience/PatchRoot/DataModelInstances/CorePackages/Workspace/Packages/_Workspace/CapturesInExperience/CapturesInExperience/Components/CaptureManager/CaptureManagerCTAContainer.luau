local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local SocialStopwatch = require(parent2.SocialStopwatch)
local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
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

local defineFastInt = game:DefineFastInt("CapturesSaveToExternalStorageLimit", 10)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local udim = UDim2.new(0.33, 0, 0, 36)

return (CapturesPolicy.connect(function(p)
	return { enableShareCaptureCTA = p.enableShareCaptureCTA() }
end)(function(props)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useStyle()

	local v4 = useRef(0)

	local v5 = useSelector(function(p)
		return p[Constants.RoduxKey].CaptureManager.SelectedCaptures
	end)

	local state, setState = React.useState(false)

	local count = #v5
	local isDisabled = #v5 == 0 or #v5 > 1
	local isDisabled2 = #v5 == 0 or defineFastInt < #v5
	local isDisabled3 = #v5 == 0
	local fillDirection

	if props.isHorizontal then
		fillDirection = Enum.FillDirection.Horizontal
	else
		fillDirection = Enum.FillDirection.Vertical
	end

	local textXAlignment

	if props.isHorizontal then
		textXAlignment = Enum.TextXAlignment.Left
	else
		textXAlignment = Enum.TextXAlignment.Center
	end

	local udim2

	if props.isHorizontal then
		udim2 = UDim2.new(0, props.width - 279, 0, props.height)
	else
		udim2 = UDim2.new(1, 0, 0, 38)
	end

	local udim3

	if props.isHorizontal then
		udim3 = UDim2.new(0, 279, 0, props.height)
	else
		udim3 = UDim2.new(1, 0, 0, 44)
	end

	local v6 = useLocalization({
		selectCaptureLabel = "Feature.Captures.Label.SelectCapture",
		oneCaptureSelectedLabel = "Feature.Captures.Label.OneCaptureSelected",
		multipleCapturesSelectedLabel = {
			"Feature.Captures.Label.MultipleCapturesSelected",
			numberOfCaptures = count
		}
	})

	React.useEffect(function()
		local v7 = false

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			for _, v8 in v5 do
				if v8.CaptureType == Enum.CaptureType.Video then
					v7 = true
					break
				end
			end
		else
			for _, v8 in v5 do
				if v8.type == CaptureType.Video then
					v7 = true
					break
				end
			end
		end

		setState(v7)
	end, { v5 })

	local v7 = React.useCallback(function()
		if count == 0 then
			return v6.selectCaptureLabel
		elseif count == 1 then
			return v6.oneCaptureSelectedLabel
		end

		return v6.multipleCapturesSelectedLabel
	end, { count })

	local v8 = React.useCallback(function(): boolean
		if props.isDisabled then
			return true
		end

		return DateTime.now().UnixTimestampMillis - v4.current < 500
	end, { props.isDisabled })

	local v9 = React.useCallback(function()
		v4.current = DateTime.now().UnixTimestampMillis
	end, {})

	local onActivated = React.useCallback(function()
		if v8() or #v5 == 0 then
			return
		end

		getSaveToStoragePermission(v5, props.openPermissionModal, v2)
		v.fireEvent(EventNames.CapturesManagerBulkSaveToExternalStorageActivated)
		v9()
	end, { v5, v8, v9, props.openPermissionModal })

	local onActivated2 = React.useCallback(function()
		if v8() or isDisabled then
			return
		end

		local v10 = v5[1]
		v9()

		if state then
			v.fireEvent(EventNames.CapturesManagerShareVideoActivated)
		end

		v.fireEvent(EventNames.CapturesManagerShareActivated)

		if not SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureShared) then
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureShared)
		end

		v2(ShareCapture(v10, ExternalShareSourceType.CapturesManager))
	end, { v8, isDisabled, state, props.isDisabled, v9, v5 })

	local onActivated3 = React.useCallback(function()
		if v8() or isDisabled3 then
			return
		end

		v9()

		v.fireEvent(EventNames.CapturesDeleteActivatedInCaptureManager)

		if not getIsDeleteWarningModalOptedOut() then
			v2(DeleteWarningModalOpened())

			return
		end

		assert(props.deleteItem ~= nil, "props.deleteItem should not be nil")
		props.deleteItem()
	end, { v8, isDisabled3, props.deleteItem, props.isDisabled, v9 })

	local createElement = React.createElement
	local v10 = {
		BackgroundColor3 = v3.Theme.BackgroundContrast.Color,
		BackgroundTransparency = v3.Theme.BackgroundContrast.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, props.height),
		ZIndex = props.ZIndex
	}
	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = fillDirection,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Padding = React.createElement("UIPadding", { PaddingRight = UDim.new(0, 16) }),
		CapturesLabel = 0,
		CTAContainer = 0
	}

	local createElement2 = React.createElement
	local v11 = {
		AnchorPoint = Vector2.new(1, 0.5),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		Position = 0,
		Size = 0,
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		ZIndex = 1
	}
	local font

	if not FoundationFontFaceMigration then
		font = v3.Font.Header2.Font
	end

	v11.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v3.Tokens.Typography.TitleLarge.Font)
	end

	v11.FontFace = fontFace

	v11.Position = UDim2.new(1, 0, 1, 0)
	v11.Size = udim2
	v11.Text = v7()
	v11.TextColor3 = v3.Theme.TextEmphasis.Color
	v11.TextSize = v3.Font.BaseSize * v3.Font.CaptionHeader.RelativeSize
	v11.TextXAlignment = textXAlignment
	v11.TextYAlignment = Enum.TextYAlignment.Center
	children.CapturesLabel = createElement2("TextLabel", v11)

	children.CTAContainer = React.createElement("Frame", {
		BackgroundColor3 = v3.Theme.BackgroundContrast.Color,
		BackgroundTransparency = v3.Theme.BackgroundContrast.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = udim3,
		ZIndex = props.ZIndex
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		BulkSaveButton = React.createElement(IconButton, {
			backgroundColor = v3.Theme.BackgroundUIContrast,
			icon = Images["icons/actions/download_medium"],
			iconSize = IconSize.Medium,
			isDisabled = isDisabled2,
			layoutOrder = 1,
			onActivated = onActivated,
			size = udim
		}),
		BulkShareButton = props.enableShareCaptureCTA and React.createElement(IconButton, {
			backgroundColor = v3.Theme.BackgroundUIContrast,
			icon = Images["icons/actions/share"],
			iconSize = IconSize.Medium,
			isDisabled = isDisabled,
			layoutOrder = 1,
			onActivated = onActivated2,
			size = udim
		}),
		BulkDeleteButton = React.createElement(IconButton, {
			icon = Images["icons/actions/edit/delete"],
			iconSize = IconSize.Medium,
			isDisabled = isDisabled3,
			layoutOrder = 2,
			onActivated = onActivated3,
			size = udim
		})
	})
	return createElement("Frame", v10, children)
end))
