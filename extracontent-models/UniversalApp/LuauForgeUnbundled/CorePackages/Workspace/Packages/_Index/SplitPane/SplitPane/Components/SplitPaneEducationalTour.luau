local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/FocusNavigationUtils")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/ReactFocusNavigation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Responsive")
local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Localization").Hooks.useLocalization
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SignalsReact").useSignalState
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RoactUtils").Hooks.RoactRodux.useSelector
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/LocalUserIdStore").LocalUserIdStore

local SplitPaneEducationalTourSteps = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourSteps")
local getSplitPaneEducationalTourPresentation = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/getSplitPaneEducationalTourPresentation")
local useTrackedRect = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/useTrackedRect")
local getSplitPaneEducationalTourTooltipModel = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/getSplitPaneEducationalTourTooltipModel")
local useSplitPaneEducationalTourLifecycle = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/useSplitPaneEducationalTourLifecycle")
local SplitPaneEducationalTourView = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourView")

local FFlagDebugSplitPaneEducationalTourAutoStart = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/FFlagDebugSplitPaneEducationalTourAutoStart")

local FIntSplitPaneEducationalTourStartDelayMs = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/FIntSplitPaneEducationalTourStartDelayMs")

local FFlagSplitPaneEducationalTourPreloadVideos = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/FFlagSplitPaneEducationalTourPreloadVideos")

local v5 = if FFlagSplitPaneEducationalTourPreloadVideos then require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/useSplitPaneEducationalTourVideoPreload") else nil

local FFlagSplitPaneEducationalTourSkipOnDeepLink = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/FFlagSplitPaneEducationalTourSkipOnDeepLink")

local deepLinkLuaReceiverStatusStore = if FFlagSplitPaneEducationalTourSkipOnDeepLink then require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/DeepLink").DeepLinkLuaReceiverStatusStore else nil

local FStringSplitPaneEducationalTourKeepOnDeepLinkPatterns = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/FStringSplitPaneEducationalTourKeepOnDeepLinkPatterns")

local FFlagSplitPaneEducationalTourTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/FFlagSplitPaneEducationalTourTelemetry")

local v6 = if FFlagSplitPaneEducationalTourTelemetry then require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/SplitPaneEducationalTourTelemetry") else nil

local isSplitPaneEducationalTourGuiObjectVisible = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/isSplitPaneEducationalTourGuiObjectVisible")
local getSplitPaneEducationalTourStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/getSplitPaneEducationalTourStore")
local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")

local flags = Foundation.Utility.Flags
local useOverlay = Foundation.Hooks.useOverlay
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local input = Responsive.Input
local usePreferredInput = Responsive.usePreferredInput
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local supportPaneMode = AppSplitView.Enums.SupportPaneMode

local count = #SplitPaneEducationalTourSteps

local v7 = math.min(FIntSplitPaneEducationalTourStartDelayMs, 3000)
local v8 = v7 > 0

local function selectStatusBarHeight(p2)
	if p2.TopBar == nil then
		return 0
	end

	return p2.TopBar.statusBarHeight
end

local function selectIsCentralOverlayOpen(p2)
	local isCentralOverlayOpen = not (p2.CentralOverlay == nil) and p2.CentralOverlay.OverlayType ~= nil
	return isCentralOverlayOpen
end

local function useAnchorRef(p2)
	return React.useMemo(function()
		if p2 == nil then
			return nil
		end

		return { current = p2 }
	end, { p2 })
end

