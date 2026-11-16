local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Responsive = require(parent.Responsive)
local AppSplitView = require(parent.AppSplitView)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore

local SplitPaneEducationalTourSteps = require(script.Parent.SplitPaneEducationalTourSteps)
local getSplitPaneEducationalTourPresentation = require(script.Parent.getSplitPaneEducationalTourPresentation)
local useTrackedRect = require(script.Parent.useTrackedRect)
local getSplitPaneEducationalTourTooltipModel = require(script.Parent.getSplitPaneEducationalTourTooltipModel)
local useSplitPaneEducationalTourLifecycle = require(script.Parent.useSplitPaneEducationalTourLifecycle)
local SplitPaneEducationalTourView = require(script.Parent.SplitPaneEducationalTourView)

local FFlagDebugSplitPaneEducationalTourAutoStart = require(script.Parent.Parent.Flags.FFlagDebugSplitPaneEducationalTourAutoStart)

local FIntSplitPaneEducationalTourStartDelayMs = require(script.Parent.Parent.Flags.FIntSplitPaneEducationalTourStartDelayMs)

local FFlagSplitPaneEducationalTourPreloadVideos = require(script.Parent.Parent.Flags.FFlagSplitPaneEducationalTourPreloadVideos)
local useSplitPaneEducationalTourVideoPreload

if FFlagSplitPaneEducationalTourPreloadVideos then
	useSplitPaneEducationalTourVideoPreload = require(script.Parent.useSplitPaneEducationalTourVideoPreload)
else
	useSplitPaneEducationalTourVideoPreload = nil
end

local FFlagSplitPaneEducationalTourSkipOnDeepLink = require(script.Parent.Parent.Flags.FFlagSplitPaneEducationalTourSkipOnDeepLink)
local deepLinkLuaReceiverStatusStore

if FFlagSplitPaneEducationalTourSkipOnDeepLink then
	local DeepLink = require(parent.DeepLink)
	deepLinkLuaReceiverStatusStore = DeepLink.DeepLinkLuaReceiverStatusStore
else
	deepLinkLuaReceiverStatusStore = nil
end

local FStringSplitPaneEducationalTourKeepOnDeepLinkPatterns = require(script.Parent.Parent.Flags.FStringSplitPaneEducationalTourKeepOnDeepLinkPatterns)

local FFlagSplitPaneEducationalTourTelemetry = require(script.Parent.Parent.Flags.FFlagSplitPaneEducationalTourTelemetry)
local SplitPaneEducationalTourTelemetry

if FFlagSplitPaneEducationalTourTelemetry then
	SplitPaneEducationalTourTelemetry = require(script.Parent.Parent.Telemetry.SplitPaneEducationalTourTelemetry)
else
	SplitPaneEducationalTourTelemetry = nil
end

local isSplitPaneEducationalTourGuiObjectVisible = require(script.Parent.isSplitPaneEducationalTourGuiObjectVisible)
local getSplitPaneEducationalTourStore = require(script.Parent.Parent.Stores.getSplitPaneEducationalTourStore)
local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)

local Flags = Foundation.Utility.Flags
local useOverlay = Foundation.Hooks.useOverlay
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local Input = Responsive.Input
local usePreferredInput = Responsive.usePreferredInput
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local SupportPaneMode = AppSplitView.Enums.SupportPaneMode

local count = #SplitPaneEducationalTourSteps

local v = math.min(FIntSplitPaneEducationalTourStartDelayMs, 3000)
local holdsInputBeforeTooltip = v > 0

local function selectStatusBarHeight(p)
	return if p.TopBar == nil then 0 else p.TopBar.statusBarHeight
end

local function selectIsCentralOverlayOpen(p)
	local isCentralOverlayOpen

	if p.CentralOverlay == nil then
		isCentralOverlayOpen = false
	else
		isCentralOverlayOpen = p.CentralOverlay.OverlayType ~= nil
	end

	return isCentralOverlayOpen
end

local function useAnchorRef(current) -- 6 equivalent calls inferred from this helper
	return React.useMemo(function()
		if current == nil then
			return nil
		end

		return { current = current }
	end, { current })
end

