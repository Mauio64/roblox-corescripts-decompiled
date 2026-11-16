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

	React.useEffect(function()
		if isPioneerLaunch() then
			return
		end

		local contextActionService = props.contextActionService or ContextActionService
		local v16 = false
		contextActionService:BindCoreAction("CancelGameLoad", function(p2, p3)
			if p3 == Enum.UserInputState.Begin then
				v16 = true
			elseif p3 == Enum.UserInputState.End and v16 then
				v16 = false

				if ref.current then
					ref.current(false, true)
				end
			end
		end, false, Enum.KeyCode.ButtonB)

		return function()
			contextActionService:UnbindCoreAction("CancelGameLoad")
		end
	end, { props.contextActionService })
	local v16 = React.useMemo(function()
		return { reducedMotion = reducedMotion }
	end, { reducedMotion })
	local v17 = React.useCallback(function()
		if ref.current then
			ref.current(true)
		end
	end, {})

	if not v6.isVisible then
		return nil
	end

	local v18

	if props.deferredJoin then
		v18 = props.deferredJoin.displayOrder
	elseif fFlagIncreaseLoadingScreenOrder then
		v18 = Constants.DISPLAY_ORDER + 1
	else
		v18 = Constants.DISPLAY_ORDER
	end

	local createElement = React.createElement
	local v20 = {
		DisplayOrder = v18,
		OnTopOfCoreBlur = v5,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.None,
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local createElement2 = React.createElement
	local foundationProvider = module2.FoundationProvider
	local v22 = { colorMode = module2.Enums.ColorMode.Dark, preferences = v16 }

	local createElement3 = React.createElement
	local localizationProvider = module3.LocalizationProvider

	local createElement4 = React.createElement
	local v27 = {
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
	local v28 = if props.deferredJoin then props.deferredJoin.universeId else nil
	v27.destinationUniverseId = v28

	if not v5 then
		v9 = v6.milestones
	end

	v27.milestones = v9
	v27.reducedMotion = reducedMotion
	v27.isDismissing = v6.isDismissing

	local v29 = if not (v5 or not fFlagTiltLoadingScreenEnterExitHold) then v6.onEnterComplete else nil
	v27.onEnterComplete = v29

	v27.isDirectionalInput = v12
	v27.gamepadCancelIcon = v13
	v27.chromeReveal = v6.chromeReveal
	v27.onCancel = v17
	v27.safeAreaInsets = v14
	return createElement("ScreenGui", v20, {
		Foundation = createElement2(foundationProvider, v22, {
			Localization = createElement3(localizationProvider, { localization = v15 }, {
				View = createElement4(TiltLoadingScreenContent, v27)
			})
		})
	})
end

return TiltLoadingScreenContainer
