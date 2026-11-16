local CorePackages = game:GetService("CorePackages")

local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local SduiSharedUtilities = require(CorePackages.Workspace.Packages.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)

local SduiInExperienceHost = require(script.Parent.SduiInExperienceHost)

local localization = nil

local function getLocalization() -- 1 equivalent call inferred from this helper
	if localization == nil then
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	end

	return localization
end

local function getDefaultDevice() -- 1 equivalent call inferred from this helper
	if isTenFootInterface() then
		return Foundation.Enums.Device.Console
	end

	return Foundation.Enums.Device.Desktop
end

local function wrapProvider(p, p2, child) -- 4 equivalent calls inferred from this helper
	return React.createElement(p, p2, { Child = child })
end

local function SduiInExperienceEntryPoint(props, ref)
	local element = React.createElement(SduiFeatureEntryPoint, {
		configKey = props.configKey,
		identifier = props.identifier,
		appPage = props.surfaceKey,
		routeName = props.routeName,
		additionalAnalyticsData = props.additionalAnalyticsData,
		loadTimer = props.loadTimer,
		onRetry = props.onRetry,
		errorSlot = props.errorSlot,
		loadingSlot = props.loadingSlot,
		shouldDisplayLoading = props.shouldDisplayLoading,
		shouldDisplayError = props.shouldDisplayError,
		onAbsoluteSizeChange = props.onAbsoluteSizeChange,
		extraLocalProps = props.extraLocalProps,
		LayoutOrder = props.LayoutOrder,
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		Position = props.Position,
		ref = ref
	})

	if not props.disableAppPolicyProvider then
		element = wrapProvider(UniversalAppPolicy.RoactAppPolicy.Provider, { -- inferred equivalent call
			policy = { UniversalAppPolicy.AppFeaturePolicies }
		}, element)
	end

	local provider = wrapProvider(SduiInExperienceHost, { surfaceKey = props.surfaceKey }, element) -- inferred equivalent call

	if not props.disableLocalizationProvider then
		provider = wrapProvider(LocalizationProvider, { localization = getLocalization() }, provider) -- inferred equivalent call
	end

	if props.disableFoundationProvider then
		return provider
	end

	return (wrapProvider(Foundation.FoundationProvider, { -- inferred equivalent call
		colorMode = props.colorMode or Foundation.Enums.ColorMode.Dark,
		device = props.device or getDefaultDevice() -- inferred equivalent call
	}, provider))
end

return React.memo(React.forwardRef(SduiInExperienceEntryPoint))
