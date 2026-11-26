local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local MessageBusService = game:GetService("MessageBusService")
local TelemetryService = game:GetService("TelemetryService")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local messageId = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetTheme")
local messageId2 = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetThemeOverride")
local messageId3 = MessageBusService:GetMessageId("Realtime", "appResume")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/gfG")

local default = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Utils.AppStorageJsonCacheUtils.default
local appearanceContext = require("@game/CorePackages/Workspace/Packages/Style").AppearanceContext
local module2 = require("@luauforge/bundled/fGL")
local module3 = require("@luauforge/bundled/fHf")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId

local module5 = require("@luauforge/bundled/igB")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper
local module6 = require("@luauforge/bundled/iiy")
local module7 = require("@luauforge/bundled/fHc")
local module8 = require("@luauforge/bundled/iiz")
local module9 = require("@luauforge/bundled/fGK")
local module10 = require("@luauforge/bundled/fGJ")

local fFlagDefaultKidsToDarkTheme = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDefaultKidsToDarkTheme
local fFlagFixDefaultThemeOverride = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFixDefaultThemeOverride
local defineFastFlag = game:DefineFastFlag("FixNilSystemThemeEnum", false)

local fFlagDeviceLevelThemeRespectForceTheme = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDeviceLevelThemeRespectForceTheme

local v5 = if defineFastFlag then module2.GetSystemThemeEnum() else nil

local extended = Roact.Component:extend("DeviceLevelThemeUpdater")

