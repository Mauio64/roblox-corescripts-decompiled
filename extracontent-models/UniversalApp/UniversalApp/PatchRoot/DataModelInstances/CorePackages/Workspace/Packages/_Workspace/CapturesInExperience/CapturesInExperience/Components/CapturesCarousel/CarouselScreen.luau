local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ContextActionService = game:GetService("ContextActionService")
local LocalizationService = game:GetService("LocalizationService")
local AppCommonLib = require(ParentParentParent.AppCommonLib)
local IXPServiceWrapper = require(ParentParentParent.IXPServiceWrapper).IXPServiceWrapper
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
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
local CapturesCarousel = require(ParentParent.Components.CapturesCarousel.CapturesCarousel)
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local CarouselClosed = require(ParentParent.Actions.CarouselClosed)
local CarouselCTAContainer = require(ParentParent.Components.CapturesCarousel.CarouselCTAContainer)
local Constants = require(ParentParent.Constants)
local DeleteCapture = require(ParentParent.Thunks.DeleteCapture)
local DeleteWarningModal = require(ParentParent.Components.Common.DeleteWarningModal)
local EventNames = require(ParentParent.Analytics.EventNames)
local getTimestampFromCapture = require(ParentParent.Utils.getTimestampFromCapture)
local PermissionModal = require(ParentParent.Components.Common.PermissionModal)
local ToastContainer = require(ParentParent.Components.Common.ToastContainer)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)

require(ParentParent.Types)

local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local FFlagUseMediaPlayerInCarousel = require(ParentParentParent.SharedFlags).FFlagUseMediaPlayerInCarousel
local FStringSocialCaptureTakenIXPLayer = require(ParentParentParent.SharedFlags).FStringSocialCaptureTakenIXPLayer
local uDim2 = UDim2.fromOffset(32, 32)

local function getTitle(p1) -- line: 55
	-- upvalues: getTimestampFromCapture (copy), LocalizationService (copy)
	local v41 = getTimestampFromCapture(p1)

	if not v41 then
		return ""
	end

	assert(typeof(v41) == "number", "Expected timestamp to be a number")

	local dateTime = DateTime.fromUnixTimestampMillis(v41)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	return `{ dateTime:FormatLocalTime("L", RobloxLocaleId) } { dateTime:FormatLocalTime("LT", RobloxLocaleId) }`
end

