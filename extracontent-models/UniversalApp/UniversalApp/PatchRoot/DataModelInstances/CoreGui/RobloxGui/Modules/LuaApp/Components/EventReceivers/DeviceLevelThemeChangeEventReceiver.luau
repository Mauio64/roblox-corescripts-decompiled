local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local MessageBusService = game:GetService("MessageBusService")
local TelemetryService = game:GetService("TelemetryService")
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local MessageId = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetTheme")
local MessageId2 = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetThemeOverride")
local MessageId3 = MessageBusService:GetMessageId("Realtime", "appResume")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local default = require(CorePackages.Workspace.Packages.AppCommonLib).Utils.AppStorageJsonCacheUtils.default
local ThemeContext = require(CorePackages.Workspace.Packages.Style).ThemeContext
local SystemThemeFeature = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature)
local DeviceLevelThemeAnalytics = require(Modules.LuaApp.Components.EventReceivers.Analytics.DeviceLevelThemeAnalytics)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local LuaAppBacktraceReporter = require(Modules.LuaApp.LuaAppBacktraceReporter)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local GetFFlagDefaultThemeEnabled = require(Modules.LuaApp.Flags.GetFFlagDefaultThemeEnabled)
local GetFFlagEnableThemeUpdatedLoggingFix = require(Modules.LuaApp.Flags.GetFFlagEnableThemeUpdatedLoggingFix)
local GetFFlagSystemThemeExposureLoggingFix = require(Modules.LuaApp.Flags.GetFFlagSystemThemeExposureLoggingFix)
local GetFFlagUseNonYieldGetSystemTheme = require(Modules.LuaApp.Flags.GetFFlagUseNonYieldGetSystemTheme)
local GetSystemTheme = require(Modules.LuaApp.Components.EventReceivers.GetSystemTheme)
local FFlagDefaultKidsToDarkTheme = require(CorePackages.Workspace.Packages.SharedFlags).FFlagDefaultKidsToDarkTheme
local FFlagFixDefaultThemeOverride = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFixDefaultThemeOverride
local v34 = Roact.Component:extend("DeviceLevelThemeUpdater")

