local CorePackages = game:GetService("CorePackages")

local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local module = require("@luauforge/bundled/ghQ")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local getLocalUser = require("@luauforge/bundled/ciE").Thunks.GetLocalUser
local module3 = require("@luauforge/bundled/gfe")

local setAuthenticationStatus = require("@luauforge/bundled/ggh").Actions.SetAuthenticationStatus
local module4 = require("@luauforge/bundled/dKv")
local module5 = require("@luauforge/bundled/gib")
local module6 = require("@luauforge/bundled/ggd")
local module7 = require("@luauforge/bundled/gfG")
local isPioneerLaunch = require("@luauforge/bundled/gid").isPioneerLaunch
local module8 = require("@luauforge/bundled/dFu")
local module9 = require("@luauforge/bundled/gie")
local module10 = require("@luauforge/bundled/gfK")
local module11 = require("@luauforge/bundled/ggj")
local module12 = require("@luauforge/bundled/fvN")
local module13 = require("@luauforge/bundled/gif")
local module14 = require("@luauforge/bundled/gig")
local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local module15 = require("@luauforge/bundled/gih")
local module16 = require("@luauforge/bundled/ehl")
local module17 = require("@luauforge/bundled/ggc")
local module18 = require("@luauforge/bundled/ghX")
local module19 = require("@luauforge/bundled/ggt")

local module20 = require("@luauforge/bundled/gii")
local module21 = require("@luauforge/bundled/gij")
local experienceService = require("@luauforge/bundled/bZg").ExperienceService

local receivedUserCountryCode = require("@luauforge/bundled/dAW").ReceivedUserCountryCode
local linkingProtocol = require("@luauforge/bundled/bZe").LinkingProtocol

local TracerService = game:GetEngineFeature("AppTracing") and game:GetService("TracerService") or nil

local module22 = require("@luauforge/bundled/ggp")
local module23 = require("@luauforge/bundled/ghS")
local module24 = require("@luauforge/bundled/ghT")

local defineFastFlag = game:DefineFastFlag("EnableLaunchAppCheckForAccountSwitchGameParams", false)
local fFlagUseSignalsForUserAccess = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForUserAccess

local isRestrictedBySource = if fFlagUseSignalsForUserAccess then require("@luauforge/bundled/gim").isRestrictedBySource else nil

local module25 = require("@luauforge/bundled/ggv")
local HttpService = game:GetService("HttpService")
local default = require("@luauforge/bundled/ggu").CredentialsProtocol.default
local ContentProvider = game:GetService("ContentProvider")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local keystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local keystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local keystoreConstants = AuthCommon.Common.KeystoreConstants

local telemetryConfigs = require("@luauforge/bundled/fzT").TelemetryConfigs
local keystoreDeleteCredentialsTelemetryConfig = telemetryConfigs.KeystoreDeleteCredentialsTelemetryConfig
local TelemetryService = game:GetService("TelemetryService")

local default2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local handlePreHomePageRouting = require("@luauforge/bundled/gio").HandlePreHomePageRouting
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagPreHomePageRoutingEnabled = SharedFlags.FFlagPreHomePageRoutingEnabled
local fFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local fFlagEnableMagicLogin = SharedFlags.FFlagEnableMagicLogin
local fFlagEnablePostAuthRoutingInAllCases = SharedFlags.FFlagEnablePostAuthRoutingInAllCases
local getFFlagFixPlatformRestrictedHomeClobber = SharedFlags.GetFFlagFixPlatformRestrictedHomeClobber
local fFlagLuaAppBirthdayComplianceGate = SharedFlags.FFlagLuaAppBirthdayComplianceGate
local getFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local setMagicLoginAdvertisement = require("@luauforge/bundled/ggx").SetMagicLoginAdvertisement
local fFlagEnableRecordLogin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableRecordLogin
local fFlagFixPreviousAccountsListEntries = SharedFlags.FFlagFixPreviousAccountsListEntries
local fFlagUseSignalsForCountryCode = SharedFlags.FFlagUseSignalsForCountryCode
local fFlagEnablePioneerPostAuthGameJoin = SharedFlags.FFlagEnablePioneerPostAuthGameJoin
local fFlagEdpGameLeavePromptsPassIsRecentInstall = SharedFlags.FFlagEdpGameLeavePromptsPassIsRecentInstall