return function(_: {[any]: any}) -- line: 73
	-- upvalues: useAnalytics (copy), useDispatch (copy), useStyle (copy), useSelector (copy), Constants (copy), useRef (copy), Signal (copy), useState (copy), useScreenSize (copy), useEffectOnce (copy), IXPServiceWrapper (copy), FStringSocialCaptureTakenIXPLayer (copy), useEffect (copy), ToastTriggered (copy), CapturesToastType (copy), useCallback (copy), EventNames (copy), CarouselClosed (copy), DeleteCapture (copy), ContextActionService (copy), getTitle (copy), React (copy), FFlagUseMediaPlayerInCarousel (copy), ImageSetButton (copy), Images (copy), uDim2 (copy), CapturesCarousel (copy), CarouselCTAContainer (copy), DeleteWarningModal (copy), PermissionModal (copy), ToastContainer (copy)
	local v45 = useAnalytics()
	local v46 = useDispatch()
	local v47 = useStyle()
	local v48 = useSelector(function(p2) -- line: 78
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].Captures
	end)
	local v49 = useSelector(function(p3) -- line: 82
		-- upvalues: Constants (copy)
		return p3[Constants.RoduxKey].Carousel.IsOpen
	end)
	local v50 = useSelector(function(p4) -- line: 86
		-- upvalues: Constants (copy)
		return p4[Constants.RoduxKey].Carousel.SelectedCaptureIndex
	end)
	local v51 = useSelector(function(p5) -- line: 90
		-- upvalues: Constants (copy)
		return p5[Constants.RoduxKey].Carousel.IsDeleteWarningModalOpen
	end)
	local v52 = useRef(Signal.new())
	local v53, v54 = useState(false)
	local v55, v56 = useState(false)
	local v57 = useScreenSize()

	useEffectOnce(function() -- line: 99
		-- upvalues: IXPServiceWrapper (copy), FStringSocialCaptureTakenIXPLayer (copy)
		IXPServiceWrapper:LogUserLayerExposure(FStringSocialCaptureTakenIXPLayer)
	end, v49)
	useEffect(function() -- line: 103
		-- upvalues: v46 (copy), ToastTriggered (copy), CapturesToastType (copy)
		v46(ToastTriggered(CapturesToastType.None))
	end, { v49 })

	local v58 = useCallback(function() -- line: 107
		-- upvalues: v54 (copy), v45 (copy), EventNames (copy), v46 (copy), CarouselClosed (copy)
		v54(false)
		v45.fireEvent(EventNames.CapturesCarouselClosed)
		v46(CarouselClosed())
	end, {})
	local v59 = useCallback(function() -- line: 113
		-- upvalues: v54 (copy), v45 (copy), EventNames (copy), v46 (copy), CarouselClosed (copy)
		v54(false)
		v45.fireEvent(EventNames.CapturesCarouselClosedByKeyboard)
		v46(CarouselClosed())
	end, {})
	local v60 = useCallback(function() -- line: 119
		-- upvalues: v56 (copy)
		v56(true)
	end, {})
	local v61 = useCallback(function() -- line: 123
		-- upvalues: v56 (copy)
		v56(false)
	end, {})
	local v62 = useCallback(function() -- line: 127
		-- upvalues: v54 (copy), v48 (copy), v50 (copy), v46 (copy), DeleteCapture (copy), v52 (copy)
		v54(true)

		local v70 = v48[v50]

		v52.current:fire(function() -- line: 131
			-- upvalues: v46 (copy), DeleteCapture (copy), v70 (copy), v54 (copy)
			v46(DeleteCapture(v70))
			v54(false)
		end)
	end, {
		v48,
		v50
	})

	useEffect(function() -- line: 139
		-- upvalues: v49 (copy), v51 (copy), ContextActionService (copy), v59 (copy)
		if not v49 or v51 then
			return
		end

		ContextActionService:BindCoreAction("CapturesCarouselCloseShortcutAction", function(_, p7) -- line: 144
			-- upvalues: v59 (copy)
			if p7 == Enum.UserInputState.End then
				v59()
			end
		end, false, Enum.KeyCode.Escape)

		return function() -- line: 150
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("CapturesCarouselCloseShortcutAction")
		end
	end, {
		v49,
		v51,
		v59
	})

	if not v49 then
		return nil
	end

	local v63 = v57.Y - 32 - 40 - 8 - 16 - 16
	local v64 = v48[v50]
	local v65 = getTitle(v64)

	return React.createElement("Frame", {
		Active = true,
		BorderSizePixel = 0,
		BackgroundColor3 = v47.Theme.BackgroundContrast.Color,
		BackgroundTransparency = v47.Theme.BackgroundContrast.Transparency,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1)
	}, {
		CarouselContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
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
			TitleFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 32),
				ZIndex = not FFlagUseMediaPlayerInCarousel and 2 or 1
			}, {
				CloseButton = React.createElement(ImageSetButton, {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Image = Images["icons/navigation/close"],
					ImageColor3 = v47.Theme.IconEmphasis.Color,
					ImageTransparency = v47.Theme.IconEmphasis.Transparency,
					Position = UDim2.new(0, 42, 0.5, 0),
					Size = uDim2,
					[React.Event.Activated] = v58
				}),
				DropShadow = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ZIndex = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					AutomaticSize = Enum.AutomaticSize.X,
					Font = v47.Font.Header2.Font,
					Position = UDim2.new(0.5, 0, 0.5, 2),
					Size = UDim2.fromScale(0, 1),
					Text = v65,
					TextColor3 = v47.Theme.DropShadow.Color,
					TextSize = v47.Font.BaseSize * v47.Font.Header2.RelativeSize,
					TextTransparency = v47.Theme.DropShadow.Transparency,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center
				}, {
					UIStroke = React.createElement("UIStroke", {
						Thickness = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
						Color = v47.Theme.DropShadow.Color,
						LineJoinMode = Enum.LineJoinMode.Round,
						Transparency = v47.Theme.DropShadow.Transparency
					})
				}),
				Title = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ZIndex = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					AutomaticSize = Enum.AutomaticSize.X,
					Font = v47.Font.Header2.Font,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0, 1),
					Text = v65,
					TextColor3 = v47.Theme.TextEmphasis.Color,
					TextSize = v47.Font.BaseSize * v47.Font.Header2.RelativeSize,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center
				})
			}),
			CapturesCarousel = React.createElement(CapturesCarousel, {
				LayoutOrder = 2,
				deleteItemSignal = v52.current,
				isDisabled = v53,
				maxHeight = v63,
				ZIndex = not FFlagUseMediaPlayerInCarousel and 1 or 2
			}),
			CTAContainer = React.createElement(CarouselCTAContainer, {
				height = 40,
				LayoutOrder = 3,
				deleteItem = v62,
				isDisabled = v53 or v51,
				openPermissionModal = v60,
				ZIndex = not FFlagUseMediaPlayerInCarousel and 2 or 1
			})
		}),
		DeleteWarningModal = React.createElement(DeleteWarningModal, {
			zIndex = 3,
			deleteItem = v62
		}),
		PermissionModal = React.createElement(PermissionModal, {
			zIndex = 3,
			closeModal = v61,
			visible = v55
		}),
		ToastsFrame = React.createElement("Frame", {
			Active = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = Constants.ZIndex.Toasts
		}, {
			ToastContainer = React.createElement(ToastContainer)
		})
	})
end
