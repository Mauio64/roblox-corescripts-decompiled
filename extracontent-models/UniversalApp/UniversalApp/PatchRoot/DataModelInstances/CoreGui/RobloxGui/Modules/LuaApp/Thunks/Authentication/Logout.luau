local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Players = game:GetService("Players")
local MemStorageService = game:GetService("MemStorageService")
local CorePackages = game:GetService("CorePackages")
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local Logout = require(Modules.LuaApp.Http.Requests.Logout)
local SetAuthenticationStatus = require(CorePackages.Workspace.Packages.AuthenticationStatus).Actions.SetAuthenticationStatus
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local ClearApp = require(script.Parent.ClearApp)
local AppStorageUtilities = require(script.Parent.AppStorageUtilities)
local GetLocaleAndGotoLoginPage = require(script.Parent.GetLocaleAndGotoLoginPage)
local User = require(script.Parent.User)
local PromiseUtilities = require(Modules.LuaApp.PromiseUtilities)
local AppStorageService = game:GetService("AppStorageService")
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local ExperimentCacheManager = require(CorePackages.Workspace.Packages.ExperimentCacheManager).ExperimentCacheManager
local GetFFlagDebugResetSurveyStorage = require(Modules.LuaApp.Flags.GetFFlagDebugResetSurveyStorage)
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local LuaLogoutReasons = require(Modules.LuaApp.Analytics.RobloxTelemetryConfigs.LuaLogoutReasons)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local CsatSurveyConstants = require(Modules.LuaApp.Components.OnPlatformSurveys.CsatSurveyConstants)
local ResetAppState = require(Modules.LuaApp.Thunks.Authentication.ResetAppState)
local DeleteAllCredentialsFromKeystore = require(Modules.LuaApp.Thunks.Authentication.DeleteAllCredentialsFromKeystore)
local AuthLocalStorageKeys = require(CorePackages.Workspace.Packages.AuthCommon).Enums.AuthLocalStorageKeys
local LoginMethods = require(CorePackages.Workspace.Packages.AuthCommon).Enums.LoginMethods
local TelemetryService = game:GetService("TelemetryService")
local v29 = game:DefineFastFlag("UseResetAppStateForLogout2", false)
local FFlagEnableIosKeychainLoginLua = require(Modules.LuaApp.Flags.FFlagEnableIosKeychainLoginLua)
local default = require(CorePackages.Workspace.Packages.CredentialsProtocol).CredentialsProtocol.default
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local KeystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local KeystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local KeystoreConstants = AuthCommon.Common.KeystoreConstants
local AuthAnalytics = require(CorePackages.Workspace.Packages.AuthAnalytics)
local DefaultUnauthenticatedConstants = AuthCommon.Common.DefaultUnauthenticatedConstants
local authClientError = AuthAnalytics.Events.authClientError
local FFlagEnableInvoluntaryLogoutEvent = require(Modules.LuaApp.Flags.FFlagEnableInvoluntaryLogoutEvent)
local FFlagEnableLogoutV3 = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLogoutV3
local FFlagEnableLastLoginMethodTracking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLastLoginMethodTracking
local GetFFlagEnableStorePreviousAccountData = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableStorePreviousAccountData
local StorePreviousAccountData = AuthCommon.Thunks.StorePreviousAccountData
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagEnableMagicLogin = SharedFlags.FFlagEnableMagicLogin
local SetMagicLoginAdvertisement = require(CorePackages.Workspace.Packages.LoginV2.Thunks).SetMagicLoginAdvertisement
local GetFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local LuaLogoutTelemetryConfig = TelemetryConfigs.LuaLogoutTelemetryConfig
local KeystoreDeleteCredentialsTelemetryConfig = TelemetryConfigs.KeystoreDeleteCredentialsTelemetryConfig
local GetFFlagAddPromCounterToKeystoreOps = SharedFlags.GetFFlagAddPromCounterToKeystoreOps
local v55 = game:DefineFastFlag("EnableRecordSignOut", false)
local recordSignOut = AuthCommon.Utils.recordSignOut