function extended:init()
	self.deviceLevelThemeAnalytics = self.props.deviceLevelThemeAnalytics or module3.new(TelemetryService)

	function self.getCachedDeviceLevelThemeName()
		local localUserId = self.props.localUserId
		local result = self.props.appStorageJsonCacheUtils:decodeInternal(module2.DeviceLevelThemeLocalStorageKey).result
		local v6 = if result then result[localUserId] or nil else nil
		logger:info("Cached device level theme name: " .. tostring(v6) .. " for userId: " .. tostring(localUserId))

		if v6 == "" or not v6 then
			v6 = nil
		end

		return v6
	end

	function self.getCachedThemeName()
		local authenticatedTheme = module.getAuthenticatedTheme()
		logger:info("Cached theme name: " .. tostring(authenticatedTheme) .. " for userId: " .. tostring(self.props.localUserId))

		if authenticatedTheme == "" or not authenticatedTheme then
			authenticatedTheme = nil
		end

		return authenticatedTheme
	end

	function self.changeAppTheme(currentAppThemeName)
		self.currentAppThemeName = currentAppThemeName
		local v6 = self.themeOverride or currentAppThemeName

		if fFlagDeviceLevelThemeRespectForceTheme and self.props.appPolicyForceTheme then
			v6 = self.props.appPolicyForceTheme.Name
		end

		logger:info("Changing app theme to " .. v6)
		self.deviceLevelThemeAnalytics:onSetNativeTheme()
		NotificationService.SelectedTheme = v6
		self.props.themeContext.setTheme(v6)

		module5:updateSharedAttributes({ AppTheme = v6 })
	end

	function self.setTheme(currentThemeEnum)
		if currentThemeEnum == self.props.systemThemeEnum.Error then
			logger:error("Received an error theme enum, not setting theme")
			return
		end

		if self.currentThemeEnum == currentThemeEnum then
			logger:info("Theme is already set to " .. currentThemeEnum.Name)
			return
		end

		logger:info("Setting theme to " .. currentThemeEnum.Name)

		if not module7() then
			self.deviceLevelThemeAnalytics:onThemeChanged(currentThemeEnum)
		end

		self.currentThemeEnum = currentThemeEnum

		if self.props.systemThemeEnum.isLightTheme(currentThemeEnum) then
			self.changeAppTheme(self.props.systemThemeEnum.Light.Name)
		elseif self.props.systemThemeEnum.isDarkTheme(currentThemeEnum) then
			self.changeAppTheme(self.props.systemThemeEnum.Dark.Name)
		end

		local localUserId = self.props.localUserId
		local result = self.props.appStorageJsonCacheUtils:decodeInternal(module2.DeviceLevelThemeLocalStorageKey).result
			or {}

		result[localUserId] = currentThemeEnum.Name
		logger:info("Caching device level theme name: " .. currentThemeEnum.Name .. " for userId: " .. tostring(localUserId))
		self.props.appStorageService:SetItem(
			module2.DeviceLevelThemeLocalStorageKey,
			HttpService:JSONEncode(result)
		)

		self.props.appStorageService:flush()
	end

	if self.props.systemThemeService then
		local messageBusService = self.props.messageBusService or MessageBusService
		self.connections = {
			self.props.systemThemeService.OnLuaThemeUpdated:Connect(function(p2)
				logger:info("Received OnLuaThemeUpdated event with themeEnum: " .. p2.Name)
				self.deviceLevelThemeAnalytics:onReceivedSystemThemeUpdated()

				if self.props.systemThemeEnum.isSystemTheme(self.currentThemeEnum) then
					self.props.systemThemeService:setTheme(p2)
				end
			end),
			messageBusService:Subscribe(messageId, function(p2)
				local systemTheme = p2.SystemTheme
				logger:info("Received MESSAGE_SET_THEME_EVENT_ID event with themeEnumValue: " .. systemTheme)
				local systemThemeEnum = self.props.systemThemeEnum.getSystemThemeEnum(systemTheme)
				self.setTheme(systemThemeEnum)
			end, false, true),
			messageBusService:Subscribe(messageId2, function(p2)
				logger:info("Received MESSAGE_SET_THEME_OVERRIDE_EVENT_ID event with themeEnumValue: " .. tostring(p2.ThemeOverride))

				self.themeOverride = p2.ThemeOverride

				if self.currentAppThemeName then
					self.changeAppTheme(self.currentAppThemeName)
				end
			end, false, true),
			messageBusService:Subscribe(messageId3, function()
				self.deviceLevelThemeAnalytics:onThemeSnapshot(self.currentThemeEnum)
			end, false, true)
		}
	end

	function self.getDefaultDeviceLevelTheme(p2)
		local ixpDefaultThemeSelection = self.props.ixpDefaultThemeSelection

		if
			self.props.ixpDefaultThemeEnabled
			and ixpDefaultThemeSelection
			and ixpDefaultThemeSelection ~= ""
		then
			logger:info("No cached theme found, using default theme from IXP: " .. tostring(ixpDefaultThemeSelection))
			local ixpServiceWrapper2 = self.props.IXPServiceWrapper or ixpServiceWrapper

			if module8() then
				ixpServiceWrapper2:LogBrowserTrackerLayerExposure(appBtidLayers.DefaultThemeLayer)
			else
				ixpServiceWrapper2:LogFlagLinkedUserLayerExposure(appBtidLayers.DefaultThemeLayer)
			end

			if ixpDefaultThemeSelection ~= "system" then
				return self.props.systemThemeEnum.getSystemThemeEnum(ixpDefaultThemeSelection)
			end

			self.deviceLevelThemeAnalytics:onRequestSystemTheme()
			local v6 = self.props.systemThemeService and module10(self.props.systemThemeService)
				or self.props.systemThemeEnum.Error
			self.deviceLevelThemeAnalytics:onGetSystemTheme(v6)
			return v6
		elseif p2 then
			logger:info("Found cached theme " .. p2)
			return self.props.systemThemeEnum.getSystemThemeEnum(p2)
		else
			logger:info("No cached theme found, defaulting to light theme")
			return self.props.systemThemeEnum.Light
		end
	end

	function self.initTheme()
		local cachedDeviceLevelThemeName = self.getCachedDeviceLevelThemeName()
		local v6

		if cachedDeviceLevelThemeName then
			logger:info("Found cached device level theme " .. cachedDeviceLevelThemeName)
			v6 = self.props.systemThemeEnum.getSystemThemeEnum(cachedDeviceLevelThemeName)

			if self.props.systemThemeEnum.isSystemTheme(v6) then
				self.deviceLevelThemeAnalytics:onRequestSystemTheme()
				v6 = self.props.systemThemeService and module10(self.props.systemThemeService)
					or self.props.systemThemeEnum.Error
				self.deviceLevelThemeAnalytics:onGetSystemTheme(v6)
			end
		else
			local cachedThemeName = self.getCachedThemeName()

			if fFlagDefaultKidsToDarkTheme and self.props.appPolicyDefaultTheme then
				v6 = self.props.appPolicyDefaultTheme
			elseif module6() then
				v6 = self.getDefaultDeviceLevelTheme(cachedThemeName)
			elseif cachedThemeName then
				logger:info("Found cached theme " .. cachedThemeName)
				v6 = self.props.systemThemeEnum.getSystemThemeEnum(cachedThemeName)
			else
				logger:info("No cached theme found, defaulting to light theme")
				v6 = self.props.systemThemeEnum.Light
			end
		end

		if self.props.systemThemeService and v6 then
			self.deviceLevelThemeAnalytics:onThemeSnapshot(v6)
			self.deviceLevelThemeAnalytics:onSetNativeTheme()
			self.props.systemThemeService:setTheme(v6)

			if fFlagFixDefaultThemeOverride then
				self.setTheme(v6)
			end
		end
	end
