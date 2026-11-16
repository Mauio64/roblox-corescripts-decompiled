local Players = game:GetService("Players")
local MemStorageService = game:GetService("MemStorageService")
local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fBQ")
local module2 = require("@luauforge/bundled/fBR")

local setAuthenticationStatus = require("@luauforge/bundled/fBO").Actions.SetAuthenticationStatus
local module3 = require("@luauforge/bundled/fot")
local module4 = require("@luauforge/bundled/fBK")
local module5 = require("@luauforge/bundled/fBn")
local module6 = require("@luauforge/bundled/fBS")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module8 = require("@luauforge/bundled/fAM")
local AppStorageService = game:GetService("AppStorageService")
local module9 = require("@luauforge/bundled/fBr")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local experimentCacheManager = require("@luauforge/bundled/fBT").ExperimentCacheManager
local module10 = require("@luauforge/bundled/fBU")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module12 = require("@luauforge/bundled/fBV")
local module13 = require("@luauforge/bundled/fBW")
local module14 = require("@luauforge/bundled/fBX")
local module15 = require("@luauforge/bundled/fBZ")
local module16 = require("@luauforge/bundled/fCa")
local authLocalStorageKeys = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.AuthLocalStorageKeys
local loginMethods = require("@game/CorePackages/Workspace/Packages/AuthCommon").Enums.LoginMethods
local TelemetryService = game:GetService("TelemetryService")

local defineFastFlag = game:DefineFastFlag("UseResetAppStateForLogout2", false)
local module17 = require("@luauforge/bundled/fCc")
local default = require("@luauforge/bundled/fCb").CredentialsProtocol.default
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local keystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local keystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local keystoreConstants = AuthCommon.Common.KeystoreConstants
local module19 = require("@luauforge/bundled/fsz")
local defaultUnauthenticatedConstants = AuthCommon.Common.DefaultUnauthenticatedConstants
local authClientError = module19.Events.authClientError
local module20 = require("@luauforge/bundled/fCd")
local fFlagEnableLogoutV3 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableLogoutV3

local fFlagEnableLastLoginMethodTracking = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableLastLoginMethodTracking

local getFFlagEnableStorePreviousAccountData = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableStorePreviousAccountData
local storePreviousAccountData = AuthCommon.Thunks.StorePreviousAccountData
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagEnableMagicLogin = SharedFlags.FFlagEnableMagicLogin
local setMagicLoginAdvertisement = require("@luauforge/bundled/fCe").SetMagicLoginAdvertisement
local getFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local telemetryConfigs = require("@luauforge/bundled/fsz").TelemetryConfigs
local luaLogoutTelemetryConfig = telemetryConfigs.LuaLogoutTelemetryConfig
local keystoreDeleteCredentialsTelemetryConfig = telemetryConfigs.KeystoreDeleteCredentialsTelemetryConfig
local fFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local module22 = require("@luauforge/bundled/fCJ")
local fFlagClearAccountBlobWhenNoValidSessions = module22.FFlagClearAccountBlobWhenNoValidSessions
local getAccountsList = module22.GetAccountsList

local defineFastFlag2 = game:DefineFastFlag("EnableRecordSignOut", false)
local recordSignOut = AuthCommon.Utils.recordSignOut