local function SplitPaneEducationalTourBody(props)
	local supportPaneRef = props.supportPaneRef
	local supportPaneMode2 = props.supportPaneMode
	local v9 = supportPaneMode2 == supportPaneMode.Collapsed
	local isSupportSurfaceEligible = props.isSupportSurfaceEligible

	local tourStore = props.tourStore
	local store = SplitPaneStore.getStore()
	local stepIndex = props.stepIndex
	local v10 = useSignalState(store.getShouldDefaultToCollapsed)
	local v11 = useSignalState(tourStore.getCollapsedExpandButtonRect)
	local v12 = useSignalState(tourStore.getCollapsedExpandButtonInstance)
	local v13 = React.useMemo(function()
		if v12 == nil then
			return nil
		end

		return { current = v12 }
	end, { v12 })

	local v14 = useSelector(selectStatusBarHeight)
	local state, setState = React.useState(nil)

	local state2, setState2 = React.useState(nil)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local state5, setState5 = React.useState(nil)
	local v15 = React.useMemo(function()
		if state == nil then
			return nil
		end

		return { current = state }
	end, { state })
	local v16 = React.useMemo(function()
		if state2 == nil then
			return nil
		end

		return { current = state2 }
	end, { state2 })
	local v17 = React.useMemo(function()
		if state3 == nil then
			return nil
		end

		return { current = state3 }
	end, { state3 })
	local v18 = React.useMemo(function()
		if state4 == nil then
			return nil
		end

		return { current = state4 }
	end, { state4 })
	local v19 = React.useMemo(function()
		if state5 == nil then
			return nil
		end

		return { current = state5 }
	end, { state5 })

	local state6, setState6 = React.useState(nil)
	React.useLayoutEffect(function()
		local v21 = if supportPaneRef ~= nil then supportPaneRef.current else nil
		setState6(v21)
	end, { supportPaneRef })
	local v20 = useTrackedRect(state6)

	local guiObject = useOverlay()

	local v22 = if guiObject and guiObject:IsA("GuiObject") then guiObject else nil
	local v23 = useTrackedRect(v22)
	local min = if v23 ~= nil then v23.Min else nil
	local v24 = useTokens()
	local v25 = useLocalization({
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

	local v26 = useScaledValue(flags.FoundationEducationalTooltipRefresh and 280 or 320)

	local v28, v29 = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})))
	local v30 = React.useCallback(function(current)
		if typeof(v29) == "function" then
			v29(current)
		elseif v29 ~= nil then
			v29.current = current
		end
	end, { v29 })
	local v31 = ReactFocusNavigation.useFocusGuiObject()
	local v32 = usePreferredInput()
	local v33 = v32 == input.Directional
	local ref = React.useRef(nil)
	local state7, setState7 = React.useState(nil)
	local state8, setState8 = React.useState(false)
	local v34 = useFocusOnMount(v28)
	local v35 = React.useCallback(function(current)
		ref.current = current
		v34(current)
	end, { v34 })
	local v36 = React.useCallback(function(p2)
		setState7(p2)
		v30(p2)
	end, { v30 })
	React.useLayoutEffect(function()
		if state7 == nil then
			setState8(false)
			return
		end

		local function updateVisibility()
			setState8(isSplitPaneEducationalTourGuiObjectVisible(state7))
		end

		setState8(isSplitPaneEducationalTourGuiObjectVisible(state7))

		local connections = {}
		local function observeVisibleAncestors()
			for k, connection in connections do
				connection:Disconnect()
			end

			connections = {}
			local guiObject2 = state7

			while guiObject2 ~= nil do
				if guiObject2:IsA("GuiObject") then
					table.insert(
						connections,
						guiObject2:GetPropertyChangedSignal("Visible"):Connect(updateVisibility)
					)
				end

				guiObject2 = guiObject2.Parent
			end

			setState8(isSplitPaneEducationalTourGuiObjectVisible(state7))
		end
		observeVisibleAncestors()
		local ancestryChangedConnection = state7.AncestryChanged:Connect(observeVisibleAncestors)
		return function()
			ancestryChangedConnection:Disconnect()

			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { state7 })
	local v37 = min or Vector2.zero
	local v38 = getSplitPaneEducationalTourPresentation({
		stepIndex = stepIndex,
		isSupportPaneCollapsed = v9,
		isDirectionalInput = v33,
		collapsedExpandButtonRect = v11,
		supportPaneRect = v20,
		anchors = {
			gamepadCollapsedStepOne = v16,
			collapsedExpandButton = v13,
			gamepadStepTwo = v17,
			bottomPane = v15,
			gamepadFinal = v18,
			topRightControl = v19,
			supportPane = supportPaneRef
		},
		collapsedSpotlightPadding = 4
	})

	local v39 = useSplitPaneEducationalTourLifecycle({
		isSupportSurfaceEligible = isSupportSurfaceEligible,
		stepIndex = stepIndex,
		totalSteps = count,
		supportPaneMode = supportPaneMode2,
		shouldDefaultToCollapsed = v10,
		isSupportPaneCollapsed = v9,
		tourStore = tourStore,
		splitPaneStore = store
	})

	local state9, setState9 = React.useState(not v8)
	React.useEffect(function()
		if not v8 then
			return
		end

		local v40 = false
		task.delay(v7 / 1000, function()
			if not v40 then
				setState9(true)
			end
		end)
		return function()
			v40 = true
		end
	end, {})

	React.useEffect(function()
		if state8 or not state9 then
			return
		end

		local v40 = false
		task.delay(5, function()
			if not v40 then
				if FFlagSplitPaneEducationalTourTelemetry then
					v6.logAbandoned(
						v6.EndReason.TooltipHiddenTimeout,
						tourStore.getStepIndex(false),
						count,
						store.getSupportPaneMode(false) == supportPaneMode.Collapsed
					)
				end

				v39.endTour()
			end
		end)
		return function()
			v40 = true
		end
	end, { state8, state9, v39.endTour, tourStore, store })
	React.useEffect(function()
		if ref.current ~= nil and (v32 == input.Directional or GuiService.SelectedCoreObject ~= nil) then
			v31(ref.current)
		end
	end, { stepIndex, v32, v31, state9 })
	local v40 = SplitPaneEducationalTourSteps[stepIndex]
	local v41

	if state9 then
		v41 = getSplitPaneEducationalTourTooltipModel({
			stepIndex = stepIndex,
			totalSteps = count,
			step = v40,
			isCollapsedStepOne = v38.isCollapsedStepOne,
			isDirectionalInput = v33,
			localized = v25
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
		if not ref2.current and v40 ~= nil and state7 ~= nil and state8 then
			ref2.current = true
			tourStore.notifyTourVisible()
		end
	end, { v40, state7, state8, tourStore.notifyTourVisible })

	local ref3 = React.useRef(0)
	React.useEffect(function()
		if FFlagSplitPaneEducationalTourTelemetry and ref3.current ~= stepIndex and state8 and state7 ~= nil and isSplitPaneEducationalTourGuiObjectVisible(state7) then
			ref3.current = stepIndex
			v6.logStepShown(stepIndex, count, v9)
		end
	end, { state8, state7, stepIndex, v9 })
	local v42 = React.useCallback(function()
		if FFlagSplitPaneEducationalTourTelemetry then
			v6.logStepAdvanced(stepIndex, count, stepIndex == 1 and v9)
		end

		v39.handleNext()
	end, { v39.handleNext, stepIndex, v9 })
	local v43 = not (v41 == nil) and v41.isFinal
	local v44 = React.useCallback(function()
		if FFlagSplitPaneEducationalTourTelemetry then
			v6.logUserEnded(
				v43,
				stepIndex,
				count,
				store.getSupportPaneMode(false) == supportPaneMode.Collapsed
			)
		end

		v39.endTour()
	end, { v39.endTour, v43, stepIndex, store })

	local createElement = React.createElement
	local v46 = {
		isTooltipContentVisible = state8,
		hasPresentedTooltip = state10,
		holdsInputBeforeTooltip = v8,
		supportPaneRect = v20,
		overlayOrigin = v37,
		overlayInstance = guiObject,
		supportOverlayTopInset = v14,
		presentation = v38,
		tooltipModel = v41,
		tokens = v24,
		mediaWidth = v26,
		videoAspectRatio = 1.5,
		setPrimaryActionRef = v35,
		setTooltipContentRef = v36,
		setFocusSurfaceRef = v30,
		setGamepadCollapsedTooltipAnchorInstance = setState2,
		setBottomPaneTooltipAnchorInstance = setState,
		setGamepadStepTwoTooltipAnchorInstance = setState3,
		setGamepadFinalTooltipAnchorInstance = setState4,
		setTopRightControlInstance = setState5,
		onNext = 0,
		onEnd = 0
	}

	if not FFlagSplitPaneEducationalTourTelemetry then
		v42 = v39.handleNext
	end

	v46.onNext = v42

	if not FFlagSplitPaneEducationalTourTelemetry then
		v44 = v39.endTour
	end

	v46.onEnd = v44
	return createElement(SplitPaneEducationalTourView, v46)
end

local v9 = {}

for k, v10 in string.split(FStringSplitPaneEducationalTourKeepOnDeepLinkPatterns, ",") do
	local v11 = string.match(v10, "^%s*(.-)%s*$")

	if v11 ~= nil and v11 ~= "" then
		table.insert(v9, v11)
	end
end

local function isKeepOnDeepLink(value): boolean
	local v10 = string.split(string.lower(value), "?")[1]

	for k, v11 in v9 do
		local success, result = pcall(string.find, v10, v11)

		if success and result ~= nil then
			return true
		end
	end

	return false
end

local function SplitPaneEducationalTour(props)
	local v10 = getSplitPaneEducationalTourStore(false)
	local v11 = useSignalState(v10.getStepIndex)
	local v12 = useSignalState(v10.getIsOpen)
	local v13 = useSignalState(v10.getPendingUserId)
	local v14 = useSignalState(localUserIdStore.getCurrentUserId)
	local v15 = useSelector(selectIsCentralOverlayOpen)

	local v16 = props.isSupportSurfaceEligible and not v15

	if FFlagSplitPaneEducationalTourPreloadVideos then
		v5(v12 or FFlagDebugSplitPaneEducationalTourAutoStart)
	end

	local v17

	if FFlagSplitPaneEducationalTourSkipOnDeepLink then
		v17 = useSignalState(deepLinkLuaReceiverStatusStore(false).getLastDetectedPostAuthUrl)
	end

	local v18 = not (v17 == nil or v17 == "") and not isKeepOnDeepLink(v17)
	React.useEffect(function()
		if FFlagSplitPaneEducationalTourTelemetry and v12 and v13 == v14 then
			v6.logDelivered(count)
		end
	end, { v12, v13, v14 })
	local ref = React.useRef(false)
	React.useEffect(function()
		if v12 and v13 ~= v14 then
			if FFlagSplitPaneEducationalTourTelemetry then
				local logAbandoned = v6.logAbandoned

				local v19 = if v14 == "" then v6.EndReason.HostUnmounted else v6.EndReason.UserChanged
				logAbandoned(
					v19,
					v11,
					count,
					SplitPaneStore.getStore().getSupportPaneMode(false) == supportPaneMode.Collapsed
				)
			end

			v10.discardPendingTour()
		elseif v18 and not v10.getHasShownTour(false) and (v12 or v11 > 0) then
			if FFlagSplitPaneEducationalTourTelemetry then
				v6.logAbandoned(
					v6.EndReason.DeepLink,
					v11,
					count,
					SplitPaneStore.getStore().getSupportPaneMode(false) == supportPaneMode.Collapsed
				)
			end

			v10.discardPendingTour()
		else
			if v12 and v11 == 0 then
				ref.current = false
			end

			if v12 and v16 and not ref.current then
				ref.current = true
				v10.setStepIndex(1)
			end

			if not v12 then
				ref.current = false
			end
		end
	end, {
		v12,
		v13,
		v14,
		v11,
		v16,
		v18,
		v10.getHasShownTour,
		v10.setStepIndex,
		v10.discardPendingTour
	})

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if FFlagDebugSplitPaneEducationalTourAutoStart and v16 and not (v18 or ref2.current) then
			ref2.current = true
			v10.setStepIndex(1)
		end
	end, { v16, v18, v10.setStepIndex })

	React.useEffect(function()
		return function()
			if FFlagSplitPaneEducationalTourTelemetry then
				local store = SplitPaneStore.getStore()

				local logAbandoned = v6.logAbandoned
				local v19 = if store.getIsBreakpointEnabled(false) then v6.EndReason.HostUnmounted else v6.EndReason.BreakpointLost
				logAbandoned(
					v19,
					v10.getStepIndex(false),
					count,
					store.getSupportPaneMode(false) == supportPaneMode.Collapsed
				)
			end

			v10.discardPendingTour()
		end
	end, { v10.discardPendingTour, v10.getStepIndex })

	if v11 == 0 then
		return nil
	end

	return React.createElement(SplitPaneEducationalTourBody, {
		supportPaneRef = props.supportPaneRef,
		supportPaneMode = props.supportPaneMode,
		isSupportSurfaceEligible = v16,
		tourStore = v10,
		stepIndex = v11
	})
end

return SplitPaneEducationalTour
