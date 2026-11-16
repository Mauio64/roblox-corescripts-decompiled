local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local ContextActionService = game:GetService("ContextActionService")
local LocalizationService = game:GetService("LocalizationService")

local AppCommonLib = require(parent2.AppCommonLib)
local IXPServiceWrapper = require(parent2.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Signal = AppCommonLib.Signal
local useStyle = UIBlox.Core.Style.useStyle

local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useRef = React.useRef
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useState = React.useState

local CapturesCarousel = require(parent.Components.CapturesCarousel.CapturesCarousel)
local CapturesToastType = require(parent.Enums.CapturesToastType)
local CarouselClosed = require(parent.Actions.CarouselClosed)
local CarouselCTAContainer = require(parent.Components.CapturesCarousel.CarouselCTAContainer)
local Constants = require(parent.Constants)
local DeleteCapture = require(parent.Thunks.DeleteCapture)
local DeleteWarningModal = require(parent.Components.Common.DeleteWarningModal)
local EventNames = require(parent.Analytics.EventNames)
local getTimestampFromCapture = require(parent.Utils.getTimestampFromCapture)
local PermissionModal = require(parent.Components.Common.PermissionModal)
local ToastContainer = require(parent.Components.Common.ToastContainer)
local ToastTriggered = require(parent.Actions.ToastTriggered)
require(parent.Types)
local useAnalytics = require(parent.Analytics.useAnalytics)

local SharedFlags = require(parent2.SharedFlags)
local FFlagUseMediaPlayerInCarousel = SharedFlags.FFlagUseMediaPlayerInCarousel
local SharedFlags2 = require(parent2.SharedFlags)
local FStringSocialCaptureTakenIXPLayer = SharedFlags2.FStringSocialCaptureTakenIXPLayer

local udim = UDim2.fromOffset(32, 32)

local function getTitle(p)
	local timestampFromCapture = getTimestampFromCapture(p)

	if not timestampFromCapture then
		return ""
	end

	assert(typeof(timestampFromCapture) == "number", "Expected timestamp to be a number")
	local dateTime = DateTime.fromUnixTimestampMillis(timestampFromCapture)

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	return `{dateTime:FormatLocalTime("L", robloxLocaleId)} {dateTime:FormatLocalTime("LT", robloxLocaleId)}`
end

return function(_)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useStyle()

	local v4 = useSelector(function(p)
		return p[Constants.RoduxKey].Captures
	end)

	local v5 = useSelector(function(p)
		return p[Constants.RoduxKey].Carousel.IsOpen
	end)

	local v6 = useSelector(function(p)
		return p[Constants.RoduxKey].Carousel.SelectedCaptureIndex
	end)

	local v7 = useSelector(function(p)
		return p[Constants.RoduxKey].Carousel.IsDeleteWarningModalOpen
	end)

	local v8 = useRef(Signal.new())
	local state, setState = useState(false)
	local state2, setState2 = useState(false)
	local v9 = useScreenSize()

	useEffectOnce(function()
		ixpServiceWrapper:LogUserLayerExposure(FStringSocialCaptureTakenIXPLayer)
	end, v5)

	useEffect(function()
		v2(ToastTriggered(CapturesToastType.None))
	end, { v5 })

	local v10 = useCallback(function()
		setState(false)
		v.fireEvent(EventNames.CapturesCarouselClosed)
		v2(CarouselClosed())
	end, {})

	local v11 = useCallback(function()
		setState(false)
		v.fireEvent(EventNames.CapturesCarouselClosedByKeyboard)
		v2(CarouselClosed())
	end, {})

	local openPermissionModal = useCallback(function()
		setState2(true)
	end, {})

	local closeModal = useCallback(function()
		setState2(false)
	end, {})

	local deleteItem = useCallback(function()
		setState(true)

		local v12 = v4[v6]
		local function fn()
			v2(DeleteCapture(v12))
			setState(false)
		end

		v8.current:fire(fn)
	end, { v4, v6 })

	useEffect(function()
		if v5 and not v7 then
			ContextActionService:BindCoreAction("CapturesCarouselCloseShortcutAction", function(_, p)
				if p == Enum.UserInputState.End then
					v11()
				end
			end, false, Enum.KeyCode.Escape)

			return function()
				ContextActionService:UnbindCoreAction("CapturesCarouselCloseShortcutAction")
			end
		end
	end, { v5, v7, v11 })

	if not v5 then
		return nil
	end

	local maxHeight = v9.Y - 32 - 40 - 8 - 16 - 16

	local title = getTitle(v4[v6])

	local createElement = React.createElement
	local v12 = {
		Active = true,
		BackgroundColor3 = v3.Theme.BackgroundContrast.Color,
		BackgroundTransparency = v3.Theme.BackgroundContrast.Transparency,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1)
	}

	local createElement2 = React.createElement
	local v13 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Padding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 16),
			PaddingTop = UDim.new(0, 8)
		}),
		TitleFrame = 0,
		CapturesCarousel = 0,
		CTAContainer = 0
	}

	local createElement3 = React.createElement
	local v14 = {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 32),
		ZIndex = FFlagUseMediaPlayerInCarousel and 1 or 2
	}

	local children2 = {
		CloseButton = React.createElement(ImageSetButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Image = Images["icons/navigation/close"],
			ImageColor3 = v3.Theme.IconEmphasis.Color,
			ImageTransparency = v3.Theme.IconEmphasis.Transparency,
			Position = UDim2.new(0, 42, 0.5, 0),
			Size = udim,
			[React.Event.Activated] = v10
		}),
		DropShadow = 0,
		Title = 0
	}

	local createElement4 = React.createElement
	local v15 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
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
		TextTransparency = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		ZIndex = 1
	}
	local font

	if not FoundationFontFaceMigration then
		font = v3.Font.Header2.Font
	end

	v15.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v3.Tokens.Typography.TitleLarge.Font)
	end

	v15.FontFace = fontFace

	v15.Position = UDim2.new(0.5, 0, 0.5, 2)
	v15.Size = UDim2.fromScale(0, 1)
	v15.Text = title
	v15.TextColor3 = v3.Theme.DropShadow.Color
	v15.TextSize = v3.Font.BaseSize * v3.Font.Header2.RelativeSize
	v15.TextTransparency = v3.Theme.DropShadow.Transparency
	v15.TextXAlignment = Enum.TextXAlignment.Center
	v15.TextYAlignment = Enum.TextYAlignment.Center
	children2.DropShadow = createElement4("TextLabel", v15, {
		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Color = v3.Theme.DropShadow.Color,
			LineJoinMode = Enum.LineJoinMode.Round,
			Thickness = 1,
			Transparency = v3.Theme.DropShadow.Transparency
		})
	})

	local createElement5 = React.createElement
	local v16 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
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
		ZIndex = 2
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = v3.Font.Header2.Font
	end

	v16.Font = font2
	local fontFace2

	if FoundationFontFaceMigration then
		fontFace2 = normalizeFontFace(v3.Tokens.Typography.TitleLarge.Font)
	end

	v16.FontFace = fontFace2

	v16.Position = UDim2.fromScale(0.5, 0.5)
	v16.Size = UDim2.fromScale(0, 1)
	v16.Text = title
	v16.TextColor3 = v3.Theme.TextEmphasis.Color
	v16.TextSize = v3.Font.BaseSize * v3.Font.Header2.RelativeSize
	v16.TextXAlignment = Enum.TextXAlignment.Center
	v16.TextYAlignment = Enum.TextYAlignment.Center
	children2.Title = createElement5("TextLabel", v16)
	children.TitleFrame = createElement3("Frame", v14, children2)

	children.CapturesCarousel = React.createElement(CapturesCarousel, {
		deleteItemSignal = v8.current,
		isDisabled = state,
		LayoutOrder = 2,
		maxHeight = maxHeight,
		ZIndex = FFlagUseMediaPlayerInCarousel and 2 or 1
	})

	children.CTAContainer = React.createElement(CarouselCTAContainer, {
		deleteItem = deleteItem,
		height = 40,
		isDisabled = state or v7,
		LayoutOrder = 3,
		openPermissionModal = openPermissionModal,
		ZIndex = FFlagUseMediaPlayerInCarousel and 1 or 2
	})
	return createElement("Frame", v12, {
		CarouselContainer = createElement2("Frame", v13, children),
		DeleteWarningModal = React.createElement(DeleteWarningModal, {
			deleteItem = deleteItem,
			zIndex = 3
		}),
		PermissionModal = React.createElement(PermissionModal, {
			closeModal = closeModal,
			visible = state2,
			zIndex = 3
		}),
		ToastsFrame = React.createElement(
			"Frame",
			{
				Active = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = Constants.ZIndex.Toasts
			},
			{
				ToastContainer = React.createElement(ToastContainer)
			}
		)
	})
end
