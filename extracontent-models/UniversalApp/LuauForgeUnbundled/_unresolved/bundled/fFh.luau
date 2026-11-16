local CorePackages = game:GetService("CorePackages")

local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/fDw")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local getLocalUser = require("@luauforge/bundled/cgr").Thunks.GetLocalUser
local module3 = require("@luauforge/bundled/fAM")

local setAuthenticationStatus = require("@luauforge/bundled/fBO").Actions.SetAuthenticationStatus
local module4 = require("@luauforge/bundled/dHq")
local module5 = require("@luauforge/bundled/fDH")
local module6 = require("@luauforge/bundled/fBK")
local module7 = require("@luauforge/bundled/fBn")
local module8 = require("@luauforge/bundled/dCp")
local module9 = require("@luauforge/bundled/fBr")
local module10 = require("@luauforge/bundled/fBQ")
local module11 = require("@luauforge/bundled/fot")
local module12 = require("@luauforge/bundled/fDL")
local module13 = require("@luauforge/bundled/fDM")
local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local module14 = require("@luauforge/bundled/fDN")
local module15 = require("@luauforge/bundled/edO")
local module16 = require("@luauforge/bundled/fBJ")

local module17 = require("@luauforge/bundled/fDO")
local module18 = require("@luauforge/bundled/fCa")
local module19 = require("@luauforge/bundled/fDP")

local receivedUserCountryCode = require("@luauforge/bundled/dxT").ReceivedUserCountryCode

local TracerService = game:GetEngineFeature("AppTracing") and game:GetService("TracerService") or nil

local module20 = require("@luauforge/bundled/fBW")
local module21 = require("@luauforge/bundled/fDy")
local module22 = require("@luauforge/bundled/fDz")

local module23 = require("@luauforge/bundled/fCc")
local HttpService = game:GetService("HttpService")
local default = require("@luauforge/bundled/fCb").CredentialsProtocol.default
local ContentProvider = game:GetService("ContentProvider")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local keystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local keystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local keystoreConstants = AuthCommon.Common.KeystoreConstants

local telemetryConfigs = require("@luauforge/bundled/fsz").TelemetryConfigs
local keystoreDeleteCredentialsTelemetryConfig = telemetryConfigs.KeystoreDeleteCredentialsTelemetryConfig
local TelemetryService = game:GetService("TelemetryService")

local default2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local handlePreHomePageRouting = require("@luauforge/bundled/fDU").HandlePreHomePageRouting
local isPioneerLaunch = require("@luauforge/bundled/fDJ").isPioneerLaunch
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnablePioneerPostAuthGameJoin = SharedFlags.FFlagEnablePioneerPostAuthGameJoin
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagPreHomePageRoutingEnabled = SharedFlags.FFlagPreHomePageRoutingEnabled
local fFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local getFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local fFlagUseSignalsForCountryCode = SharedFlags.FFlagUseSignalsForCountryCode

local getCountryCodeStore = if fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dxT").GetCountryCodeStore else nil

local function handleUserLoggedIn(object, object2)
	GuiService:BroadcastNotification(object:toJsonData(), module11.DID_LOG_IN)

	if fFlagUseSignalsForAuthenticationStatus then
		getAuthenticationStatusStore(false).setAuthenticationStatus(module10.LOGGED_IN)
	else
		object2:dispatch(setAuthenticationStatus(module10.LOGGED_IN))
	end
end

local function navigateToPostAuthLandingPage(object, p2, p3, object2, p4)
	local v5 = not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and ""
		or module7.getSignupActionRequired()

	if p2 and object2.isUnder13 then
		object:dispatch(module4({
			{ name = module8.UAppBlock }
		}))
	elseif fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch() then
		object:dispatch(module4({
			{ name = p3 }
		}))
	elseif v5 == "auth" then
		if module21() or module22() then
			object:dispatch(module4({
				{ name = module8.AddAuthMethodPage }
			}))
			return
		end

		module7.setSignupActionRequired("")
		module7.flush()
		object:dispatch(module4({
			{ name = p3 }
		}))
	elseif fFlagPreHomePageRoutingEnabled or fFlagPasskeyUpsellEnabled then
		handlePreHomePageRouting(p4, object, module4):andThen(function(p5)
			if not p5 then
				object:dispatch(module4({
					{ name = p3 }
				}))
			end
		end)
	else
		object:dispatch(module4({
			{ name = p3 }
		}))
	end