function v34.init(p1) -- line: 54
	-- upvalues: DeviceLevelThemeAnalytics (copy), TelemetryService (copy), Logger (copy), HttpService (copy), FFlagDefaultKidsToDarkTheme (copy), SystemThemeFeature (copy), AppStorageUtilities (copy), NotificationService (copy), LuaAppBacktraceReporter (copy), GetFFlagEnableThemeUpdatedLoggingFix (copy), MessageBusService (copy), MessageId (copy), MessageId2 (copy), MessageId3 (copy), IXPServiceWrapper (copy), GetFFlagSystemThemeExposureLoggingFix (copy), AppBtidLayers (copy), GetSystemTheme (copy), GetFFlagDefaultThemeEnabled (copy), FFlagFixDefaultThemeOverride (copy)
	p1.deviceLevelThemeAnalytics = p1.props.deviceLevelThemeAnalytics or DeviceLevelThemeAnalytics.new(TelemetryService)

	function p1.getHasResetToDefaultTheme(s1: string) -- line: 58
		-- upvalues: p1 (copy), Logger (copy)
		local localUserId = p1.props.localUserId
		local result = p1.props.appStorageJsonCacheUtils:decodeInternal(s1).result
		local v58 = not not result and (result[localUserId] or false)

		Logger:info("Cached has reset to default theme: " .. tostring(v58) .. " for storage key: " .. tostring(s1) .. " for userId: " .. tostring(localUserId))

		return v58
	end
	function p1.setHasResetToDefaultTheme(s2: string, b1: boolean) -- line: 74
		-- upvalues: p1 (copy), Logger (copy), HttpService (copy)
		local localUserId = p1.props.localUserId
		local v62 = p1.props.appStorageJsonCacheUtils:decodeInternal(s2).result or {}

		v62[localUserId] = b1
		Logger:info("Caching has reset to default theme: " .. tostring(b1) .. " for storage key: " .. tostring(s2) .. " for userId: " .. tostring(localUserId))
		p1.props.appStorageService:SetItem(s2, HttpService:JSONEncode(v62))
		p1.props.appStorageService:flush()
	end
	function p1.getShouldResetToDefaultTheme() -- line: 90
		-- upvalues: FFlagDefaultKidsToDarkTheme (copy), p1 (copy)
		if FFlagDefaultKidsToDarkTheme and p1.props.appPolicyDefaultTheme then
			return not p1.getHasResetToDefaultTheme("KidsAccountHasResetToDefaultTheme")
		end

		return false
	end
	function p1.getCachedDeviceLevelThemeName() -- line: 98
		-- upvalues: p1 (copy), SystemThemeFeature (copy), Logger (copy)
		local localUserId = p1.props.localUserId
		local result = p1.props.appStorageJsonCacheUtils:decodeInternal(SystemThemeFeature.DeviceLevelThemeLocalStorageKey).result
		local v65 = result and result[localUserId] or nil

		Logger:info("Cached device level theme name: " .. tostring(v65) .. " for userId: " .. tostring(localUserId))

		return v65 ~= "" and v65 or nil
	end
	function p1.getCachedThemeName() -- line: 117
		-- upvalues: AppStorageUtilities (copy), Logger (copy), p1 (copy)
		local v66 = AppStorageUtilities.getAuthenticatedTheme()

		Logger:info("Cached theme name: " .. tostring(v66) .. " for userId: " .. tostring(p1.props.localUserId))

		return v66 ~= "" and v66 or nil
	end
	function p1.changeAppTheme(p2) -- line: 139
		-- upvalues: p1 (copy), Logger (copy), NotificationService (copy), LuaAppBacktraceReporter (copy)
		p1.currentAppThemeName = p2

		local v68 = p1.themeOverride or p2

		Logger:info("Changing app theme to " .. v68)
		p1.deviceLevelThemeAnalytics:onSetNativeTheme()
		NotificationService.SelectedTheme = v68
		p1.props.themeContext.setTheme(v68)
		LuaAppBacktraceReporter:updateSharedAttributes({
			AppTheme = v68
		})
	end
	function p1.setTheme(p3) -- line: 158
		-- upvalues: p1 (copy), Logger (copy), GetFFlagEnableThemeUpdatedLoggingFix (copy), SystemThemeFeature (copy), HttpService (copy)
		if p3 == p1.props.systemThemeEnum.Error then
			Logger:error("Received an error theme enum, not setting theme")

			return
		end

		if p3 == p1.currentThemeEnum then
			Logger:info("Theme is already set to " .. p3.Name)

			return
		end

		Logger:info("Setting theme to " .. p3.Name)

		if not GetFFlagEnableThemeUpdatedLoggingFix() then
			p1.deviceLevelThemeAnalytics:onThemeChanged(p3)
		end

		p1.currentThemeEnum = p3

		if p1.props.systemThemeEnum.isLightTheme(p3) then
			p1.changeAppTheme(p1.props.systemThemeEnum.Light.Name)
		elseif p1.props.systemThemeEnum.isDarkTheme(p3) then
			p1.changeAppTheme(p1.props.systemThemeEnum.Dark.Name)
		end

		local localUserId = p1.props.localUserId
		local v71 = p1.props.appStorageJsonCacheUtils:decodeInternal(SystemThemeFeature.DeviceLevelThemeLocalStorageKey).result or {}

		v71[localUserId] = p3.Name
		Logger:info("Caching device level theme name: " .. p3.Name .. " for userId: " .. tostring(localUserId))
		p1.props.appStorageService:SetItem(SystemThemeFeature.DeviceLevelThemeLocalStorageKey, HttpService:JSONEncode(v71))
		p1.props.appStorageService:flush()
	end

	if p1.props.systemThemeService then
		local v37 = p1.props.messageBusService or MessageBusService

		p1.connections = {
			p1.props.systemThemeService.OnLuaThemeUpdated:Connect(function(p4) -- line: 200
				-- upvalues: Logger (copy), p1 (copy)
				Logger:info("Received OnLuaThemeUpdated event with themeEnum: " .. p4.Name)
				p1.deviceLevelThemeAnalytics:onReceivedSystemThemeUpdated()

				if p1.props.systemThemeEnum.isSystemTheme(p1.currentThemeEnum) then
					p1.props.systemThemeService:setTheme(p4)
				end
			end),
			v37:Subscribe(MessageId, function(p5) -- line: 208
				-- upvalues: Logger (copy), p1 (copy)
				local SystemTheme = p5.SystemTheme

				Logger:info("Received MESSAGE_SET_THEME_EVENT_ID event with themeEnumValue: " .. SystemTheme)

				local v75 = p1.props.systemThemeEnum.getSystemThemeEnum(SystemTheme)

				p1.setTheme(v75)
			end, false, true),
			v37:Subscribe(MessageId2, function(p6) -- line: 215
				-- upvalues: Logger (copy), p1 (copy)
				Logger:info("Received MESSAGE_SET_THEME_OVERRIDE_EVENT_ID event with themeEnumValue: " .. tostring(p6.ThemeOverride))
				p1.themeOverride = p6.ThemeOverride

				if p1.currentAppThemeName then
					p1.changeAppTheme(p1.currentAppThemeName)
				end
			end, false, true),
			v37:Subscribe(MessageId3, function() -- line: 226
				-- upvalues: p1 (copy)
				p1.deviceLevelThemeAnalytics:onThemeSnapshot(p1.currentThemeEnum)
			end, false, true)
		}
	end

	function p1.getDefaultDeviceLevelTheme(p7) -- line: 233
		-- upvalues: p1 (copy), Logger (copy), IXPServiceWrapper (copy), GetFFlagSystemThemeExposureLoggingFix (copy), AppBtidLayers (copy), GetSystemTheme (copy)
		local ixpDefaultThemeSelection = p1.props.ixpDefaultThemeSelection

		if p1.props.ixpDefaultThemeEnabled and (ixpDefaultThemeSelection and ixpDefaultThemeSelection ~= "") then
			Logger:info("No cached theme found, using default theme from IXP: " .. tostring(ixpDefaultThemeSelection))

			local v79 = p1.props.IXPServiceWrapper or IXPServiceWrapper

			if GetFFlagSystemThemeExposureLoggingFix() then
				v79:LogBrowserTrackerLayerExposure(AppBtidLayers.DefaultThemeLayer)
			else
				v79:LogFlagLinkedUserLayerExposure(AppBtidLayers.DefaultThemeLayer)
			end

			if ixpDefaultThemeSelection == "system" then
				p1.deviceLevelThemeAnalytics:onRequestSystemTheme()

				local v80 = p1.props.systemThemeService and GetSystemTheme(p1.props.systemThemeService) or p1.props.systemThemeEnum.Error

				p1.deviceLevelThemeAnalytics:onGetSystemTheme(v80)

				return v80
			end

			return p1.props.systemThemeEnum.getSystemThemeEnum(ixpDefaultThemeSelection)
		end

		if not p7 then
			Logger:info("No cached theme found, defaulting to light theme")

			return p1.props.systemThemeEnum.Light
		end

		Logger:info("Found cached theme " .. p7)

		return p1.props.systemThemeEnum.getSystemThemeEnum(p7)
	end
	function p1.initTheme() -- line: 265
		-- upvalues: p1 (copy), FFlagDefaultKidsToDarkTheme (copy), GetFFlagDefaultThemeEnabled (copy), Logger (copy), GetSystemTheme (copy), FFlagFixDefaultThemeOverride (copy)
		local v81 = p1.getCachedDeviceLevelThemeName()
		local v82 = if not FFlagDefaultKidsToDarkTheme then nil else p1.getShouldResetToDefaultTheme()
		local appPolicyDefaultTheme

		if not v81 or v82 then
			local v83 = p1.getCachedThemeName()

			if FFlagDefaultKidsToDarkTheme and p1.props.appPolicyDefaultTheme then
				appPolicyDefaultTheme = p1.props.appPolicyDefaultTheme
				p1.setHasResetToDefaultTheme("KidsAccountHasResetToDefaultTheme", true)
			elseif GetFFlagDefaultThemeEnabled() then
				appPolicyDefaultTheme = p1.getDefaultDeviceLevelTheme(v83)
			elseif not v83 then
				Logger:info("No cached theme found, defaulting to light theme")
				appPolicyDefaultTheme = p1.props.systemThemeEnum.Light
			else
				Logger:info("Found cached theme " .. v83)
				appPolicyDefaultTheme = p1.props.systemThemeEnum.getSystemThemeEnum(v83)
			end
		else
			Logger:info("Found cached device level theme " .. v81)
			appPolicyDefaultTheme = p1.props.systemThemeEnum.getSystemThemeEnum(v81)

			if p1.props.systemThemeEnum.isSystemTheme(appPolicyDefaultTheme) then
				p1.deviceLevelThemeAnalytics:onRequestSystemTheme()
				appPolicyDefaultTheme = p1.props.systemThemeService and GetSystemTheme(p1.props.systemThemeService) or p1.props.systemThemeEnum.Error
				p1.deviceLevelThemeAnalytics:onGetSystemTheme(appPolicyDefaultTheme)
			end
		end

		if p1.props.systemThemeService and appPolicyDefaultTheme then
			p1.deviceLevelThemeAnalytics:onThemeSnapshot(appPolicyDefaultTheme)
			p1.deviceLevelThemeAnalytics:onSetNativeTheme()
			p1.props.systemThemeService:setTheme(appPolicyDefaultTheme)

			if FFlagFixDefaultThemeOverride then
				p1.setTheme(appPolicyDefaultTheme)
			end
		end
	end
