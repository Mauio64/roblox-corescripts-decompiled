local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Modules = CoreGui.RobloxGui.Modules
local GetUserAppLaunchInfo = require(Modules.LuaApp.Http.Requests.GetUserAppLaunchInfo)
local User = require(script.Parent.User)
local GetLocalUser = require(CorePackages.Workspace.Packages.UserLib).Thunks.GetLocalUser
local PromiseUtilities = require(Modules.LuaApp.PromiseUtilities)
local SetAuthenticationStatus = require(CorePackages.Workspace.Packages.AuthenticationStatus).Actions.SetAuthenticationStatus
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local FetchTheme = require(Modules.LuaApp.Thunks.FetchTheme)
local ClearApp = require(script.Parent.ClearApp)
local AppStorageUtilities = require(script.Parent.AppStorageUtilities)
local AppPage = require(Modules.LuaApp.AppPage)
local RestrictionSource = require(Modules.LuaApp.Models.UserModerationApi.RestrictionSource)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local reportEphemeralCounter = require(Modules.LuaApp.Analytics.Events.reportEphemeralCounter)
local AppSessionCheckCounterNames = require(Modules.LuaApp.Analytics.Events.AppSessionCheckCounterNames)
local StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local CloseAccountAuthenticationFailureOverlay = require(Modules.LuaApp.Thunks.CloseAccountAuthenticationFailureOverlay)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local ResetOnNoAccountInfoFound = require(Modules.LuaApp.Thunks.Authentication.ResetOnNoAccountInfoFound)
local DeleteAllCredentialsFromKeystore = require(Modules.LuaApp.Thunks.Authentication.DeleteAllCredentialsFromKeystore)
local ShowAccountAuthenticationFailureOverlay = require(Modules.LuaApp.Thunks.Authentication.ShowAccountAuthenticationFailureOverlay)
local ApiFetchUsersRoles = require(Modules.LuaApp.Thunks.ApiFetchUsersRoles)
local ExperienceService = require(CorePackages.Workspace.Packages.ExperienceService).ExperienceService
local ReceivedUserCountryCode = require(CorePackages.Workspace.Packages.CountryCode).ReceivedUserCountryCode
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local v35 = game:GetEngineFeature("AppTracing") and game:GetService("TracerService") or nil
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local GetFFlagPasskeySignupEnabled = require(Modules.LuaApp.Flags.GetFFlagPasskeySignupEnabled)
local GetFFlagEnableMultiPageSignupExperiment = require(Modules.LuaApp.Flags.GetFFlagEnableMultiPageSignupExperiment)
local v39 = game:DefineFastFlag("EnableLaunchAppCheckForAccountSwitchGameParams", false)
local FFlagEnableIosKeychainLoginLua = require(Modules.LuaApp.Flags.FFlagEnableIosKeychainLoginLua)
local HttpService = game:GetService("HttpService")
local default = require(CorePackages.Workspace.Packages.CredentialsProtocol).CredentialsProtocol.default
local ContentProvider = game:GetService("ContentProvider")
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local KeystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local KeystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local KeystoreConstants = AuthCommon.Common.KeystoreConstants
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local KeystoreDeleteCredentialsTelemetryConfig = TelemetryConfigs.KeystoreDeleteCredentialsTelemetryConfig
local TelemetryService = game:GetService("TelemetryService")
local default2 = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local HandlePreHomePageRouting = require(CorePackages.Workspace.Packages.PreHomePage).HandlePreHomePageRouting
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPreHomePageRoutingEnabled = SharedFlags.FFlagPreHomePageRoutingEnabled
local FFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local FFlagEnableMagicLogin = SharedFlags.FFlagEnableMagicLogin
local FFlagEnablePostAuthRoutingInAllCases = SharedFlags.FFlagEnablePostAuthRoutingInAllCases
local GetFFlagFixPlatformRestrictedHomeClobber = SharedFlags.GetFFlagFixPlatformRestrictedHomeClobber
local GetFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local GetFFlagAddPromCounterToKeystoreOps = SharedFlags.GetFFlagAddPromCounterToKeystoreOps
local SetMagicLoginAdvertisement = require(CorePackages.Workspace.Packages.LoginV2.Thunks).SetMagicLoginAdvertisement
local FFlagEnableRecordLogin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableRecordLogin
local updateLoginEntryData = AuthCommon.Utils.updateLoginEntryData