local getCountryCodeStore = if fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dAW").GetCountryCodeStore else nil

local updateLoginEntryData = AuthCommon.Utils.updateLoginEntryData
local ensureLoginEntry = AuthCommon.Utils.ensureLoginEntry

local function handleUserLoggedIn(object, object2)
	GuiService:BroadcastNotification(object:toJsonData(), module12.DID_LOG_IN)

	if fFlagUseSignalsForAuthenticationStatus then
		getAuthenticationStatusStore(false).setAuthenticationStatus(module11.LOGGED_IN)
	else
		object2:dispatch(setAuthenticationStatus(module11.LOGGED_IN))
	end
end

local function navigateToPostAuthLandingPage(object, p2, p3, p4, p5)
	local v5 = not (linkingProtocol:getLastLuaURL() == nil) and linkingProtocol:getLastLuaURL() ~= ""
	local v6 = not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and ""
		or module7.getSignupActionRequired()

	local function isRestrictedByUserAccessSource(p6): boolean
		if fFlagUseSignalsForUserAccess then
			return isRestrictedBySource(p6) == true
		end

		local userAccess = object:getState().UserAccess

		return userAccess ~= nil
			and userAccess.restrictionDetail ~= nil
			and userAccess.restrictionDetail.source == p6
	end

	local function resetToPostAuthLanding()
		if getFFlagFixPlatformRestrictedHomeClobber() then
			local platformAccess = module9.PlatformAccess
			local v7

			if fFlagUseSignalsForUserAccess then
				v7 = isRestrictedBySource(platformAccess) == true
			else
				local userAccess = object:getState().UserAccess

				if userAccess == nil or userAccess.restrictionDetail == nil then
					v7 = false
				else
					v7 = userAccess.restrictionDetail.source == platformAccess
				end
			end

			if v7 then
				return
			end
		end

		if fFlagLuaAppBirthdayComplianceGate then
			local birthdayCompliance = module9.BirthdayCompliance
			local v7

			if fFlagUseSignalsForUserAccess then
				v7 = isRestrictedBySource(birthdayCompliance) == true
			else
				local userAccess = object:getState().UserAccess

				if userAccess == nil or userAccess.restrictionDetail == nil then
					v7 = false
				else
					v7 = userAccess.restrictionDetail.source == birthdayCompliance
				end
			end

			if v7 then
				return
			end
		end

		object:dispatch(module4({
			{ name = p3 }
		}))
	end

	if p2 and p4.isUnder13 then
		object:dispatch(module4({
			{ name = module8.UAppBlock }
		}))
	elseif fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch() then
		resetToPostAuthLanding()
	elseif v6 == "auth" then
		if module23() or module24() then
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
		handlePreHomePageRouting(p5, object, module4):andThen(function(p6)
			if not (p6 or v5) then
				resetToPostAuthLanding()
			end
		end)
	elseif not v5 then
		resetToPostAuthLanding()
	end
end

local function fn()
	local jsonEncode = HttpService:JSONEncode({ server = ContentProvider.BaseUrl })

	if getFFlagKeystoreAutoLoginAvailable() then
		return module19(jsonEncode)
	end

	return default:deleteAllCredentialsFromiOSKeychain(
		default.CredentialsTypes.iosKeychainPassword,
		jsonEncode,
		keystoreConstants.KeystoreTimeout
	)
end