return function(p1, p2, s1: string?, s2: string?) -- line: 66
	-- upvalues: Logger (copy), v55 (copy), luaLogoutReasonNames (copy), recordSignOut (copy), FFlagEnableMagicLogin (copy), SetMagicLoginAdvertisement (copy), FFlagEnableInvoluntaryLogoutEvent (copy), FFlagEnableLogoutV3 (copy), User (copy), authClientError (copy), DefaultUnauthenticatedConstants (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), GetFFlagEnableStorePreviousAccountData (copy), StorePreviousAccountData (copy), Logout (copy), FFlagEnableBlackbirdCheck (copy), Players (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), HttpService (copy), ContentProvider (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreDeleteCredentialsTelemetryConfig (copy), DeleteAllCredentialsFromKeystore (copy), default (copy), KeystoreConstants (copy), PromiseUtilities (copy), v29 (copy), ResetAppState (copy), SetAuthenticationStatus (copy), LoginStatus (copy), GetLocaleAndGotoLoginPage (copy), LoggingProtocol (copy), LuaLogoutReasons (copy), LuaLogoutTelemetryConfig (copy), NotificationType (copy), ClearApp (copy), ExperimentCacheManager (copy), GetFFlagDebugResetSurveyStorage (copy), CsatSurveyConstants (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy)
	return function(p3) -- line: 67
		-- upvalues: Logger (copy), v55 (copy), s1 (copy), luaLogoutReasonNames (copy), recordSignOut (copy), FFlagEnableMagicLogin (copy), SetMagicLoginAdvertisement (copy), FFlagEnableInvoluntaryLogoutEvent (copy), FFlagEnableLogoutV3 (copy), User (copy), authClientError (copy), DefaultUnauthenticatedConstants (copy), s2 (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), GetFFlagEnableStorePreviousAccountData (copy), StorePreviousAccountData (copy), Logout (copy), p1 (copy), FFlagEnableBlackbirdCheck (copy), Players (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), HttpService (copy), ContentProvider (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreDeleteCredentialsTelemetryConfig (copy), DeleteAllCredentialsFromKeystore (copy), default (copy), KeystoreConstants (copy), PromiseUtilities (copy), v29 (copy), ResetAppState (copy), SetAuthenticationStatus (copy), LoginStatus (copy), GetLocaleAndGotoLoginPage (copy), LoggingProtocol (copy), LuaLogoutReasons (copy), LuaLogoutTelemetryConfig (copy), p2 (copy), NotificationType (copy), ClearApp (copy), ExperimentCacheManager (copy), GetFFlagDebugResetSurveyStorage (copy), CsatSurveyConstants (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy)
		Logger:info(string.format("[%f] Logout() (Universal App)", tick()))

		if v55 then
			local v62 = s1 ~= luaLogoutReasonNames.ManageAccountsRemoveCurrentUser

			pcall(function() -- line: 71
				-- upvalues: recordSignOut (copy), v62 (copy)
				recordSignOut(nil, v62)
			end)
		end

		local v63 = nil
		local str = nil

		if FFlagEnableMagicLogin then
			SetMagicLoginAdvertisement(false)
		end

		if FFlagEnableInvoluntaryLogoutEvent or FFlagEnableLogoutV3 then
			local v65 = User.fromLocalStorage()

			v63 = s1 or luaLogoutReasonNames.Unknown
			str = tostring(v65.userId)
		end

		if FFlagEnableInvoluntaryLogoutEvent then
			authClientError(DefaultUnauthenticatedConstants.DefaultClientErrorReason, v63, s2, str)
		end

		local v66 = false

		if FFlagEnableLastLoginMethodTracking then
			local v67 = AppStorageUtilities.getLastSuccessfulSignInMethod()

			v66 = v67 == LoginMethods.Email or (v67 == LoginMethods.EmailOtp or v67 == LoginMethods.Phone)
		end

		if not v66 then
			local v68 = User.fromLocalStorage() and User.fromLocalStorage().username

			if v68 and v68 ~= "" then
				AppStorageService:SetItem(AuthLocalStorageKeys.CredentialValue, v68)
			end
		end

		if GetFFlagEnableStorePreviousAccountData() then
			StorePreviousAccountData()
		end

		local v69 = if not FFlagEnableLogoutV3 then Logout(p1) else Logout(p1, v63, s2, str)

		if FFlagEnableBlackbirdCheck then
			Players:SetLocalPlayerInfo(-1, "", "", 0, true, false)
		else
			Players:SetLocalPlayerInfo(-1, "", "", 0, true)
		end

		if FFlagEnableIosKeychainLoginLua or GetFFlagKeystoreAutoLoginAvailable() then
			local json = HttpService:JSONEncode({
				server = ContentProvider.BaseUrl
			})

			KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.intentionalLogoutDelete)

			if GetFFlagAddPromCounterToKeystoreOps() then
				TelemetryService:LogCounter(KeystoreDeleteCredentialsTelemetryConfig, {
					customFields = {
						reason = "intentional_logout"
					}
				}, 1)
			end

			if GetFFlagKeystoreAutoLoginAvailable() then
				DeleteAllCredentialsFromKeystore(json)
			else
				default:deleteAllCredentialsFromiOSKeychain(default.CredentialsTypes.iosKeychainPassword, json, KeystoreConstants.KeystoreTimeout)
			end
		end

		PromiseUtilities.Batch({ v69 }):andThen(function() -- line: 158
			-- upvalues: v29 (copy), p3 (copy), ResetAppState (copy), SetAuthenticationStatus (copy), LoginStatus (copy), GetLocaleAndGotoLoginPage (copy), p1 (copy), AppStorageService (copy), LoggingProtocol (copy), LuaLogoutReasons (copy), s1 (copy), luaLogoutReasonNames (copy), TelemetryService (copy), LuaLogoutTelemetryConfig (copy), p2 (copy), NotificationType (copy), ClearApp (copy), User (copy), ExperimentCacheManager (copy), GetFFlagDebugResetSurveyStorage (copy), CsatSurveyConstants (copy), AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy)
			if v29 then
				p3:dispatch(ResetAppState())
				p3:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_OUT))
				p3:dispatch(GetLocaleAndGotoLoginPage(p1))
				AppStorageService:flush()
				LoggingProtocol.default:logRobloxTelemetryEvent(LuaLogoutReasons, nil, {
					lualogoutreasons = s1 or luaLogoutReasonNames.Unknown
				})
				TelemetryService:LogCounter(LuaLogoutTelemetryConfig, {
					customFields = {
						reason = s1 or luaLogoutReasonNames.Unknown
					}
				}, 1)
				p2:BroadcastNotification("", NotificationType.DID_LOG_OUT)

				return
			end

			p3:dispatch(ClearApp())
			p3:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_OUT))
			p3:dispatch(GetLocaleAndGotoLoginPage(p1))
			User.clearLocalStorage()
			ExperimentCacheManager.default:clearCache()

			if GetFFlagDebugResetSurveyStorage() then
				AppStorageService:SetItem(CsatSurveyConstants.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS, "{}")
			end

			AppStorageUtilities.setRobloxLocaleId("")
			AppStorageUtilities.setDiscoveryClientFallbackCache("")
			AppStorageService:flush()
			MemStorageService:Fire(MemStorageKeys.ThemeUpdate, "dark")
			MemStorageService:SetItem(MemStorageKeys.RobuxBalance, "0")
			MemStorageService:SetItem(MemStorageKeys.RobuxBalanceLocalized, "--")
			RoactAppExperiment.clearUserLayers()
			LoggingProtocol.default:logRobloxTelemetryEvent(LuaLogoutReasons, nil, {
				lualogoutreasons = s1 or luaLogoutReasonNames.Unknown
			})
			TelemetryService:LogCounter(LuaLogoutTelemetryConfig, {
				customFields = {
					reason = s1 or luaLogoutReasonNames.Unknown
				}
			}, 1)
			p2:BroadcastNotification("", NotificationType.DID_LOG_OUT)
		end)
	end
end