local function handleUserLoggedIn(p1, p2) -- line: 87
	-- upvalues: GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
	GuiService:BroadcastNotification(p1:toJsonData(), NotificationType.DID_LOG_IN)
	p2:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
end
local function navigateToPostAuthLandingPage(p3, p4, p5, p6, p7) -- line: 92
	-- upvalues: LinkingProtocol (copy), AppStorageUtilities (copy), RestrictionSource (copy), GetFFlagFixPlatformRestrictedHomeClobber (copy), ResetNavigationHistory (copy), AppPage (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), FFlagPreHomePageRoutingEnabled (copy), FFlagPasskeyUpsellEnabled (copy), HandlePreHomePageRouting (copy)
	local v75 = LinkingProtocol:getLastLuaURL() ~= nil and LinkingProtocol:getLastLuaURL() ~= ""
	local v76 = not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()

	local function isPlatformAccessRestricted() -- line: 103
		-- upvalues: p3 (copy), RestrictionSource (copy)
		local UserAccess = p3:getState().UserAccess

		return UserAccess ~= nil and (UserAccess.restrictionDetail ~= nil and UserAccess.restrictionDetail.source == RestrictionSource.PlatformAccess)
	end
	local function resetToPostAuthLanding() -- line: 110
		-- upvalues: GetFFlagFixPlatformRestrictedHomeClobber (copy), p3 (copy), RestrictionSource (copy), ResetNavigationHistory (copy), p5 (copy)
		if GetFFlagFixPlatformRestrictedHomeClobber() then
			local UserAccess = p3:getState().UserAccess

			if UserAccess ~= nil and (UserAccess.restrictionDetail ~= nil and UserAccess.restrictionDetail.source == RestrictionSource.PlatformAccess) then
				return
			end
		end

		p3:dispatch(ResetNavigationHistory({{
			name = p5
		}}))
	end

	if p4 and p6.isUnder13 then
		p3:dispatch(ResetNavigationHistory({{
			name = AppPage.UAppBlock
		}}))

		return
	end

	if v76 == "auth" then
		if GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment() then
			p3:dispatch(ResetNavigationHistory({{
				name = AppPage.AddAuthMethodPage
			}}))

			return
		end

		AppStorageUtilities.setSignupActionRequired("")
		AppStorageUtilities.flush()
		p3:dispatch(ResetNavigationHistory({{
			name = p5
		}}))

		return
	end

	if FFlagPreHomePageRoutingEnabled or FFlagPasskeyUpsellEnabled then
		HandlePreHomePageRouting(p7, p3, ResetNavigationHistory):andThen(function(p8) -- line: 128
			-- upvalues: v75 (copy), resetToPostAuthLanding (copy)
			if not p8 and not v75 then
				resetToPostAuthLanding()
			end
		end)

		return
	end

	if not v75 then
		resetToPostAuthLanding()
	end
end
local function v66() -- line: 140
	-- upvalues: HttpService (copy), ContentProvider (copy), GetFFlagKeystoreAutoLoginAvailable (copy), DeleteAllCredentialsFromKeystore (copy), default (copy), KeystoreConstants (copy)
	local json = HttpService:JSONEncode({
		server = ContentProvider.BaseUrl
	})

	if GetFFlagKeystoreAutoLoginAvailable() then
		return DeleteAllCredentialsFromKeystore(json)
	end

	return default:deleteAllCredentialsFromiOSKeychain(default.CredentialsTypes.iosKeychainPassword, json, KeystoreConstants.KeystoreTimeout)