local function handleAccountInfo(p2, p3, object, p4, object2, p5, callback, object3, p6, p7)
	local v5 = not TracerService and "" or TracerService:StartSpan("luaAccountInfo", "")

	if object3 then
		object3:logEventOnce("lua_auth_request_begin")
	end

	module(p2):andThen(function(p8)
		if object3 then
			object3:logEventOnce("lua_auth_request_end")
		end

		if TracerService and v5 ~= "" then
			TracerService:FinishSpan(v5)
		end

		RbxAnalyticsService:ReportCounter("Network_AccountInfo_Ok")
		module13(module14.Success, 1)

		local v6 = defineFastFlag and module7.getAccountSwitchStartupGameParams()

		if v6 then
			module7.clearAccountSwitchStartupGameParams()
			module7.flush()

			if not (fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch()) then
				experienceService:LaunchExperience(v6, "AuthTicket", nil)
			end
		end

		local v7 = Models.fromUserInfoRequest(p8)
		local v8 = false

		if fFlagEdpGameLeavePromptsPassIsRecentInstall then
			task.defer(module18, v7.userId)
		end

		if fFlagEnableRecordLogin then
			pcall(function()
				if fFlagFixPreviousAccountsListEntries then
					ensureLoginEntry(tostring(v7.userId), {
						username = v7.username,
						displayName = v7.displayName
					})
				else
					updateLoginEntryData(v7.userId, { displayName = v7.displayName })
				end
			end)
		end

		if object2:getState().CentralOverlay.OverlayType == module16.AccountAuthenticationFailureOverlay then
			object2:dispatch(module15())

			if not fFlagEnablePostAuthRoutingInAllCases and v7:isEqual(p3) then
				navigateToPostAuthLandingPage(object2, p6, p5, v7, p2)
				v8 = true
			end
		end

		if not v7:isEqual(p3) then
			v7:setToLocalPlayer()
			v7:setToLocalStorage()

			if p4 then
				object2:dispatch(module6())
				p7 = false
			end

			object2:dispatch(getLocalUser())

			if fFlagUseSignalsForCountryCode then
				getCountryCodeStore(false).setCountryCode(v7.countryCode)
			else
				object2:dispatch(receivedUserCountryCode(v7.countryCode))
			end

			if not fFlagEnablePostAuthRoutingInAllCases then
				navigateToPostAuthLandingPage(object2, p6, p5, v7, p2)
				v8 = true
			end

			RoactAppExperiment.initializeUserLayers(v7.userId)
		end

		if
			fFlagEnablePostAuthRoutingInAllCases
			or fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch() and not v8
		then
			navigateToPostAuthLandingPage(object2, p6, p5, v7, p2)
		end

		if not p7 then
			p7 = true
			callback()
		end

		local v9 = {}
		table.insert(v9, object:andThen(function(p9)
			module7.setRobloxLocaleId(p9.generalExperienceLocale)
			module7.setGameLocaleId(p9.ugcLocale)
			LocalizationService:SetRobloxLocaleId(p9.generalExperienceLocale)
		end))

		local v10 = module5(p2, v7.userId)

		object2:dispatch(module21(p2))
		local v11

		if (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or module7.getSignupActionRequired()) == "auth" then
			v11 = module23()
		else
			v11 = false
		end

		local v12 = fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch()
		table.insert(v9, v10:andThen(function(p9)
			module7.setAuthenticatedTheme(p9)

			if not (v11 or v12) then
				MemStorageService:Fire(module10.ThemeUpdate, p9)
			end
		end))

		module3.Batch(v9):andThen(function()
			module7.flush()
		end)
		handleUserLoggedIn(v7, object2)

		if fFlagEnableMagicLogin then
			setMagicLoginAdvertisement(true)
		end
	end, function(p8)
		if p8.HttpError == Enum.HttpError.ConnectFail then
			RbxAnalyticsService:ReportCounter("Network_AccountInfo_None")
		else
			RbxAnalyticsService:ReportCounter("Network_AccountInfo_Error")
		end

		if p8.StatusCode == statusCodes.UNAUTHORIZED then
			module13(module14.Failure401Unauthenticated, 1)
		else
			module13(module14.FailureUnknownError, 1)
		end

		module13(module14.Failure, 1)

		if p8.StatusCode ~= statusCodes.UNAUTHORIZED then
			module20(object2, function()
				handleAccountInfo(p2, p3, object, p4, object2, p5, callback)
			end)

			return
		end

		pcall(function()
			default2:logRobloxTelemetryCounter(telemetryConfigs.NoCookieForCachedUserTelemetryConfig, 1)
		end)

		if module25 or getFFlagKeystoreAutoLoginAvailable() then
			keystoreAnalyticsEvents.sendPageLoadEvent(keystoreEventConstants.origin.remoteLogoutDelete)
			TelemetryService:LogCounter(keystoreDeleteCredentialsTelemetryConfig, {
				customFields = { reason = "remote_logout" }
			}, 1)

			fn()
		end

		if defineFastFlag then
			module7.clearAccountSwitchStartupGameParams()
			module7.flush()
		end

		module17(p4, object2, p2, object, module22.UnauthorizedAutoLogin, nil, nil, false)
	end)
end

return handleAccountInfo