end

local function clearAuthFailureOverlayOnSuccess(object, object2, p2, p3, p4, p5)
	if object:getState().CentralOverlay.OverlayType == module15.AccountAuthenticationFailureOverlay then
		object:dispatch(module14())

		if object2:isEqual(p2) then
			navigateToPostAuthLandingPage(object, p3, p4, object2, p5)
		end
	end
end

local function handleUserMismatchAndUpdatePreloadStarted(object, p2, object2, p3, p4, p5, p6, p7)
	if object:isEqual(p2) then
		return p4
	end

	object:setToLocalPlayer()
	object:setToLocalStorage()

	if p3 then
		object2:dispatch(module6())
		p4 = false
	end

	object2:dispatch(getLocalUser())

	if fFlagUseSignalsForCountryCode then
		getCountryCodeStore(false).setCountryCode(object.countryCode)
	else
		object2:dispatch(receivedUserCountryCode(object.countryCode))
	end

	navigateToPostAuthLandingPage(object2, p5, p6, object, p7)

	RoactAppExperiment.initializeUserLayers(object.userId)

	return p4
end

local function fetchAndApplyUserSettings(object, p2, p3, object2)
	local v5 = {}
	table.insert(v5, object:andThen(function(p4)
		module7.setRobloxLocaleId(p4.generalExperienceLocale)
		module7.setGameLocaleId(p4.ugcLocale)
		LocalizationService:SetRobloxLocaleId(p4.generalExperienceLocale)
	end))

	local v6 = module5(p2, p3.userId)

	object2:dispatch(module19(p2))
	local v7

	if (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or module7.getSignupActionRequired()) == "auth" then
		v7 = module21()
	else
		v7 = false
	end

	local v8 = fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch()
	table.insert(v5, v6:andThen(function(p4)
		module7.setAuthenticatedTheme(p4)

		if not (v7 or v8) then
			MemStorageService:Fire(module9.ThemeUpdate, p4)
		end
	end))

	module3.Batch(v5):andThen(function()
		module7.flush()
	end)
end

local function fn()
	local jsonEncode = HttpService:JSONEncode({ server = ContentProvider.BaseUrl })

	if getFFlagKeystoreAutoLoginAvailable() then
		return module18(jsonEncode)
	end

	return default:deleteAllCredentialsFromiOSKeychain(
		default.CredentialsTypes.iosKeychainPassword,
		jsonEncode,
		keystoreConstants.KeystoreTimeout
	)
end

local function reportAccountInfoAnalytics(p2)
	if p2 == statusCodes.UNAUTHORIZED then
		module12(module13.Failure401Unauthenticated, 1)
	else
		module12(module13.FailureUnknownError, 1)
	end

	module12(module13.Failure, 1)
end

local function handleUnauthorizedError(p2, p3, p4, p5)
	spawn(function()
		default2:logRobloxTelemetryCounter(telemetryConfigs.NoCookieForCachedUserTelemetryConfig, 1)
	end)

	if module23 or getFFlagKeystoreAutoLoginAvailable() then
		keystoreAnalyticsEvents.sendPageLoadEvent(keystoreEventConstants.origin.remoteLogoutDelete)
		TelemetryService:LogCounter(keystoreDeleteCredentialsTelemetryConfig, {
			customFields = { reason = "remote_logout" }
		}, 1)

		fn()
	end

	module16(p2, p3, p4, p5, module20.UnauthorizedAutoLogin, nil, nil, false)
end

local function handleRetryableError(p2, p3, p4, p5, p6, p7, p8)
	module17(p2, function()
		LUAUFORGE_MODULE_GLOBALS_fFh_handleAccountInfoFromLua(p4, p3, p5, p6, p2, p7, p8)
	end)
end

