local parent = script:FindFirstAncestor("ProgressLoading").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local InExperienceLocales = require(parent.InExperienceLocales)
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets
local usePreferredInput = Responsive.usePreferredInput
local getBuilderIconForKeycode = Foundation.Utility.getBuilderIconForKeycode

local TiltLoadingScreenContent = require(script.Parent.TiltLoadingScreenContent)
local useExperienceLoadingLifecycle = require(script.Parent.Hooks.useExperienceLoadingLifecycle)
local useDeferredLoadingLifecycle = require(script.Parent.Hooks.useDeferredLoadingLifecycle)
local Constants = require(script.Parent.Constants)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableTiltLoadingScreen = SharedFlags.FFlagEnableTiltLoadingScreen
local SharedFlags2 = require(parent.SharedFlags)
local FFlagIncreaseLoadingScreenOrder = SharedFlags2.FFlagIncreaseLoadingScreenOrder
local SharedFlags3 = require(parent.SharedFlags)
local FFlagTiltLoadingScreenConsoleHints = SharedFlags3.FFlagTiltLoadingScreenConsoleHints
local SharedFlags4 = require(parent.SharedFlags)
local FFlagTiltLoadingScreenEnterExitHold = SharedFlags4.FFlagTiltLoadingScreenEnterExitHold
local SharedFlags5 = require(parent.SharedFlags)
local FFlagTiltLoadingScreenDismissOnLoaded = SharedFlags5.FFlagTiltLoadingScreenDismissOnLoaded
local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local ContextActionService = game:GetService("ContextActionService")
local LocalizationService = game:GetService("LocalizationService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

require(script.Parent.Types)

local function TiltLoadingScreenContainer(props)
	if not FFlagEnableTiltLoadingScreen then
		return nil
	end

	local onTopOfCoreBlur = props.deferredJoin ~= nil
	local v = useExperienceLoadingLifecycle(not onTopOfCoreBlur, props.milestones, props.onDismissComplete)
	local v2

	if props.deferredJoin then
		v2 = props.deferredJoin.assetService
	end

	local milestones, current = useDeferredLoadingLifecycle(onTopOfCoreBlur, v2, props.onCancel)

	local reducedMotion = UserGameSettings.ReducedMotion
	local ref = React.useRef(props.onCancel)

	if not onTopOfCoreBlur then
		current = props.onCancel
	end

	ref.current = current
	local v3

	if FFlagTiltLoadingScreenConsoleHints then
		v3 = usePreferredInput()
	end

	local isDirectionalInput = FFlagTiltLoadingScreenConsoleHints and v3 == Responsive.Input.Directional
	local gamepadCancelIcon

	if isDirectionalInput then
		gamepadCancelIcon = getBuilderIconForKeycode(Enum.KeyCode.ButtonB)
	end

	local safeAreaInsets = useDeviceInsets()
	local localization = React.useMemo(function()
		return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	local v4 = (not FFlagTiltLoadingScreenDismissOnLoaded or v.isVisible) and true or false

	React.useEffect(function()
		if not v4 or isPioneerLaunch() then
			return
		end

		local contextActionService = props.contextActionService or ContextActionService
		local v5 = false
		contextActionService:BindCoreAction("CancelGameLoad", function(_, p)
			if p == Enum.UserInputState.Begin then
				v5 = true
			elseif p == Enum.UserInputState.End and v5 then
				v5 = false

				if ref.current then
					ref.current(false, true)
				end
			end
		end, false, Enum.KeyCode.ButtonB)

		return function()
			contextActionService:UnbindCoreAction("CancelGameLoad")
		end
	end, { props.contextActionService, v4 })
	local preferences = React.useMemo(function()
		return { reducedMotion = reducedMotion }
	end, { reducedMotion })
	local onCancel = React.useCallback(function()
		if ref.current then
			ref.current(true)
		end
	end, {})

	if not v.isVisible then
		return nil
	end

	local displayOrder

	if props.deferredJoin then
		displayOrder = props.deferredJoin.displayOrder
	elseif FFlagIncreaseLoadingScreenOrder then
		displayOrder = Constants.DISPLAY_ORDER + 1
	else
		displayOrder = Constants.DISPLAY_ORDER
	end

	local createElement = React.createElement
	local v5 = {
		DisplayOrder = displayOrder,
		OnTopOfCoreBlur = onTopOfCoreBlur,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.None,
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local createElement2 = React.createElement
	local foundationProvider = Foundation.FoundationProvider
	local v6 = { colorMode = Foundation.Enums.ColorMode.Dark, preferences = preferences }

	local createElement3 = React.createElement
	local localizationProvider = Localization.LocalizationProvider

	local createElement4 = React.createElement
	local v7 = {
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
	local destinationUniverseId

	if props.deferredJoin then
		destinationUniverseId = props.deferredJoin.universeId
	end

	v7.destinationUniverseId = destinationUniverseId

	if not onTopOfCoreBlur then
		milestones = v.milestones
	end

	v7.milestones = milestones
	v7.reducedMotion = reducedMotion
	v7.isDismissing = v.isDismissing
	local onEnterComplete

	if not (onTopOfCoreBlur or not FFlagTiltLoadingScreenEnterExitHold) then
		onEnterComplete = v.onEnterComplete
	end

	v7.onEnterComplete = onEnterComplete

	v7.isDirectionalInput = isDirectionalInput
	v7.gamepadCancelIcon = gamepadCancelIcon
	v7.chromeReveal = v.chromeReveal
	v7.onCancel = onCancel
	v7.safeAreaInsets = safeAreaInsets
	return createElement("ScreenGui", v5, {
		Foundation = createElement2(foundationProvider, v6, {
			Localization = createElement3(localizationProvider, { localization = localization }, {
				View = createElement4(TiltLoadingScreenContent, v7)
			})
		})
	})
end

return TiltLoadingScreenContainer
