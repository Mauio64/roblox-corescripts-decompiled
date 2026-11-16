local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local RobloxGui = CoreGui.RobloxGui
local abuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local React = require(CorePackages.Packages.React)
local Http = require(CorePackages.Workspace.Packages.Http)
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices)
local roactServices = RoactServices.RoactServices

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local useRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry

local DynamicReportInExpContainer = require(CorePackages.Workspace.Packages.GenericAbuseReporting.DynamicReportInExpContainer)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

local useCaptureScreenshotV2 = require(abuseReportMenu.Hooks.useCaptureScreenshotV2)
local useSettingsHubCloseButton = require(script.Parent.useSettingsHubCloseButton)
local isAbuseReportMenuOpenCloseSignalEnabled = require(abuseReportMenu.Flags.isAbuseReportMenuOpenCloseSignalEnabled)
local FFlagReportFocusNavCloseButton = require(abuseReportMenu.Flags.FFlagReportFocusNavCloseButton)

local FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay = require(abuseReportMenu.Flags.FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay)
local safetyServiceSignals = require(script.Parent.safetyServiceSignals)

local inExpChatMessagesLoader = require(script.Parent.inExpChatMessagesLoader)
local inExpVoiceUsersLoader = require(script.Parent.inExpVoiceUsersLoader)

local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout

local function shouldEmitMenuOpenCloseSignal() -- 2 equivalent calls inferred from this helper
	return isAbuseReportMenuOpenCloseSignalEnabled()
end

local function AbuseReportMenuContentInner(props)
	local isFocusable = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.CentralOverlay) == nil
	local nextSelectionUp, v

	if FFlagReportFocusNavCloseButton then
		nextSelectionUp, v = useSettingsHubCloseButton(props.getSettingsHubRef, props.isReportTabVisible)
	end

	local createElement = React.createElement
	local v2 = {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}

	local createElement2 = React.createElement
	local frameProps = {
		Size = UDim2.new(1, 0, 1, 0),
		SelectionBehaviorUp = 0,
		NextSelectionUp = 0
	}
	local selectionBehaviorUp

	if FFlagReportFocusNavCloseButton and nextSelectionUp ~= nil then
		selectionBehaviorUp = Enum.SelectionBehavior.Escape
	end

	frameProps.SelectionBehaviorUp = selectionBehaviorUp

	frameProps.NextSelectionUp = nextSelectionUp
	return createElement("Frame", v2, {
		FocusNavigationCoreScriptsWrapper = createElement2(FocusRoot, {
			frameProps = frameProps,
			isFocusable = isFocusable,
			isAutoFocusRoot = not FFlagReportFocusNavCloseButton or not v,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView
		}, {
			DynamicReportInExpContainer = React.createElement(DynamicReportInExpContainer, {
				onClose = props.onClose,
				isReportTabVisible = props.isReportTabVisible,
				reportAnythingSnapshotRef = props.reportAnythingSnapshotRef,
				inExpChatMessagesLoader = inExpChatMessagesLoader,
				inExpVoiceUsersLoader = inExpVoiceUsersLoader,
				voiceChatServiceManager = default,
				preselectedPlayer = props.preselectedPlayer,
				onReportFinish = props.onReportFinish
			})
		})
	})
end

local function AbuseReportMenuContent(props)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(nil)

	local v = useCaptureScreenshotV2()

	local ref = React.useRef(props.hideReportTab)
	ref.current = props.hideReportTab
	local ref2 = React.useRef(props.showReportTab)
	ref2.current = props.showReportTab

	local ref3 = React.useRef(false)

	local ref4 = React.useRef(false)

	React.useEffect(function()
		local function onOpen()
			if ref3.current then
				return
			end

			ref3.current = true
			setState(true)
			v.captureIfApplicable({ hide = ref.current, show = ref2.current })
		end

		props.registerOnReportTabDisplaying(onOpen)

		props.registerOnReportTabHidden(function()
			if v.getIsCapturing() then
				return
			end

			ref3.current = false
			ref4.current = false
			setState(false)
			setState2(nil)

			if shouldEmitMenuOpenCloseSignal() then -- inferred equivalent call
				safetyServiceSignals.reportMenuTabClose()
			end
		end)

		props.registerSetNextPlayerToReport(function(p)
			setState2(p)
		end)

		props.registerOnSettingsHidden(function()
			setTimeout(function()
				if not ref3.current then
					v.reset()
				end
			end, FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay)
		end)
	end, {
		props.registerOnReportTabHidden,
		props.registerSetNextPlayerToReport,
		props.registerOnSettingsHidden,
		props.registerOnReportTabDisplaying,
		v.captureIfApplicable,
		v.getIsCapturing,
		v.reset
	})

	React.useEffect(function()
		if not state or ref4.current or not shouldEmitMenuOpenCloseSignal() then -- inferred equivalent call
			return
		end

		if not v.isCaptureApplicable or v.isScreenshotTaken then
			ref4.current = true
			safetyServiceSignals.reportMenuTabOpen()
		end
	end, { state, v.isScreenshotTaken, v.isCaptureApplicable })

	local createElement = React.createElement
	local v2 = {
		isReportTabVisible = state,
		preselectedPlayer = state2,
		reportAnythingSnapshotRef = v.snapshotRef,
		getSettingsHubRef = 0,
		onClose = 0,
		onReportFinish = 0
	}
	local getSettingsHubRef

	if FFlagReportFocusNavCloseButton then
		getSettingsHubRef = props.getSettingsHubRef
	end

	v2.getSettingsHubRef = getSettingsHubRef
	v2.onClose = props.hideReportTab
	function v2.onReportFinish()
		setState2(nil)
	end

	return createElement(AbuseReportMenuContentInner, v2)
end

local function AbuseReportMenu(p)
	local localization = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(
		CoreScriptsRootProvider,
		nil,
		React.createElement(LocalizationProvider, { localization = localization }, {
			ServicesProvider = React.createElement(roactServices.ServiceProvider, {
				services = {
					[RoactNetworking] = requestInternalWrapper(HttpService)
				}
			}, {
				AbuseReportMenuContent = React.createElement(AbuseReportMenuContent, p)
			})
		})
	)
end

return AbuseReportMenu
