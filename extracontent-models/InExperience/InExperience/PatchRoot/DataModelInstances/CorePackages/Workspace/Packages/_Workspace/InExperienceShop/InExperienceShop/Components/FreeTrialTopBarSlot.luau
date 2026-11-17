local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local TopBarChip = require(InExperienceShop.Components.TopBarChip)
local submitFreeTrialTopBarChip = require(InExperienceShop.submitFreeTrialTopBarChip)
local FFlagEnableFreeTrialChipReveal = require(InExperienceShop.Flags.FFlagEnableFreeTrialChipReveal)
local FFlagFreeTrialChipBuyAnimation = require(InExperienceShop.Flags.FFlagFreeTrialChipBuyAnimation)
local getCloseButtonPosition = require(script.Parent.getCloseButtonPosition)
local useFreeTrialChipDismiss = require(script.Parent.useFreeTrialChipDismiss)
local useFreeTrialChipReveal

if FFlagEnableFreeTrialChipReveal then
	useFreeTrialChipReveal = require(script.Parent.useFreeTrialChipReveal)
else
	useFreeTrialChipReveal = nil
end

game:DefineFastInt("FreeTrialChipTopBarRightPadding", 100)

local function readHostShown(hostVisible)
	if typeof(hostVisible) == "boolean" then
		return hostVisible
	end

	if hostVisible == nil then
		return true
	end

	return hostVisible:getValue()
end

local function assignRef(callback, current) -- 1 equivalent call inferred from this helper
	if type(callback) == "function" then
		callback(current)
	elseif callback ~= nil then
		callback.current = current
	end
end

local function FreeTrialChipRevealFrame(props)
	local v = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = false
	})

	local ref = React.useCallback(function(current)
		props.revealRef.current = current
		assignRef(v, current) -- inferred equivalent call
	end, { props.revealRef, v })

	local maxWidth = props.maxWidth
	local createElement = React.createElement
	local automaticSize

	if maxWidth == nil then
		automaticSize = Enum.AutomaticSize.XY
	else
		automaticSize = Enum.AutomaticSize.Y
	end

	local v2 = {
		AutomaticSize = automaticSize,
		BackgroundTransparency = 1,
		ClipsDescendants = maxWidth ~= nil,
		Position = UDim2.fromScale(1, 0),
		ref = ref,
		Size = 0,
		Visible = 0,
		ZIndex = 100
	}
	local size

	if maxWidth == nil then
		size = UDim2.fromScale(0, 0)
	else
		size = UDim2.fromOffset(maxWidth, 0)
	end

	v2.Size = size

	v2.Visible = props.hostShown
	return createElement("Frame", v2, { Chip = props.chip })
end

local function FreeTrialChipRevealPortal(props)
	local v = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	React.useEffect(function()
		return function()
			v:teardown()
		end
	end, { v })

	return React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, { value = v }, {
		Registry = React.createElement(Provider, nil, {
			Reveal = ReactRoblox.createPortal({
				FreeTrialChipReveal = React.createElement(FreeTrialChipRevealFrame, {
					revealRef = props.revealRef,
					chip = props.chip,
					maxWidth = props.maxWidth,
					hostShown = props.hostShown
				})
			}, props.revealLayer)
		})
	})
end

