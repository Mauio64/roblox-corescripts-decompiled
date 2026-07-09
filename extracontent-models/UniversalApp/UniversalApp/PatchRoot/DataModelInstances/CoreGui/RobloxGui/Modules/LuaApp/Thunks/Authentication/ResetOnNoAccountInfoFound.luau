local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local MemStorageService = game:GetService("MemStorageService")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local PromiseUtilities = require(Modules.LuaApp.PromiseUtilities)
local AppStorageUtilities = require(script.Parent.AppStorageUtilities)
local ClearApp = require(script.Parent.ClearApp)
local GuiService = game:GetService("GuiService")
local SetAuthenticationStatus = require(CorePackages.Workspace.Packages.AuthenticationStatus).Actions.SetAuthenticationStatus
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateToRoute = require(Modules.LuaApp.Thunks.NavigateToRoute)
local AppPage = require(Modules.LuaApp.AppPage)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v22 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local ExperimentCacheManager = require(CorePackages.Workspace.Packages.ExperimentCacheManager).ExperimentCacheManager
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local LuaLogoutReasons = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.LuaLogoutReasons)
local TelemetryService = game:GetService("TelemetryService")
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local FFlagEnableIosKeychainLoginLua = require(Modules.LuaApp.Flags.FFlagEnableIosKeychainLoginLua)
local GetFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local KeystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local KeystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local LuaLogoutTelemetryConfig = TelemetryConfigs.LuaLogoutTelemetryConfig
local KeystoreRedirectTelemetryConfig = TelemetryConfigs.KeystoreRedirectTelemetryConfig
local GetFFlagAddPromCounterToKeystoreOps = SharedFlags.GetFFlagAddPromCounterToKeystoreOps
local GetFFlagEnableStorePreviousAccountData = SharedFlags.GetFFlagEnableStorePreviousAccountData
local StorePreviousAccountData = AuthCommon.Thunks.StorePreviousAccountData
local FFlagEnableCallingLogoutOnResetIXP = SharedFlags.FFlagEnableCallingLogoutOnResetIXP
local FFlagEnableLuaLoginRevamp = SharedFlags.FFlagEnableLuaLoginRevamp
local AppBtidLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppBtidLayers
local IXPService = game:GetService("IXPService")

local function isEnableCallingLogoutOnResetFromIxp() -- line: 59
	-- upvalues: IXPService (copy), AppBtidLayers (copy)
	local ok, result = pcall(function() -- line: 60
		-- upvalues: IXPService (copy), AppBtidLayers (copy)
		return IXPService:GetBrowserTrackerLayerVariables(AppBtidLayers.LandingLayer)
	end)

	if ok and (result ~= nil and result.iOSEnableCallingLogoutOnReset ~= nil) then
		return result.iOSEnableCallingLogoutOnReset
	end

	return true
end
local function hasNonNilEntries(t1: {[any]: any}?) -- line: 73
	if t1 == nil then
		return false
	end

	for _, v in pairs(t1) do
		if v ~= nil then
			return true
		end
	end

	return false
end

