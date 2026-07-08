local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local RobloxGui = CoreGui.RobloxGui
local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local React = require(CorePackages.Packages.React)
local requestInternalWrapper = require(CorePackages.Workspace.Packages.Http).NetworkLayers.requestInternalWrapper
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local useRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry
local DynamicReportInExpContainer = require(CorePackages.Workspace.Packages.GenericAbuseReporting.DynamicReportInExpContainer)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local useCaptureScreenshotV2 = require(AbuseReportMenu.Hooks.useCaptureScreenshotV2)
local isAbuseReportMenuOpenCloseSignalEnabled = require(AbuseReportMenu.Flags.isAbuseReportMenuOpenCloseSignalEnabled)
local FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay = require(AbuseReportMenu.Flags.FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay)
local isInWHAM1707Experiment = require(script.Parent.isInWHAM1707Experiment)
local safetyServiceSignals = require(script.Parent.safetyServiceSignals)
local inExpChatMessagesLoader = require(script.Parent.inExpChatMessagesLoader)
local inExpVoiceUsersLoader = require(script.Parent.inExpVoiceUsersLoader)
local FFlagIEMSettingsPageDisplaying = require(CorePackages.Workspace.Packages.SharedFlags).FFlagIEMSettingsPageDisplaying
local setTimeout = require(CorePackages.Packages.LuauPolyfill).setTimeout

local function shouldEmitMenuOpenCloseSignal() -- line: 43
	-- upvalues: isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy)
	return isAbuseReportMenuOpenCloseSignalEnabled() and isInWHAM1707Experiment()
end
local function AbuseReportMenuContentInner(t1: {[any]: any}) -- line: 76
	-- upvalues: useRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), React (copy), FocusRoot (copy), DynamicReportInExpContainer (copy), inExpChatMessagesLoader (copy), inExpVoiceUsersLoader (copy), default (copy)
	local v34 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.CentralOverlay) == nil

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
			isAutoFocusRoot = true,
			isIsolated = true,
			frameProps = {
				Size = UDim2.new(1, 0, 1, 0)
			},
			isFocusable = v34,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView
		}, {
			DynamicReportInExpContainer = React.createElement(DynamicReportInExpContainer, {
				onClose = t1.onClose,
				isReportTabVisible = t1.isReportTabVisible,
				reportAnythingSnapshotRef = t1.reportAnythingSnapshotRef,
				inExpChatMessagesLoader = inExpChatMessagesLoader,
				inExpVoiceUsersLoader = inExpVoiceUsersLoader,
				voiceChatServiceManager = default,
				preselectedPlayer = t1.preselectedPlayer,
				onReportFinish = t1.onReportFinish
			})
		})
	})
end
local function AbuseReportMenuContent(t2: {[any]: any}) -- line: 113
	-- upvalues: React (copy), useCaptureScreenshotV2 (copy), FFlagIEMSettingsPageDisplaying (copy), isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy), safetyServiceSignals (copy), setTimeout (copy), FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay (copy), AbuseReportMenuContentInner (copy)
	local v36, v37 = React.useState(false)
	local v38, v39 = React.useState(nil)
	local v40 = useCaptureScreenshotV2()
	local v41 = React.useRef(t2.hideReportTab)

	v41.current = t2.hideReportTab

	local v42 = React.useRef(t2.showReportTab)

	v42.current = t2.showReportTab

	local v43 = React.useRef(false)
	local v44 = React.useRef(false)

	React.useEffect(function() -- line: 138
		-- upvalues: v43 (copy), v37 (copy), v40 (copy), v41 (copy), v42 (copy), FFlagIEMSettingsPageDisplaying (copy), t2 (copy), v44 (copy), v39 (copy), isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy), safetyServiceSignals (copy), setTimeout (copy), FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay (copy)
		local function onOpen() -- line: 139
			-- upvalues: v43 (copy), v37 (copy), v40 (copy), v41 (copy), v42 (copy)
			if v43.current then
				return
			end

			v43.current = true
			v37(true)
			v40.captureIfApplicable({
				hide = v41.current,
				show = v42.current
			})
		end

		if FFlagIEMSettingsPageDisplaying then
			t2.registerOnReportTabDisplaying(onOpen)
		else
			t2.registerOnReportTabDisplayed(onOpen)
		end

		t2.registerOnReportTabHidden(function() -- line: 160
			-- upvalues: v40 (copy), v43 (copy), v44 (copy), v37 (copy), v39 (copy), isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy), safetyServiceSignals (copy)
			if v40.getIsCapturing() then
				return
			end

			v43.current = false
			v44.current = false
			v37(false)
			v39(nil)

			if isAbuseReportMenuOpenCloseSignalEnabled() and isInWHAM1707Experiment() then
				safetyServiceSignals.reportMenuTabClose()
			end
		end)
		t2.registerSetNextPlayerToReport(function(p1) -- line: 176
			-- upvalues: v39 (copy)
			v39(p1)
		end)
		t2.registerOnSettingsHidden(function() -- line: 180
			-- upvalues: setTimeout (copy), v43 (copy), v40 (copy), FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay (copy)
			setTimeout(function() -- line: 187
				-- upvalues: v43 (copy), v40 (copy)
				if not v43.current then
					v40.reset()
				end
			end, FIntAbuseReportTabClearCapturedScreenshotOnCloseFixDelay)
		end)
	end, {
		t2.registerOnReportTabHidden,
		t2.registerSetNextPlayerToReport,
		t2.registerOnSettingsHidden,
		if not FFlagIEMSettingsPageDisplaying then t2.registerOnReportTabDisplayed else t2.registerOnReportTabDisplaying,
		v40.captureIfApplicable,
		v40.getIsCapturing,
		v40.reset
	})
	React.useEffect(function() -- line: 212
		-- upvalues: v36 (copy), v44 (copy), isAbuseReportMenuOpenCloseSignalEnabled (copy), isInWHAM1707Experiment (copy), v40 (copy), safetyServiceSignals (copy)
		if not v36 or v44.current then
			return
		end

		if not isAbuseReportMenuOpenCloseSignalEnabled() or not isInWHAM1707Experiment() then
			return
		end

		if not v40.isCaptureApplicable or v40.isScreenshotTaken then
			v44.current = true
			safetyServiceSignals.reportMenuTabOpen()
		end
	end, {
		v36,
		v40.isScreenshotTaken,
		v40.isCaptureApplicable
	})

	return React.createElement(AbuseReportMenuContentInner, {
		isReportTabVisible = v36,
		preselectedPlayer = v38,
		reportAnythingSnapshotRef = v40.snapshotRef,
		onClose = t2.hideReportTab,
		onReportFinish = function() -- line: 237
			-- upvalues: v39 (copy)
			v39(nil)
		end
	})
end
local function AbuseReportMenu2(t3: {[any]: any}) -- line: 243
	-- upvalues: Localization (copy), LocalizationService (copy), React (copy), CoreScriptsRootProvider (copy), LocalizationProvider (copy), RoactServices (copy), RoactNetworking (copy), requestInternalWrapper (copy), HttpService (copy), AbuseReportMenuContent (copy)
	local v46 = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(CoreScriptsRootProvider, nil, React.createElement(LocalizationProvider, {
		localization = v46
	}, {
		ServicesProvider = React.createElement(RoactServices.ServiceProvider, {
			services = {
				[RoactNetworking] = requestInternalWrapper(HttpService)
			}
		}, {
			AbuseReportMenuContent = React.createElement(AbuseReportMenuContent, t3)
		})
	}))
end

return AbuseReportMenu2