local function handleAccountInfoError(p2, p3, p4, p5, p6, p7, p8, p9)
	if p2 == statusCodes.UNAUTHORIZED then
		module12(module13.Failure401Unauthenticated, 1)
	else
		module12(module13.FailureUnknownError, 1)
	end

	module12(module13.Failure, 1)

	if p2 == statusCodes.UNAUTHORIZED then
		handleUnauthorizedError(p3, p4, p5, p6)
	else
		module17(p4, function()
			LUAUFORGE_MODULE_GLOBALS_fFh_handleAccountInfoFromLua(p7, p5, p6, p3, p4, p8, p9)
		end)
	end
end

function LUAUFORGE_MODULE_GLOBALS_fFh_handleAccountInfoFromLua(p2, p3, p4, p5, p6, p7, callback, object, p8, p9)
	local v5 = not TracerService and "" or TracerService:StartSpan("luaAccountInfo", "")

	if object then
		object:logEventOnce("lua_auth_request_begin")
	end

	module(p3):andThen(function(p10)
		if object then
			object:logEventOnce("lua_auth_request_end")
		end

		if TracerService and v5 ~= "" then
			TracerService:FinishSpan(v5)
		end

		module12(module13.Success, 1)

		local v6 = Models.fromUserInfoRequest(p10)

		clearAuthFailureOverlayOnSuccess(p6, v6, p2, p8, p7, p3)

		p9 = handleUserMismatchAndUpdatePreloadStarted(v6, p2, p6, p5, p9, p8, p7, p3)

		if not p9 then
			p9 = true
			callback()
		end

		fetchAndApplyUserSettings(p4, p3, v6, p6)

		handleUserLoggedIn(v6, p6)
	end, function(p10)
		local statusCode = p10.StatusCode
		local v6 = p5
		local v7 = p6
		local v8 = p3
		local v9 = p4
		local v10 = p2
		local v11 = p7
		local v12 = callback

		if statusCode == statusCodes.UNAUTHORIZED then
			module12(module13.Failure401Unauthenticated, 1)
		else
			module12(module13.FailureUnknownError, 1)
		end

		module12(module13.Failure, 1)

		if statusCode == statusCodes.UNAUTHORIZED then
			handleUnauthorizedError(v6, v7, v8, v9)
		else
			module17(v7, function()
				LUAUFORGE_MODULE_GLOBALS_fFh_handleAccountInfoFromLua(v10, v8, v9, v6, v7, v11, v12)
			end)
		end
	end)
end

function LUAUFORGE_MODULE_GLOBALS_fFh_handleSessionCheckSuccess(p2, p3, p4, p5, p6, p7, callback, p8, p9, p10)
	local v5 = Models.fromLocalStorage()

	clearAuthFailureOverlayOnSuccess(p6, v5, p3, p9, p7, p2)

	if not handleUserMismatchAndUpdatePreloadStarted(v5, p3, p6, p5, p10, p9, p7, p2) then
		callback()
	end

	fetchAndApplyUserSettings(p4, p2, v5, p6)

	handleUserLoggedIn(v5, p6)
end

function LUAUFORGE_MODULE_GLOBALS_fFh_handleSessionCheckFailure(p2, p3, p4, p5, p6, p7, p8, p9)
	if p2 == statusCodes.UNAUTHORIZED then
		module12(module13.Failure401Unauthenticated, 1)
	else
		module12(module13.FailureUnknownError, 1)
	end

	module12(module13.Failure, 1)

	if p2 == statusCodes.UNAUTHORIZED then
		handleUnauthorizedError(p3, p4, p5, p6)
	else
		module17(p4, function()
			LUAUFORGE_MODULE_GLOBALS_fFh_handleAccountInfoFromLua(p7, p5, p6, p3, p4, p8, p9)
		end)
	end
end

return {
	handleSessionCheckSuccess = LUAUFORGE_MODULE_GLOBALS_fFh_handleSessionCheckSuccess,
	handleSessionCheckFailure = LUAUFORGE_MODULE_GLOBALS_fFh_handleSessionCheckFailure,
	handleAccountInfoFromLua = LUAUFORGE_MODULE_GLOBALS_fFh_handleAccountInfoFromLua
}
