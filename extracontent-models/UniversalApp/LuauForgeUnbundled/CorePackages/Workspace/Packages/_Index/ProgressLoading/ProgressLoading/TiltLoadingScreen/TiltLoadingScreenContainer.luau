local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization")
local InExperienceLocales = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/InExperienceLocales")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Responsive")
local useDeviceInsets = Responsive.useDeviceInsets
local usePreferredInput = Responsive.usePreferredInput
local getBuilderIconForKeycode = module2.Utility.getBuilderIconForKeycode

local TiltLoadingScreenContent = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/TiltLoadingScreenContent")
local useExperienceLoadingLifecycle = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Hooks/useExperienceLoadingLifecycle")
local useDeferredLoadingLifecycle = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Hooks/useDeferredLoadingLifecycle")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Constants")
local fFlagEnableTiltLoadingScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagEnableTiltLoadingScreen
local fFlagIncreaseLoadingScreenOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagIncreaseLoadingScreenOrder
local fFlagTiltLoadingScreenConsoleHints = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagTiltLoadingScreenConsoleHints
local fFlagTiltLoadingScreenEnterExitHold = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagTiltLoadingScreenEnterExitHold
local fFlagTiltLoadingScreenDismissOnLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagTiltLoadingScreenDismissOnLoaded
local isPioneerLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/PioneerUtils").isPioneerLaunch

local ContextActionService = game:GetService("ContextActionService")
local LocalizationService = game:GetService("LocalizationService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")

local function TiltLoadingScreenContainer(props)
	if not fFlagEnableTiltLoadingScreen then
		return nil
	end

	local v5 = props.deferredJoin ~= nil
	local v6 = useExperienceLoadingLifecycle(not v5, props.milestones, props.onDismissComplete)

	local v8 = if props.deferredJoin then props.deferredJoin.assetService else nil
	local v9, v10 = useDeferredLoadingLifecycle(v5, v8, props.onCancel)

	local reducedMotion = UserGameSettings.ReducedMotion
	local ref = React.useRef(props.onCancel)

	if not v5 then
		v10 = props.onCancel
	end

	ref.current = v10
	local v11 = if fFlagTiltLoadingScreenConsoleHints then usePreferredInput() else nil
	local v12 = fFlagTiltLoadingScreenConsoleHints and v11 == Responsive.Input.Directional
	local v13 = if v12 then getBuilderIconForKeycode(Enum.KeyCode.ButtonB) else nil
	local v14 = useDeviceInsets()
	local v15 = React.useMemo(function()
		return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	local v16 = (not fFlagTiltLoadingScreenDismissOnLoaded or v6.isVisible) and true or false

	React.useEffect(function()
		if not v16 or isPioneerLaunch() then
			return
		end

		local contextActionService = props.contextActionService or ContextActionService
		local v17 = false
		contextActionService:BindCoreAction("CancelGameLoad", function(p2, p3)
			if p3 == Enum.UserInputState.Begin then
				v17 = true
			elseif p3 == Enum.UserInputState.End and v17 then
				v17 = false

				if ref.current then
					ref.current(false, true)
				end
			end
		end, false, Enum.KeyCode.ButtonB)

		return function()
			contextActionService:UnbindCoreAction("CancelGameLoad")
		end
	end, { props.contextActionService, v16 })
	local v17 = React.useMemo(function()
		return { reducedMotion = reducedMotion }
	end, { reducedMotion })
	local v18 = React.useCallback(function()
		if ref.current then
			ref.current(true)
		end
	end, {})

	if not v6.isVisible then
		return nil
	end

	local v19

	if props.deferredJoin then
		v19 = props.deferredJoin.displayOrder
	elseif fFlagIncreaseLoadingScreenOrder then
		v19 = Constants.DISPLAY_ORDER + 1
	else
		v19 = Constants.DISPLAY_ORDER
	end

	local createElement = React.createElement
	local v21 = {
		DisplayOrder = v19,
		OnTopOfCoreBlur = v5,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.None,
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local createElement2 = React.createElement
	local foundationProvider = module2.FoundationProvider
	local v23 = { colorMode = module2.Enums.ColorMode.Dark, preferences = v17 }

	local createElement3 = React.createElement
	local localizationProvider = module3.LocalizationProvider

	local createElement4 = React.createElement
	local v28 = {
		placeId = props.placeId,
		destinationUniverseId = 0,
		milestones = 0,
		reducedMotion = 0,
		isDismissing = 0,
		onEnterComplete = 0,
		isDirectionalInput = 0,
		gamepadCancelIcon = 0,
		chromeReveal = 0,
		onCancel = 0,
		safeAreaInsets = 0
	}
	local v29 = if props.deferredJoin then props.deferredJoin.universeId else nil
	v28.destinationUniverseId = v29

	if not v5 then
		v9 = v6.milestones
	end

	v28.milestones = v9
	v28.reducedMotion = reducedMotion
	v28.isDismissing = v6.isDismissing

	local v30 = if not (v5 or not fFlagTiltLoadingScreenEnterExitHold) then v6.onEnterComplete else nil
	v28.onEnterComplete = v30

	v28.isDirectionalInput = v12
	v28.gamepadCancelIcon = v13
	v28.chromeReveal = v6.chromeReveal
	v28.onCancel = v18
	v28.safeAreaInsets = v14
	return createElement("ScreenGui", v21, {
		Foundation = createElement2(foundationProvider, v23, {
			Localization = createElement3(localizationProvider, { localization = v15 }, {
				View = createElement4(TiltLoadingScreenContent, v28)
			})
		})
	})
end

return TiltLoadingScreenContainer