local function SplitPaneEducationalTourBody(props)
	local supportPaneRef = props.supportPaneRef
	local supportPaneMode = props.supportPaneMode
	local isSupportPaneCollapsed = supportPaneMode == SupportPaneMode.Collapsed
	local isSupportSurfaceEligible = props.isSupportSurfaceEligible

	local tourStore = props.tourStore
	local store = SplitPaneStore.getStore()
	local stepIndex = props.stepIndex
	local shouldDefaultToCollapsed = useSignalState(store.getShouldDefaultToCollapsed)
	local collapsedExpandButtonRect = useSignalState(tourStore.getCollapsedExpandButtonRect)
	local collapsedExpandButton = useAnchorRef(useSignalState(tourStore.getCollapsedExpandButtonInstance)) -- inferred equivalent call

	local supportOverlayTopInset = useSelector(selectStatusBarHeight)
	local state, setState = React.useState(nil)

	local state2, setState2 = React.useState(nil)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local state5, setState5 = React.useState(nil)
	local bottomPane = useAnchorRef(state) -- inferred equivalent call
	local gamepadCollapsedStepOne = useAnchorRef(state2) -- inferred equivalent call
	local gamepadStepTwo = useAnchorRef(state3) -- inferred equivalent call
	local gamepadFinal = useAnchorRef(state4) -- inferred equivalent call
	local topRightControl = useAnchorRef(state5) -- inferred equivalent call
	local state6, setState6 = React.useState(nil)
	React.useLayoutEffect(function()
		local v2

		if supportPaneRef ~= nil then
			v2 = supportPaneRef.current
		end

		setState6(v2)
	end, { supportPaneRef })
	local supportPaneRect = useTrackedRect(state6)

	local guiObject = useOverlay()
	local v2

	if guiObject and guiObject:IsA("GuiObject") then
		v2 = guiObject
	end

	local v3 = useTrackedRect(v2)
	local min

	if v3 ~= nil then
		min = v3.Min
	end

	local tokens = useTokens()
	local localized = useLocalization({
		continueButton = "Feature.SplitPane.Tour.Button.Continue",
		finishTourButton = "Feature.SplitPane.Tour.Button.FinishTour",
		skipTourButton = "Feature.SplitPane.Tour.Button.SkipTour",
		stepOneCollapsedDescription = "Feature.SplitPane.Tour.Step1.Description.Collapsed",
		stepOneExpandedDescription = "Feature.SplitPane.Tour.Step1.Description.Expanded",
		stepOneTitle = "Feature.SplitPane.Tour.Step1.Title",
		stepTwoDescription = "Feature.SplitPane.Tour.Step2.Description",
		stepTwoTitle = "Feature.SplitPane.Tour.Step2.Title",
		stepThreeDescription = "Feature.SplitPane.Tour.Step3.Description",
		stepThreeTitle = "Feature.SplitPane.Tour.Step3.Title"
	})

	local mediaWidth = useScaledValue(Flags.FoundationEducationalTooltipRefresh and 280 or 320)

	local v4, v5 = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})))
	local setFocusSurfaceRef = React.useCallback(function(current)
		if typeof(v5) == "function" then
			v5(current)
		elseif v5 ~= nil then
			v5.current = current
		end
	end, { v5 })
	local v6 = ReactFocusNavigation.useFocusGuiObject()
	local v7 = usePreferredInput()
	local isDirectionalInput = v7 == Input.Directional
	local ref = React.useRef(nil)
	local state7, setState7 = React.useState(nil)
	local state8, setState8 = React.useState(false)
	local v8 = useFocusOnMount(v4)
	local setPrimaryActionRef = React.useCallback(function(current)
		ref.current = current
		v8(current)
	end, { v8 })
	local setTooltipContentRef = React.useCallback(function(p)
		setState7(p)
		setFocusSurfaceRef(p)
	end, { setFocusSurfaceRef })
	React.useLayoutEffect(function()
		if state7 == nil then
			setState8(false)
			return
		end

		local function updateVisibility() -- 2 equivalent calls inferred from this helper
			setState8(isSplitPaneEducationalTourGuiObjectVisible(state7))
		end

		updateVisibility() -- inferred equivalent call
		local connections = {}
		local function observeVisibleAncestors()
			for _, connection in connections do
				connection:Disconnect()
			end

			connections = {}
			local guiObject2 = state7

			while guiObject2 ~= nil do
				if guiObject2:IsA("GuiObject") then
					table.insert(connections, guiObject2:GetPropertyChangedSignal("Visible"):Connect(updateVisibility))
				end

				guiObject2 = guiObject2.Parent
			end

			updateVisibility() -- inferred equivalent call
		end
		observeVisibleAncestors()
		local ancestryChangedConnection = state7.AncestryChanged:Connect(observeVisibleAncestors)
		return function()
			ancestryChangedConnection:Disconnect()

			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { state7 })
	local overlayOrigin = min or Vector2.zero
	local splitPaneEducationalTourPresentation = getSplitPaneEducationalTourPresentation({
		stepIndex = stepIndex,
		isSupportPaneCollapsed = isSupportPaneCollapsed,
		isDirectionalInput = isDirectionalInput,
		collapsedExpandButtonRect = collapsedExpandButtonRect,
		supportPaneRect = supportPaneRect,
		anchors = {
			gamepadCollapsedStepOne = gamepadCollapsedStepOne,
			collapsedExpandButton = collapsedExpandButton,
			gamepadStepTwo = gamepadStepTwo,
			bottomPane = bottomPane,
			gamepadFinal = gamepadFinal,
			topRightControl = topRightControl,
			supportPane = supportPaneRef
		},
		collapsedSpotlightPadding = 4
	})

	local v9 = useSplitPaneEducationalTourLifecycle({
		isSupportSurfaceEligible = isSupportSurfaceEligible,
		stepIndex = stepIndex,
		totalSteps = count,
		supportPaneMode = supportPaneMode,
		shouldDefaultToCollapsed = shouldDefaultToCollapsed,
		isSupportPaneCollapsed = isSupportPaneCollapsed,
		tourStore = tourStore,
		splitPaneStore = store
	})

	local state9, setState9 = React.useState(not holdsInputBeforeTooltip)
	React.useEffect(function()
		if not holdsInputBeforeTooltip then
			return
		end

		local v10 = false
		task.delay(v / 1000, function()
			if not v10 then
				setState9(true)
			end
		end)
		return function()
			v10 = true
		end
	end, {})

	React.useEffect(function()
		if state8 or not state9 then
			return
		end

		local v10 = false
		task.delay(5, function()
			if not v10 then
				if FFlagSplitPaneEducationalTourTelemetry then
					SplitPaneEducationalTourTelemetry.logAbandoned(
						SplitPaneEducationalTourTelemetry.EndReason.TooltipHiddenTimeout,
						tourStore.getStepIndex(false),
						count,
						store.getSupportPaneMode(false) == SupportPaneMode.Collapsed
					)
				end

				v9.endTour()
			end
		end)
		return function()
			v10 = true
		end
	end, { state8, state9, v9.endTour, tourStore, store })
	React.useEffect(function()
		if ref.current ~= nil and (v7 == Input.Directional or GuiService.SelectedCoreObject ~= nil) then
			v6(ref.current)
		end
	end, { stepIndex, v7, v6, state9 })
	local splitPaneEducationalTourStep = SplitPaneEducationalTourSteps[stepIndex]
	local tooltipModel

	if state9 then
		tooltipModel = getSplitPaneEducationalTourTooltipModel({
			stepIndex = stepIndex,
			totalSteps = count,
			step = splitPaneEducationalTourStep,
			isCollapsedStepOne = splitPaneEducationalTourPresentation.isCollapsedStepOne,
			isDirectionalInput = isDirectionalInput,
			localized = localized
		})
	end

	local state10, setState10 = React.useState(false)
	React.useEffect(function()
		if state8 then
			setState10(true)
		end
	end, { state8 })

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if not ref2.current and splitPaneEducationalTourStep ~= nil and state7 ~= nil and state8 then
			ref2.current = true
			tourStore.notifyTourVisible()
		end
	end, { splitPaneEducationalTourStep, state7, state8, tourStore.notifyTourVisible })

	local ref3 = React.useRef(0)
	React.useEffect(function()
		if
			FFlagSplitPaneEducationalTourTelemetry
			and ref3.current ~= stepIndex
			and state8
			and state7 ~= nil
			and isSplitPaneEducationalTourGuiObjectVisible(state7)
		then
			ref3.current = stepIndex
			SplitPaneEducationalTourTelemetry.logStepShown(stepIndex, count, isSupportPaneCollapsed)
		end
	end, { state8, state7, stepIndex, isSupportPaneCollapsed })
	local onNext = React.useCallback(function()
		if FFlagSplitPaneEducationalTourTelemetry then
			SplitPaneEducationalTourTelemetry.logStepAdvanced(
				stepIndex,
				count,
				stepIndex == 1 and isSupportPaneCollapsed
			)
		end

		v9.handleNext()
	end, { v9.handleNext, stepIndex, isSupportPaneCollapsed })
	local v10

	if tooltipModel == nil then
		v10 = false
	else
		v10 = tooltipModel.isFinal
	end

	local onEnd = React.useCallback(function()
		if FFlagSplitPaneEducationalTourTelemetry then
			SplitPaneEducationalTourTelemetry.logUserEnded(
				v10,
				stepIndex,
				count,
				store.getSupportPaneMode(false) == SupportPaneMode.Collapsed
			)
		end

		v9.endTour()
	end, { v9.endTour, v10, stepIndex, store })

	local createElement = React.createElement
	local v11 = {
		isTooltipContentVisible = state8,
		hasPresentedTooltip = state10,
		holdsInputBeforeTooltip = holdsInputBeforeTooltip,
		supportPaneRect = supportPaneRect,
		overlayOrigin = overlayOrigin,
		overlayInstance = guiObject,
		supportOverlayTopInset = supportOverlayTopInset,
		presentation = splitPaneEducationalTourPresentation,
		tooltipModel = tooltipModel,
		tokens = tokens,
		mediaWidth = mediaWidth,
		videoAspectRatio = 1.5,
		setPrimaryActionRef = setPrimaryActionRef,
		setTooltipContentRef = setTooltipContentRef,
		setFocusSurfaceRef = setFocusSurfaceRef,
		setGamepadCollapsedTooltipAnchorInstance = setState2,
		setBottomPaneTooltipAnchorInstance = setState,
		setGamepadStepTwoTooltipAnchorInstance = setState3,
		setGamepadFinalTooltipAnchorInstance = setState4,
		setTopRightControlInstance = setState5,
		onNext = 0,
		onEnd = 0
	}

	if not FFlagSplitPaneEducationalTourTelemetry then
		onNext = v9.handleNext
	end

	v11.onNext = onNext

	if not FFlagSplitPaneEducationalTourTelemetry then
		onEnd = v9.endTour
	end

	v11.onEnd = onEnd
	return createElement(SplitPaneEducationalTourView, v11)