end
local function handleAccountInfo(p9, p10, p11, p12, p13, p14, p15, p16, p17, p18) -- line: 155
	-- upvalues: v35 (copy), GetUserAppLaunchInfo (copy), RbxAnalyticsService (copy), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy), v39 (copy), AppStorageUtilities (copy), ExperienceService (copy), User (copy), FFlagEnableRecordLogin (copy), updateLoginEntryData (copy), OverlayType (copy), CloseAccountAuthenticationFailureOverlay (copy), FFlagEnablePostAuthRoutingInAllCases (copy), navigateToPostAuthLandingPage (copy), ClearApp (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), RoactAppExperiment (copy), LocalizationService (copy), FetchTheme (copy), ApiFetchUsersRoles (copy), GetFFlagPasskeySignupEnabled (copy), MemStorageService (copy), MemStorageKeys (copy), PromiseUtilities (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), FFlagEnableMagicLogin (copy), SetMagicLoginAdvertisement (copy), StatusCodes (copy), default2 (copy), TelemetryConfigs (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreDeleteCredentialsTelemetryConfig (copy), v66 (copy), ResetOnNoAccountInfoFound (copy), luaLogoutReasonNames (copy), ShowAccountAuthenticationFailureOverlay (copy), handleAccountInfo (copy)
	local s1 = ""

	if v35 then
		s1 = v35:StartSpan("luaAccountInfo", "")
	end

	if p16 then
		p16:logEventOnce("lua_auth_request_begin")
	end

	GetUserAppLaunchInfo(p9):andThen(function(p19) -- line: 175
		-- upvalues: p16 (copy), v35 (copy), s1 (ref), RbxAnalyticsService (copy), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy), v39 (copy), AppStorageUtilities (copy), ExperienceService (copy), User (copy), FFlagEnableRecordLogin (copy), updateLoginEntryData (copy), p13 (copy), OverlayType (copy), CloseAccountAuthenticationFailureOverlay (copy), FFlagEnablePostAuthRoutingInAllCases (copy), p10 (copy), navigateToPostAuthLandingPage (copy), p17 (copy), p14 (copy), p9 (copy), p12 (copy), ClearApp (copy), p18 (ref), GetLocalUser (copy), ReceivedUserCountryCode (copy), RoactAppExperiment (copy), p15 (copy), p11 (copy), LocalizationService (copy), FetchTheme (copy), ApiFetchUsersRoles (copy), GetFFlagPasskeySignupEnabled (copy), MemStorageService (copy), MemStorageKeys (copy), PromiseUtilities (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), FFlagEnableMagicLogin (copy), SetMagicLoginAdvertisement (copy)
		if p16 then
			p16:logEventOnce("lua_auth_request_end")
		end

		if v35 and s1 ~= "" then
			v35:FinishSpan(s1)
		end

		RbxAnalyticsService:ReportCounter("Network_AccountInfo_Ok")
		reportEphemeralCounter(AppSessionCheckCounterNames.Success, 1)

		if v39 then
			local v96 = AppStorageUtilities.getAccountSwitchStartupGameParams()

			if v96 then
				AppStorageUtilities.clearAccountSwitchStartupGameParams()
				AppStorageUtilities.flush()
				ExperienceService:LaunchExperience(v96, "AuthTicket", nil)
			end
		end

		local v97 = User.fromUserInfoRequest(p19)

		if FFlagEnableRecordLogin then
			pcall(function() -- line: 201
				-- upvalues: updateLoginEntryData (copy), v97 (copy)
				updateLoginEntryData(v97.userId, {
					displayName = v97.displayName
				})
			end)
		end

		if p13:getState().CentralOverlay.OverlayType == OverlayType.AccountAuthenticationFailureOverlay then
			p13:dispatch(CloseAccountAuthenticationFailureOverlay())

			if not FFlagEnablePostAuthRoutingInAllCases and v97:isEqual(p10) then
				navigateToPostAuthLandingPage(p13, p17, p14, v97, p9)
			end
		end

		if not v97:isEqual(p10) then
			v97:setToLocalPlayer()
			v97:setToLocalStorage()

			if p12 then
				p13:dispatch(ClearApp())
				p18 = false
			end

			p13:dispatch(GetLocalUser())
			p13:dispatch(ReceivedUserCountryCode(v97.countryCode))

			if not FFlagEnablePostAuthRoutingInAllCases then
				navigateToPostAuthLandingPage(p13, p17, p14, v97, p9)
			end

			RoactAppExperiment.initializeUserLayers(v97.userId)
		end

		if FFlagEnablePostAuthRoutingInAllCases then
			navigateToPostAuthLandingPage(p13, p17, p14, v97, p9)
		end

		if not p18 then
			p18 = true
			p15()
		end

		local t1 = {}

		table.insert(t1, p11:andThen(function(p20) -- line: 267
			-- upvalues: AppStorageUtilities (copy), LocalizationService (copy)
			AppStorageUtilities.setRobloxLocaleId(p20.generalExperienceLocale)
			AppStorageUtilities.setGameLocaleId(p20.ugcLocale)
			LocalizationService:SetRobloxLocaleId(p20.generalExperienceLocale)
		end))

		local v99 = FetchTheme(p9, v97.userId)

		p13:dispatch(ApiFetchUsersRoles(p9))

		local v100 = (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()) == "auth" and GetFFlagPasskeySignupEnabled()

		table.insert(t1, v99:andThen(function(p21) -- line: 285
			-- upvalues: AppStorageUtilities (copy), v100 (copy), MemStorageService (copy), MemStorageKeys (copy)
			AppStorageUtilities.setAuthenticatedTheme(p21)

			if not v100 then
				MemStorageService:Fire(MemStorageKeys.ThemeUpdate, p21)
			end
		end))
		PromiseUtilities.Batch(t1):andThen(function() -- line: 295
			-- upvalues: AppStorageUtilities (copy)
			AppStorageUtilities.flush()
		end)

		local v101 = p13

		GuiService:BroadcastNotification(v97:toJsonData(), NotificationType.DID_LOG_IN)
		v101:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))

		if FFlagEnableMagicLogin then
			SetMagicLoginAdvertisement(true)
		end
	end, function(p22) -- line: 303
		-- upvalues: RbxAnalyticsService (copy), StatusCodes (copy), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy), default2 (copy), TelemetryConfigs (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreDeleteCredentialsTelemetryConfig (copy), v66 (copy), v39 (copy), AppStorageUtilities (copy), ResetOnNoAccountInfoFound (copy), p12 (copy), p13 (copy), p9 (copy), p11 (copy), luaLogoutReasonNames (copy), ShowAccountAuthenticationFailureOverlay (copy), handleAccountInfo (copy), p10 (copy), p14 (copy), p15 (copy)
		if p22.HttpError ~= Enum.HttpError.ConnectFail then
			RbxAnalyticsService:ReportCounter("Network_AccountInfo_Error")
		else
			RbxAnalyticsService:ReportCounter("Network_AccountInfo_None")
		end

		if p22.StatusCode == StatusCodes.UNAUTHORIZED then
			reportEphemeralCounter(AppSessionCheckCounterNames.Failure401Unauthenticated, 1)
		else
			reportEphemeralCounter(AppSessionCheckCounterNames.FailureUnknownError, 1)
		end

		reportEphemeralCounter(AppSessionCheckCounterNames.Failure, 1)

		if p22.StatusCode == StatusCodes.UNAUTHORIZED then
			pcall(function() -- line: 319
				-- upvalues: default2 (copy), TelemetryConfigs (copy)
				default2:logRobloxTelemetryCounter(TelemetryConfigs.NoCookieForCachedUserTelemetryConfig, 1)
			end)

			if FFlagEnableIosKeychainLoginLua or GetFFlagKeystoreAutoLoginAvailable() then
				KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.remoteLogoutDelete)

				if GetFFlagAddPromCounterToKeystoreOps() then
					TelemetryService:LogCounter(KeystoreDeleteCredentialsTelemetryConfig, {
						customFields = {
							reason = "remote_logout"
						}
					}, 1)
				end

				v66()
			end

			if v39 then
				AppStorageUtilities.clearAccountSwitchStartupGameParams()
				AppStorageUtilities.flush()
			end

			ResetOnNoAccountInfoFound(p12, p13, p9, p11, luaLogoutReasonNames.UnauthorizedAutoLogin, nil, nil, false)

			return
		end

		ShowAccountAuthenticationFailureOverlay(p13, function() -- line: 359
			-- upvalues: handleAccountInfo (copy), p9 (copy), p10 (copy), p11 (copy), p12 (copy), p13 (copy), p14 (copy), p15 (copy)
			handleAccountInfo(p9, p10, p11, p12, p13, p14, p15)
		end)
	end)
end

return handleAccountInfo