return function(p1, p2, p3, p4, s1: string?, t2: {[any]: any}?, b1: boolean?, b2: boolean?) -- line: 87
	-- upvalues: PromiseUtilities (copy), AppStorageUtilities (copy), LocalizationService (copy), FFlagEnableCallingLogoutOnResetIXP (copy), IXPService (copy), AppBtidLayers (copy), luaLogoutReasonNames (copy), Logout (copy), GuiService (copy), GetFFlagEnableStorePreviousAccountData (copy), StorePreviousAccountData (copy), ClearApp (copy), MemStorageService (copy), MemStorageKeys (copy), SetAuthenticationStatus (copy), LoginStatus (copy), LoggingProtocol (copy), LuaLogoutReasons (copy), TelemetryService (copy), LuaLogoutTelemetryConfig (copy), FlagSettings (copy), ResetNavigationHistory (copy), AppPage (copy), getAppFeaturePolicies (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateToRoute (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), KeystoreRedirectTelemetryConfig (copy), FFlagEnableLuaLoginRevamp (copy), NavigateDown (copy), RoactAppExperiment (copy), ExperimentCacheManager (copy)
	PromiseUtilities.Batch({ p4 }):andThen(function(p5) -- line: 97
		-- upvalues: AppStorageUtilities (copy), LocalizationService (copy), p1 (copy), FFlagEnableCallingLogoutOnResetIXP (copy), IXPService (copy), AppBtidLayers (copy), s1 (copy), luaLogoutReasonNames (copy), p2 (copy), Logout (copy), p3 (copy), GuiService (copy), GetFFlagEnableStorePreviousAccountData (copy), StorePreviousAccountData (copy), ClearApp (copy), MemStorageService (copy), MemStorageKeys (copy), SetAuthenticationStatus (copy), LoginStatus (copy), LoggingProtocol (copy), LuaLogoutReasons (copy), TelemetryService (copy), LuaLogoutTelemetryConfig (copy), FlagSettings (copy), ResetNavigationHistory (copy), AppPage (copy), getAppFeaturePolicies (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateToRoute (copy), t2 (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), b2 (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), KeystoreRedirectTelemetryConfig (copy), FFlagEnableLuaLoginRevamp (copy), b1 (copy), NavigateDown (copy), RoactAppExperiment (copy), ExperimentCacheManager (copy)
		local g62 = nil
		local g68 = nil
		local v65 = nil

		if p5 and p5[1] then
			p5[1]:match(function(p6) -- line: 99
				-- upvalues: AppStorageUtilities (copy), LocalizationService (copy)
				AppStorageUtilities.setRobloxLocaleId(p6.signupAndLoginLocale)
				LocalizationService:SetRobloxLocaleId(p6.signupAndLoginLocale)
			end)
		end

		if p1 then
			if FFlagEnableCallingLogoutOnResetIXP then
				local ok, result = pcall(function() -- line: 60
					-- upvalues: IXPService (copy), AppBtidLayers (copy)
					return IXPService:GetBrowserTrackerLayerVariables(AppBtidLayers.LandingLayer)
				end)

				if (not ok or (result == nil or (result.iOSEnableCallingLogoutOnReset == nil or result.iOSEnableCallingLogoutOnReset))) and s1 == luaLogoutReasonNames.UnauthorizedAutoLogin then
					p2:dispatch(Logout(p3, GuiService, s1))
					g62 = true
				end
			end

			if not g62 then
				if GetFFlagEnableStorePreviousAccountData() then
					StorePreviousAccountData()
				end

				p2:dispatch(ClearApp())
				MemStorageService:Fire(MemStorageKeys.ThemeUpdate, "dark")
			end
		end

		g62 = false
		p2:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_OUT))

		if s1 ~= nil then
			LoggingProtocol.default:logRobloxTelemetryEvent(LuaLogoutReasons, nil, {
				lualogoutreasons = s1
			})
		end

		TelemetryService:LogCounter(LuaLogoutTelemetryConfig, {
			customFields = {
				reason = s1 or luaLogoutReasonNames.Unknown
			}
		}, 1)

		if FlagSettings.WeChatLoginEnabled() then
			p2:dispatch(ResetNavigationHistory({{
				name = AppPage.WeChatLoginWrapper
			}}))
		elseif FlagSettings.LuaAppLoginUIEnabled() then
			if getAppFeaturePolicies().getUseSingleSignOn() then
				local t3 = {{
					name = AppPage.SingleSignOnContainer
				}}

				if FFlagSignalsNavP3Dispatch then
					v22.to(v22.fromLegacyPage(t3[#t3]))
				else
					p2:dispatch(NavigateToRoute(t3))
				end
			else
				local v64 = t2

				if v64 == nil then
					v65 = false
				else
					for _, v in pairs(v64) do
						if v ~= nil then
							v65 = true
							g68 = true
						end

						if g68 then
							break
						end
					end

					if not g68 then
						v65 = false
					end
				end

				g68 = false

				if (FFlagEnableIosKeychainLoginLua or GetFFlagKeystoreAutoLoginAvailable()) and t2 and v65 then
					local t4 = {}

					if b2 == nil or b2 == false then
						KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.redirectToLandingPage)

						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreRedirectTelemetryConfig, {
								customFields = {
									destination = "landing_page"
								}
							}, 1)
						end

						p2:dispatch(ResetNavigationHistory({{
							name = AppPage.Landing,
							extraProps = t4
						}}))
					else
						if GetFFlagAddPromCounterToKeystoreOps() then
							TelemetryService:LogCounter(KeystoreRedirectTelemetryConfig, {
								customFields = {
									destination = "login_page"
								}
							}, 1)
						end

						if FFlagEnableLuaLoginRevamp then
							t4.forcedUsernameOverride = t2.username
							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.redirectToLoginPage)
							p2:dispatch(ResetNavigationHistory({
								{
									name = AppPage.Landing,
									extraProps = {}
								},
								{
									name = AppPage.LoginV2,
									extraProps = t4
								}
							}))
						else
							t4.usernameFromIosKeychain = t2.username

							if b1 then
								t4.passwordFromIosKeychain = t2.password
							end

							KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.redirectToLoginPage)
							p2:dispatch(ResetNavigationHistory({
								{
									name = AppPage.Landing,
									extraProps = {}
								},
								{
									name = AppPage.Login,
									extraProps = t4
								}
							}))
						end
					end
				else
					if GetFFlagEnableStorePreviousAccountData() then
						StorePreviousAccountData()
					end

					p2:dispatch(ResetNavigationHistory({{
						name = AppPage.Landing,
						extraProps = {}
					}}))
				end
			end
		elseif FFlagSignalsNavP3Dispatch then
			v22.down(v22.fromLegacyPage({
				name = AppPage.LoginNative
			}))
		else
			p2:dispatch(NavigateDown({
				name = AppPage.LoginNative
			}))
		end

		RoactAppExperiment.clearUserLayers()
		ExperimentCacheManager.default:clearCache()
	end)
end