end

local v2 = {}

for _, v3 in string.split(FStringSplitPaneEducationalTourKeepOnDeepLinkPatterns, ",") do
	local v4 = string.match(v3, "^%s*(.-)%s*$")

	if v4 ~= nil and v4 ~= "" then
		table.insert(v2, v4)
	end
end

local function isKeepOnDeepLink(value: string): boolean
	local v3 = string.split(string.lower(value), "?")[1]

	for _, v4 in v2 do
		local success, result = pcall(string.find, v3, v4)

		if success and result ~= nil then
			return true
		end
	end

	return false
end

local function SplitPaneEducationalTour(props)
	local splitPaneEducationalTourStore = getSplitPaneEducationalTourStore(false)
	local stepIndex = useSignalState(splitPaneEducationalTourStore.getStepIndex)
	local v3 = useSignalState(splitPaneEducationalTourStore.getIsOpen)
	local v4 = useSignalState(splitPaneEducationalTourStore.getPendingUserId)
	local v5 = useSignalState(localUserIdStore.getCurrentUserId)
	local v6 = useSelector(selectIsCentralOverlayOpen)

	local isSupportSurfaceEligible = props.isSupportSurfaceEligible and not v6

	if FFlagSplitPaneEducationalTourPreloadVideos then
		useSplitPaneEducationalTourVideoPreload(v3 or FFlagDebugSplitPaneEducationalTourAutoStart)
	end

	local v7

	if FFlagSplitPaneEducationalTourSkipOnDeepLink then
		v7 = useSignalState(deepLinkLuaReceiverStatusStore(false).getLastDetectedPostAuthUrl)
	end

	local v8

	if v7 == nil or v7 == "" then
		v8 = false
	else
		v8 = not isKeepOnDeepLink(v7)
	end

	React.useEffect(function()
		if FFlagSplitPaneEducationalTourTelemetry and v3 and v4 == v5 then
			SplitPaneEducationalTourTelemetry.logDelivered(count)
		end
	end, { v3, v4, v5 })
	local ref = React.useRef(false)
	React.useEffect(function()
		if v3 and v4 ~= v5 then
			if FFlagSplitPaneEducationalTourTelemetry then
				local logAbandoned = SplitPaneEducationalTourTelemetry.logAbandoned
				local v9

				if v5 == "" then
					v9 = SplitPaneEducationalTourTelemetry.EndReason.HostUnmounted
				else
					v9 = SplitPaneEducationalTourTelemetry.EndReason.UserChanged
				end

				logAbandoned(
					v9,
					stepIndex,
					count,
					SplitPaneStore.getStore().getSupportPaneMode(false) == SupportPaneMode.Collapsed
				)
			end

			splitPaneEducationalTourStore.discardPendingTour()
		elseif v8 and not splitPaneEducationalTourStore.getHasShownTour(false) and (v3 or stepIndex > 0) then
			if FFlagSplitPaneEducationalTourTelemetry then
				SplitPaneEducationalTourTelemetry.logAbandoned(
					SplitPaneEducationalTourTelemetry.EndReason.DeepLink,
					stepIndex,
					count,
					SplitPaneStore.getStore().getSupportPaneMode(false) == SupportPaneMode.Collapsed
				)
			end

			splitPaneEducationalTourStore.discardPendingTour()
		else
			if v3 and stepIndex == 0 then
				ref.current = false
			end

			if v3 and isSupportSurfaceEligible and not ref.current then
				ref.current = true
				splitPaneEducationalTourStore.setStepIndex(1)
			end

			if not v3 then
				ref.current = false
			end
		end
	end, {
		v3,
		v4,
		v5,
		stepIndex,
		isSupportSurfaceEligible,
		v8,
		splitPaneEducationalTourStore.getHasShownTour,
		splitPaneEducationalTourStore.setStepIndex,
		splitPaneEducationalTourStore.discardPendingTour
	})

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if FFlagDebugSplitPaneEducationalTourAutoStart and isSupportSurfaceEligible and not (v8 or ref2.current) then
			ref2.current = true
			splitPaneEducationalTourStore.setStepIndex(1)
		end
	end, { isSupportSurfaceEligible, v8, splitPaneEducationalTourStore.setStepIndex })

	React.useEffect(function()
		return function()
			if FFlagSplitPaneEducationalTourTelemetry then
				local store = SplitPaneStore.getStore()

				local logAbandoned = SplitPaneEducationalTourTelemetry.logAbandoned
				local v9

				if store.getIsBreakpointEnabled(false) then
					v9 = SplitPaneEducationalTourTelemetry.EndReason.HostUnmounted
				else
					v9 = SplitPaneEducationalTourTelemetry.EndReason.BreakpointLost
				end

				logAbandoned(
					v9,
					splitPaneEducationalTourStore.getStepIndex(false),
					count,
					store.getSupportPaneMode(false) == SupportPaneMode.Collapsed
				)
			end

			splitPaneEducationalTourStore.discardPendingTour()
		end
	end, { splitPaneEducationalTourStore.discardPendingTour, splitPaneEducationalTourStore.getStepIndex })

	if stepIndex == 0 then
		return nil
	end

	return React.createElement(SplitPaneEducationalTourBody, {
		supportPaneRef = props.supportPaneRef,
		supportPaneMode = props.supportPaneMode,
		isSupportSurfaceEligible = isSupportSurfaceEligible,
		tourStore = splitPaneEducationalTourStore,
		stepIndex = stepIndex
	})
end

return SplitPaneEducationalTour