end

function extended.render(data): nil
	local localUserId = data.props.localUserId

	if localUserId == nil or localUserId == "" or localUserId == "-1" or localUserId == "0" then
		logger:info("userId is not available. Default to light theme")
		data.changeAppTheme(data.props.systemThemeEnum.Light.Name)
	else
		logger:info("initTheme for userId " .. tostring(data.props.localUserId))

		if module6() or fFlagDefaultKidsToDarkTheme then
			if module9() then
				data.initTheme()
			else
				task.spawn(data.initTheme)
			end
		else
			data.initTheme()
		end
	end

	return nil
end

function extended.willUnmount(p2)
	for k, connection in pairs(p2.connections) do
		connection:disconnect()
	end
end

local function DeviceLevelThemeChangeEventReceiver(props)
	local v6 = React.useContext(appearanceContext)
	local appStorageService = props.AppStorageService or AppStorageService
	local appStorageJsonCacheUtils = props.AppStorageJsonCacheUtils or default
	local v7 = props.SystemThemeEnum

	if not v7 then
		v7 = if defineFastFlag then v5 else module2.GetSystemThemeEnum()
	end

	local systemThemeService = props.SystemThemeService or module2.GetSystemThemeService()
	local messageBusService = props.messageBusService or MessageBusService
	local v8 = useLocalUserId()
	local v9

	if fFlagDefaultKidsToDarkTheme then
		v9 = useAppPolicy(function(p2)
			local systemThemeEnum = v7.getSystemThemeEnum(p2.getDefaultTheme())

			if systemThemeEnum == v7.Error then
				return nil
			end

			return systemThemeEnum
		end)
	end

	local v10 = not module6() and {}
		or RoactAppExperiment.useBrowserTrackerExperiment({ appBtidLayers.DefaultThemeLayer }, function(p2)
			local v11 = p2[appBtidLayers.DefaultThemeLayer] or {}
			return {
				IxpDefaultThemeSelection = v11.DefaultThemeSelection,
				IxpDefaultThemeEnabled = v11.DefaultThemeEnabled
			}
		end)

	local ixpDefaultThemeSelection = v10.IxpDefaultThemeSelection
	local ixpDefaultThemeEnabled = v10.IxpDefaultThemeEnabled
	local v11

	if fFlagDeviceLevelThemeRespectForceTheme then
		v11 = useAppPolicy(function(p2)
			local systemThemeEnum = v7.getSystemThemeEnum(p2.getForceTheme())

			if systemThemeEnum == v7.Error then
				return nil
			end

			return systemThemeEnum
		end)
	end

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join
	local v13 = {
		themeContext = v6,
		appStorageService = appStorageService,
		appStorageJsonCacheUtils = appStorageJsonCacheUtils,
		systemThemeEnum = v7,
		systemThemeService = systemThemeService,
		messageBusService = messageBusService,
		localUserId = v8,
		ixpDefaultThemeSelection = ixpDefaultThemeSelection,
		ixpDefaultThemeEnabled = ixpDefaultThemeEnabled,
		appPolicyDefaultTheme = nil,
		appPolicyForceTheme = nil
	}

	if not fFlagDefaultKidsToDarkTheme then
		v9 = nil
	end

	v13.appPolicyDefaultTheme = v9

	if not fFlagDeviceLevelThemeRespectForceTheme then
		v11 = nil
	end

	v13.appPolicyForceTheme = v11
	return createElement(extended, join(props, v13))
end

return DeviceLevelThemeChangeEventReceiver