end
function v34.render(p8) -- line: 322
	-- upvalues: Logger (copy), GetFFlagDefaultThemeEnabled (copy), FFlagDefaultKidsToDarkTheme (copy), GetFFlagUseNonYieldGetSystemTheme (copy)
	local localUserId = p8.props.localUserId

	if localUserId == nil or (localUserId == "" or localUserId == "-1" or localUserId == "0") then
		Logger:info("userId is not available. Default to light theme")
		p8.changeAppTheme(p8.props.systemThemeEnum.Light.Name)
	else
		Logger:info("initTheme for userId " .. tostring(p8.props.localUserId))

		if GetFFlagDefaultThemeEnabled() or FFlagDefaultKidsToDarkTheme then
			if GetFFlagUseNonYieldGetSystemTheme() then
				p8.initTheme()
			else
				task.spawn(p8.initTheme)
			end
		else
			p8.initTheme()
		end
	end

	return nil
end
function v34.willUnmount(p9) -- line: 343
	for _, v in pairs(p9.connections) do
		v:disconnect()
	end
end

local function DeviceLevelThemeChangeEventReceiver(p10) -- line: 349
	-- upvalues: React (copy), ThemeContext (copy), AppStorageService (copy), default (copy), SystemThemeFeature (copy), MessageBusService (copy), useLocalUserId (copy), FFlagDefaultKidsToDarkTheme (copy), useAppPolicy (copy), GetFFlagDefaultThemeEnabled (copy), RoactAppExperiment (copy), AppBtidLayers (copy), Roact (copy), v34 (copy), Cryo (copy)
	local v44 = React.useContext(ThemeContext)
	local v45 = p10.AppStorageService or AppStorageService
	local v46 = p10.AppStorageJsonCacheUtils or default
	local v47 = p10.SystemThemeEnum or SystemThemeFeature.GetSystemThemeEnum()
	local v48 = p10.SystemThemeService or SystemThemeFeature.GetSystemThemeService()
	local v49 = p10.messageBusService or MessageBusService
	local v50 = useLocalUserId()
	local v51 = if not FFlagDefaultKidsToDarkTheme then nil else useAppPolicy(function(p11) -- line: 359
		-- upvalues: v47 (copy)
		local v86 = v47.getSystemThemeEnum(p11.getDefaultTheme())

		if v86 == v47.Error then
			return nil
		end

		return v86
	end)
	local v52 = if not GetFFlagDefaultThemeEnabled() then {} else RoactAppExperiment.useBrowserTrackerExperiment({ AppBtidLayers.DefaultThemeLayer }, function(p12) -- line: 371
		-- upvalues: AppBtidLayers (copy)
		local v88 = p12[AppBtidLayers.DefaultThemeLayer] or {}

		return {
			IxpDefaultThemeSelection = v88.DefaultThemeSelection,
			IxpDefaultThemeEnabled = v88.DefaultThemeEnabled
		}
	end)
	local IxpDefaultThemeSelection = v52.IxpDefaultThemeSelection
	local IxpDefaultThemeEnabled = v52.IxpDefaultThemeEnabled

	return Roact.createElement(v34, Cryo.Dictionary.join(p10, {
		themeContext = v44,
		appStorageService = v45,
		appStorageJsonCacheUtils = v46,
		systemThemeEnum = v47,
		systemThemeService = v48,
		messageBusService = v49,
		localUserId = v50,
		ixpDefaultThemeSelection = IxpDefaultThemeSelection,
		ixpDefaultThemeEnabled = IxpDefaultThemeEnabled,
		appPolicyDefaultTheme = if not FFlagDefaultKidsToDarkTheme then nil else v51
	}))
end

return DeviceLevelThemeChangeEventReceiver