local function FreeTrialTopBarSlot(props)
	local useSignalState = SignalsReact.useSignalState
	local v

	if FFlagFreeTrialChipBuyAnimation then
		v = submitFreeTrialTopBarChip.isPresented
	else
		v = submitFreeTrialTopBarChip.isShowing
	end

	local isVisible = useSignalState(v)

	local v2 = SignalsReact.useSignalState(submitFreeTrialTopBarChip.image)
	local v3 = SignalsReact.useSignalState(submitFreeTrialTopBarChip.textKey)
	local isEmphasis = SignalsReact.useSignalState(submitFreeTrialTopBarChip.isEmphasis)

	if props.isEmphasis ~= nil then
		isEmphasis = props.isEmphasis
	end

	local v4 = useLocalization({ label = v3 })

	local hostVisible = props.hostVisible
	local state, setState = React.useState(readHostShown(hostVisible))

	local ref = React.useRef(hostVisible)
	ref.current = hostVisible

	React.useEffect(function()
		if typeof(hostVisible) == "boolean" or hostVisible == nil then
			setState(readHostShown(hostVisible))
			return function() end
		end

		local function applyVisible(flag: boolean) -- 1 equivalent call inferred from this helper
			setState(flag)
		end
		applyVisible(hostVisible:getValue()) -- inferred equivalent call
		return React.__subscribeToBinding(hostVisible, applyVisible)
	end, { hostVisible })
	local ref2 = React.useRef(nil)
	local v5

	if FFlagFreeTrialChipBuyAnimation then
		v5 = SignalsReact.useSignalState(submitFreeTrialTopBarChip.handle)
	end

	local v6

	if FFlagEnableFreeTrialChipReveal then
		local v7

		if FFlagFreeTrialChipBuyAnimation then
			v7 = v5
		end

		v6 = useFreeTrialChipReveal(isVisible, v7)
	else
		v6 = nil
	end

	local v7 = {
		isVisible = isVisible,
		isSettled = not FFlagEnableFreeTrialChipReveal or v6 == nil or v6.isSettled,
		revealLayer = 0,
		chipRef = 0
	}
	local revealLayer

	if FFlagEnableFreeTrialChipReveal and v6 ~= nil then
		revealLayer = v6.revealLayer
	end

	v7.revealLayer = revealLayer
	v7.chipRef = ref2
	local v8 = useFreeTrialChipDismiss(v7)

	local fastInt = game:GetFastInt("FreeTrialChipTopBarRightPadding")
	local maxWidth = props.maxWidth

	local state2, setState2 = React.useState(0)
	local ref3 = React.useRef(0)
	local ref4 = React.useRef(v3)
	local ref5 = React.useRef(fastInt)

	if ref4.current ~= v3 or ref5.current ~= fastInt then
		ref4.current = v3
		ref5.current = fastInt

		if ref3.current ~= 0 then
			ref3.current = 0
			setState2(0)
		end
	end

	local function onSlotAbsoluteSizeChanged(current)
		if maxWidth == nil then
			return
		end

		if v6 ~= nil then
			if FFlagFreeTrialChipBuyAnimation and not v6.revealSizeIsOwnRef.current then
				return
			end

			local current2 = v6.placeholderRef.current
			local absoluteSize

			if current2 ~= nil then
				absoluteSize = current2.AbsoluteSize
			end

			if absoluteSize ~= nil and (absoluteSize.X <= 0 or absoluteSize.Y <= 0) then
				return
			end
		end

		local x = current.AbsoluteSize.X
		local current2 = ref3.current

		if x <= 0 or x == current2 or current2 > 0 and x < current2 and x <= maxWidth then
			return
		end

		ref3.current = x
		setState2(x)
	end

	React.useEffect(function()
		submitFreeTrialTopBarChip()
	end, { submitFreeTrialTopBarChip })
	local function reportMountedAndViewed()
		if not isVisible then
			return
		end

		submitFreeTrialTopBarChip.reportMounted()

		if state then
			local v9 = ref.current

			if typeof(v9) ~= "boolean" then
				v9 = v9 == nil or v9:getValue()
			end

			if v9 then
				submitFreeTrialTopBarChip.reportViewed()
			end
		end
	end

	if FFlagFreeTrialChipBuyAnimation then
		React.useEffect(reportMountedAndViewed, { isVisible, v3, v5, state })
	else
		React.useEffect(reportMountedAndViewed, { isVisible, v3, state })
	end

	if FFlagFreeTrialChipBuyAnimation then
		local v9

		if FFlagEnableFreeTrialChipReveal and v6 ~= nil then
			v9 = v6.isSettled
		else
			v9 = false
		end

		local sampleOnSettleRef

		if v6 == nil then
			sampleOnSettleRef = nil
		else
			sampleOnSettleRef = v6.sampleOnSettleRef
		end

		local slotRef

		if v6 == nil then
			slotRef = nil
		else
			slotRef = v6.slotRef
		end

		React.useLayoutEffect(function()
			if not v9 or maxWidth == nil or sampleOnSettleRef == nil or not sampleOnSettleRef.current then
				return
			end

			sampleOnSettleRef.current = false

			if ref3.current ~= 0 or slotRef == nil then
				return
			end

			local current = slotRef.current

			if current ~= nil then
				onSlotAbsoluteSizeChanged(current)
			end
		end, { v9, maxWidth, sampleOnSettleRef, slotRef })
	end

	local function onChipActivated()
		if v8.consumeSuppressedActivation() then
			return
		end

		if submitFreeTrialTopBarChip.promptsPurchase(false) then
			submitFreeTrialTopBarChip.promptPurchase()
			return
		end

		submitFreeTrialTopBarChip.reportActivated()

		if props.onActivated ~= nil then
			props.onActivated()
		end
	end

	if not isVisible then
		return nil
	end

	local v9

	if maxWidth == nil or not (state2 > 0) then
		v9 = false
	else
		v9 = maxWidth < state2
	end

	local v10 = v9 and 0 or fastInt

	if v9 then
		state2 = math.max(0, state2 - fastInt)
	end

	local autoyclip

	if maxWidth == nil then
		autoyclip = false
	else
		autoyclip = maxWidth < state2
	end

	local maxWidth2

	if autoyclip then
		maxWidth2 = maxWidth
	end

	local createElement = React.createElement
	local v11 = {
		text = v4.label,
		image = v2 or "",
		chipRef = ref2,
		onActivated = onChipActivated,
		onStateChanged = 0,
		isEmphasis = 0,
		testId = "FreeTrialTopBarSlot",
		maxWidth = 0
	}
	local onStateChanged

	if v8.pointerDismiss then
		onStateChanged = v8.onChipStateChanged
	end

	v11.onStateChanged = onStateChanged
	v11.isEmphasis = isEmphasis

	v11.maxWidth = maxWidth2
	local element = createElement(TopBarChip, v11)

	local v12 = v8.pointerDismiss and v8.hovered

	if FFlagEnableFreeTrialChipReveal and v6 ~= nil then
		v12 = v12 and v6.isSettled
	end

	local close

	if v12 then
		close = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -v10, 1, 0),
			ZIndex = 2
		}, {
			Button = React.createElement(View, {
				Position = getCloseButtonPosition(),
				onActivated = v8.onCloseActivated,
				onStateChanged = v8.onCloseStateChanged,
				tag = "align-x-center align-y-center anchor-top-right size-500 radius-circle bg-surface-0",
				testId = "FreeTrialTopBarSlot--close"
			}, {
				Icon = React.createElement(Icon, { name = "x", size = IconSize.XSmall })
			})
		})
	end

	local v13 = {
		tag = {
			["auto-y clip"] = autoyclip,
			["auto-xy"] = not autoyclip
		},
		LayoutOrder = props.LayoutOrder,
		ZIndex = 100,
		padding = v10 > 0 and { right = UDim.new(0, v10) } or nil,
		onAbsoluteSizeChanged = 0,
		Size = 0,
		sizeConstraint = 0,
		ref = nil,
		testId = nil
	}
	local onAbsoluteSizeChanged

	if maxWidth ~= nil then
		onAbsoluteSizeChanged = onSlotAbsoluteSizeChanged
	end

	v13.onAbsoluteSizeChanged = onAbsoluteSizeChanged
	local size

	if autoyclip then
		size = UDim2.fromOffset(maxWidth, 0)
	end

	v13.Size = size
	v13.sizeConstraint = autoyclip and { MaxSize = Vector2.new(maxWidth, 1e999) } or nil

	if not FFlagEnableFreeTrialChipReveal or v6 == nil then
		return React.createElement(View, v13, { Chip = element, Close = close })
	end

	v13.ref = v6.slotRef
	v13.testId = "FreeTrialTopBarSlot--slot"
	local createElement2 = React.createElement
	local slideContainer

	if v6.isSettled then
		slideContainer = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 0)
			},
			{
				Slide = React.createElement(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(0, 0)
					},
					{ Chip = element }
				)
			}
		)
	else
		local createElement3 = React.createElement
		local v14 = { BackgroundTransparency = 1, ref = v6.placeholderRef, Size = 0 }
		local size2

		if v6.revealChipSize == nil then
			size2 = UDim2.fromScale(0, 0)
		else
			size2 = UDim2.fromOffset(v6.revealChipSize.X, v6.revealChipSize.Y)
		end

		v14.Size = size2
		slideContainer = createElement3("Frame", v14)
	end

	local reveal

	if not (v6.isSettled or v6.revealLayer == nil) then
		reveal = React.createElement(FreeTrialChipRevealPortal, {
			revealLayer = v6.revealLayer,
			revealRef = v6.revealRef,
			chip = element,
			maxWidth = maxWidth2,
			hostShown = props.hostVisible == nil or props.hostVisible
		})
	end

	return createElement2(View, v13, {
		SlideContainer = slideContainer,
		Reveal = reveal,
		Close = close
	})
end

return FreeTrialTopBarSlot