return function(p2, object, p3, p4)
	return function(object2)
		logger:info(string.format("[%f] Logout() (Universal App)", tick()))

		if defineFastFlag2 then
			local v5 = p3 ~= module13.ManageAccountsRemoveCurrentUser
			pcall(function()
				recordSignOut(nil, v5)
			end)
		end

		local v5 = nil
		local userId = nil

		if fFlagEnableMagicLogin then
			setMagicLoginAdvertisement(false)
		end

		if module20 or fFlagEnableLogoutV3 then
			local v6 = Models.fromLocalStorage()
			v5 = p3 or module13.Unknown
			userId = tostring(v6.userId)
		end

		if module20 then
			authClientError(defaultUnauthenticatedConstants.DefaultClientErrorReason, v5, p4, userId)
		end

		local v6

		if fFlagEnableLastLoginMethodTracking then
			local lastSuccessfulSignInMethod = module5.getLastSuccessfulSignInMethod()

			v6 = lastSuccessfulSignInMethod == loginMethods.Email
				or lastSuccessfulSignInMethod == loginMethods.EmailOtp
				or lastSuccessfulSignInMethod == loginMethods.Phone
		else
			v6 = false
		end

		if not v6 then
			local username = Models.fromLocalStorage() and Models.fromLocalStorage().username

			if username and username ~= "" then
				AppStorageService:SetItem(authLocalStorageKeys.CredentialValue, username)
			end
		end

		if getFFlagEnableStorePreviousAccountData() then
			storePreviousAccountData()
		end

		local v7 = if fFlagEnableLogoutV3 then module2(p2, v5, p4, userId) else module2(p2)

		if fFlagEnableBlackbirdCheck then
			Players:SetLocalPlayerInfo(-1, "", "", 0, true, false)
		else
			Players:SetLocalPlayerInfo(-1, "", "", 0, true)
		end

		if module17 or getFFlagKeystoreAutoLoginAvailable() then
			local jsonEncode = HttpService:JSONEncode({
				server = ContentProvider.BaseUrl
			})

			keystoreAnalyticsEvents.sendPageLoadEvent(keystoreEventConstants.origin.intentionalLogoutDelete)
			TelemetryService:LogCounter(keystoreDeleteCredentialsTelemetryConfig, {
				customFields = { reason = "intentional_logout" }
			}, 1)

			if getFFlagKeystoreAutoLoginAvailable() then
				module16(jsonEncode)
			else
				default:deleteAllCredentialsFromiOSKeychain(
					default.CredentialsTypes.iosKeychainPassword,
					jsonEncode,
					keystoreConstants.KeystoreTimeout
				)
			end
		end

		if fFlagClearAccountBlobWhenNoValidSessions and fFlagEnableLuaAccountSwitch then
			v7 = v7:andThen(function()
				return getAccountsList(p2, false, { maxRetryCount = 0, timeout = 5000 }):catch(function(): nil
					return nil
				end)
			end)
		end

		module8.Batch({ v7 }):andThen(function()
			if defineFastFlag then
				object2:dispatch(module15())

				if fFlagUseSignalsForAuthenticationStatus then
					getAuthenticationStatusStore(false).setAuthenticationStatus(module.LOGGED_OUT)
				else
					object2:dispatch(setAuthenticationStatus(module.LOGGED_OUT))
				end

				object2:dispatch(module6(p2))
				AppStorageService:flush()
			else
				object2:dispatch(module4())

				if fFlagUseSignalsForAuthenticationStatus then
					getAuthenticationStatusStore(false).setAuthenticationStatus(module.LOGGED_OUT)
				else
					object2:dispatch(setAuthenticationStatus(module.LOGGED_OUT))
				end

				object2:dispatch(module6(p2))
				Models.clearLocalStorage()
				experimentCacheManager.default:clearCache()

				if module10() then
					AppStorageService:SetItem(module14.LOCAL_STORAGE_KEY_CSAT_SURVEY_COMPLETED_IDS, "{}")
				end

				module5.setRobloxLocaleId("")
				module5.setDiscoveryClientFallbackCache("")

				AppStorageService:flush()
				MemStorageService:Fire(module9.ThemeUpdate, "dark")
				MemStorageService:SetItem(module9.RobuxBalance, "0")
				MemStorageService:SetItem(module9.RobuxBalanceLocalized, "--")
				RoactAppExperiment.clearUserLayers()
			end

			LoggingProtocol.default:logRobloxTelemetryEvent(module12, nil, {
				lualogoutreasons = p3 or module13.Unknown
			})

			TelemetryService:LogCounter(luaLogoutTelemetryConfig, {
				customFields = {
					reason = p3 or module13.Unknown
				}
			}, 1)

			object:BroadcastNotification("", module3.DID_LOG_OUT)
		end)
	end
end
