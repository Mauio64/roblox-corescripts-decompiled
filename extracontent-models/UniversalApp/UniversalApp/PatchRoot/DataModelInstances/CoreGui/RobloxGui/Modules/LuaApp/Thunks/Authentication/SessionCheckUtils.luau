local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
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
local ShowAccountAuthenticationFailureOverlay = require(Modules.LuaApp.Thunks.Authentication.ShowAccountAuthenticationFailureOverlay)
local DeleteAllCredentialsFromKeystore = require(Modules.LuaApp.Thunks.Authentication.DeleteAllCredentialsFromKeystore)
local ApiFetchUsersRoles = require(Modules.LuaApp.Thunks.ApiFetchUsersRoles)
local ReceivedUserCountryCode = require(CorePackages.Workspace.Packages.CountryCode).ReceivedUserCountryCode
local v31 = game:GetEngineFeature("AppTracing") and game:GetService("TracerService") or nil
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local GetFFlagPasskeySignupEnabled = require(Modules.LuaApp.Flags.GetFFlagPasskeySignupEnabled)
local GetFFlagEnableMultiPageSignupExperiment = require(Modules.LuaApp.Flags.GetFFlagEnableMultiPageSignupExperiment)
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
local GetFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local GetFFlagAddPromCounterToKeystoreOps = SharedFlags.GetFFlagAddPromCounterToKeystoreOps

local function handleUserLoggedIn(p1, p2) -- line: 75
	-- upvalues: GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
	GuiService:BroadcastNotification(p1:toJsonData(), NotificationType.DID_LOG_IN)
	p2:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
end
local function navigateToPostAuthLandingPage(p3, p4, p5, p6, p7) -- line: 80
	-- upvalues: AppStorageUtilities (copy), ResetNavigationHistory (copy), AppPage (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), FFlagPreHomePageRoutingEnabled (copy), FFlagPasskeyUpsellEnabled (copy), HandlePreHomePageRouting (copy)
	local v70 = not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()

	if p4 and p6.isUnder13 then
		p3:dispatch(ResetNavigationHistory({{
			name = AppPage.UAppBlock
		}}))

		return
	end

	if v70 == "auth" then
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
		HandlePreHomePageRouting(p7, p3, ResetNavigationHistory):andThen(function(p8) -- line: 101
			-- upvalues: p3 (copy), ResetNavigationHistory (copy), p5 (copy)
			if not p8 then
				p3:dispatch(ResetNavigationHistory({{
					name = p5
				}}))
			end
		end)

		return
	end

	p3:dispatch(ResetNavigationHistory({{
		name = p5
	}}))
end
local function clearAuthFailureOverlayOnSuccess(p9, p10, p11, p12, p13, p14) -- line: 111
	-- upvalues: OverlayType (copy), CloseAccountAuthenticationFailureOverlay (copy), navigateToPostAuthLandingPage (copy)
	if p9:getState().CentralOverlay.OverlayType == OverlayType.AccountAuthenticationFailureOverlay then
		p9:dispatch(CloseAccountAuthenticationFailureOverlay())

		if p10:isEqual(p11) then
			navigateToPostAuthLandingPage(p9, p12, p13, p10, p14)
		end
	end
end
local function handleUserMismatchAndUpdatePreloadStarted(p15, p16, p17, p18, p19, p20, p21, p22) -- line: 133
	-- upvalues: ClearApp (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), navigateToPostAuthLandingPage (copy), RoactAppExperiment (copy)
	if not p15:isEqual(p16) then
		p15:setToLocalPlayer()
		p15:setToLocalStorage()

		if p18 then
			p17:dispatch(ClearApp())
			p19 = false
		end

		p17:dispatch(GetLocalUser())
		p17:dispatch(ReceivedUserCountryCode(p15.countryCode))
		navigateToPostAuthLandingPage(p17, p20, p21, p15, p22)
		RoactAppExperiment.initializeUserLayers(p15.userId)
	end

	return p19
end
local function fetchAndApplyUserSettings(p23, p24, p25, p26) -- line: 165
	-- upvalues: AppStorageUtilities (copy), LocalizationService (copy), FetchTheme (copy), ApiFetchUsersRoles (copy), GetFFlagPasskeySignupEnabled (copy), MemStorageService (copy), MemStorageKeys (copy), PromiseUtilities (copy)
	local t1 = {}

	table.insert(t1, p23:andThen(function(p27) -- line: 169
		-- upvalues: AppStorageUtilities (copy), LocalizationService (copy)
		AppStorageUtilities.setRobloxLocaleId(p27.generalExperienceLocale)
		AppStorageUtilities.setGameLocaleId(p27.ugcLocale)
		LocalizationService:SetRobloxLocaleId(p27.generalExperienceLocale)
	end))

	local v90 = FetchTheme(p24, p25.userId)

	p26:dispatch(ApiFetchUsersRoles(p24))

	local v91 = (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()) == "auth" and GetFFlagPasskeySignupEnabled()

	table.insert(t1, v90:andThen(function(p28) -- line: 187
		-- upvalues: AppStorageUtilities (copy), v91 (copy), MemStorageService (copy), MemStorageKeys (copy)
		AppStorageUtilities.setAuthenticatedTheme(p28)

		if not v91 then
			MemStorageService:Fire(MemStorageKeys.ThemeUpdate, p28)
		end
	end))
	PromiseUtilities.Batch(t1):andThen(function() -- line: 197
		-- upvalues: AppStorageUtilities (copy)
		AppStorageUtilities.flush()
	end)
end
local function v58() -- line: 202
	-- upvalues: HttpService (copy), ContentProvider (copy), GetFFlagKeystoreAutoLoginAvailable (copy), DeleteAllCredentialsFromKeystore (copy), default (copy), KeystoreConstants (copy)
	local json = HttpService:JSONEncode({
		server = ContentProvider.BaseUrl
	})

	if GetFFlagKeystoreAutoLoginAvailable() then
		return DeleteAllCredentialsFromKeystore(json)
	end

	return default:deleteAllCredentialsFromiOSKeychain(default.CredentialsTypes.iosKeychainPassword, json, KeystoreConstants.KeystoreTimeout)
end
local function reportAccountInfoAnalytics(p29) -- line: 217
	-- upvalues: StatusCodes (copy), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy)
	if p29 == StatusCodes.UNAUTHORIZED then
		reportEphemeralCounter(AppSessionCheckCounterNames.Failure401Unauthenticated, 1)
	else
		reportEphemeralCounter(AppSessionCheckCounterNames.FailureUnknownError, 1)
	end

	reportEphemeralCounter(AppSessionCheckCounterNames.Failure, 1)
end
local function handleUnauthorizedError(p30, p31, p32, p33) -- line: 227
	-- upvalues: default2 (copy), TelemetryConfigs (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreDeleteCredentialsTelemetryConfig (copy), v58 (copy), ResetOnNoAccountInfoFound (copy), luaLogoutReasonNames (copy)
	spawn(function() -- line: 228
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

		v58()
	end

	ResetOnNoAccountInfoFound(p30, p31, p32, p33, luaLogoutReasonNames.UnauthorizedAutoLogin, nil, nil, false)
end
local function handleRetryableError(p34, p35, p36, p37, p38, p39, p40) -- line: 261
	-- upvalues: ShowAccountAuthenticationFailureOverlay (copy)
	ShowAccountAuthenticationFailureOverlay(p34, function() -- line: 270
		-- upvalues: p36 (copy), p35 (copy), p37 (copy), p38 (copy), p34 (copy), p39 (copy), p40 (copy)
		handleAccountInfoFromLua(p36, p35, p37, p38, p34, p39, p40)
	end)
end
local function handleAccountInfoError(p41, p42, p43, p44, p45, p46, p47, p48) -- line: 283
	-- upvalues: StatusCodes (copy), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy), handleUnauthorizedError (copy), ShowAccountAuthenticationFailureOverlay (copy)
	if p41 == StatusCodes.UNAUTHORIZED then
		reportEphemeralCounter(AppSessionCheckCounterNames.Failure401Unauthenticated, 1)
	else
		reportEphemeralCounter(AppSessionCheckCounterNames.FailureUnknownError, 1)
	end

	reportEphemeralCounter(AppSessionCheckCounterNames.Failure, 1)

	if p41 == StatusCodes.UNAUTHORIZED then
		handleUnauthorizedError(p42, p43, p44, p45)

		return
	end

	ShowAccountAuthenticationFailureOverlay(p43, function() -- line: 270
		-- upvalues: p46 (copy), p44 (copy), p45 (copy), p42 (copy), p43 (copy), p47 (copy), p48 (copy)
		handleAccountInfoFromLua(p46, p44, p45, p42, p43, p47, p48)
	end)
end

function handleAccountInfoFromLua(p49, p50, p51, p52, p53, p54, p55, p56, p57, p58) -- line: 312
	-- upvalues: v31 (copy), GetUserAppLaunchInfo (copy), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy), User (copy), clearAuthFailureOverlayOnSuccess (copy), handleUserMismatchAndUpdatePreloadStarted (copy), fetchAndApplyUserSettings (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), StatusCodes (copy), handleUnauthorizedError (copy), ShowAccountAuthenticationFailureOverlay (copy)
	local s1 = ""

	if v31 then
		s1 = v31:StartSpan("luaAccountInfo", "")
	end

	if p56 then
		p56:logEventOnce("lua_auth_request_begin")
	end

	GetUserAppLaunchInfo(p50):andThen(function(p59) -- line: 332
		-- upvalues: p56 (copy), v31 (copy), s1 (ref), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy), User (copy), clearAuthFailureOverlayOnSuccess (copy), p53 (copy), p49 (copy), p57 (copy), p54 (copy), p50 (copy), p58 (ref), handleUserMismatchAndUpdatePreloadStarted (copy), p52 (copy), p55 (copy), fetchAndApplyUserSettings (copy), p51 (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
		if p56 then
			p56:logEventOnce("lua_auth_request_end")
		end

		if v31 and s1 ~= "" then
			v31:FinishSpan(s1)
		end

		reportEphemeralCounter(AppSessionCheckCounterNames.Success, 1)

		local v148 = User.fromUserInfoRequest(p59)

		clearAuthFailureOverlayOnSuccess(p53, v148, p49, p57, p54, p50)
		p58 = handleUserMismatchAndUpdatePreloadStarted(v148, p49, p53, p52, p58, p57, p54, p50)

		if not p58 then
			p58 = true
			p55()
		end

		fetchAndApplyUserSettings(p51, p50, v148, p53)

		local v149 = p53

		GuiService:BroadcastNotification(v148:toJsonData(), NotificationType.DID_LOG_IN)
		v149:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
	end, function(p60) -- line: 380
		-- upvalues: p52 (copy), p53 (copy), p50 (copy), p51 (copy), p49 (copy), p54 (copy), p55 (copy), StatusCodes (copy), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy), handleUnauthorizedError (copy), ShowAccountAuthenticationFailureOverlay (copy)
		local StatusCode = p60.StatusCode
		local v152 = p52
		local v153 = p53
		local v154 = p50
		local v155 = p51
		local v156 = p49
		local v157 = p54
		local v158 = p55

		if StatusCode == StatusCodes.UNAUTHORIZED then
			reportEphemeralCounter(AppSessionCheckCounterNames.Failure401Unauthenticated, 1)
		else
			reportEphemeralCounter(AppSessionCheckCounterNames.FailureUnknownError, 1)
		end

		reportEphemeralCounter(AppSessionCheckCounterNames.Failure, 1)

		if StatusCode == StatusCodes.UNAUTHORIZED then
			handleUnauthorizedError(v152, v153, v154, v155)

			return
		end

		ShowAccountAuthenticationFailureOverlay(v153, function() -- line: 270
			-- upvalues: v156 (copy), v154 (copy), v155 (copy), v152 (copy), v153 (copy), v157 (copy), v158 (copy)
			handleAccountInfoFromLua(v156, v154, v155, v152, v153, v157, v158)
		end)
	end)
end
function handleSessionCheckSuccess(p61, p62, p63, p64, p65, p66, p67, _, p69, p70) -- line: 394
	-- upvalues: User (copy), clearAuthFailureOverlayOnSuccess (copy), handleUserMismatchAndUpdatePreloadStarted (copy), fetchAndApplyUserSettings (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
	local v135 = User.fromLocalStorage()

	clearAuthFailureOverlayOnSuccess(p65, v135, p62, p69, p66, p61)

	if not handleUserMismatchAndUpdatePreloadStarted(v135, p62, p65, p64, p70, p69, p66, p61) then
		p67()
	end

	fetchAndApplyUserSettings(p63, p61, v135, p65)
	GuiService:BroadcastNotification(v135:toJsonData(), NotificationType.DID_LOG_IN)
	p65:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
end
function handleSessionCheckFailure(p71, p72, p73, p74, p75, p76, p77, p78) -- line: 442
	-- upvalues: StatusCodes (copy), reportEphemeralCounter (copy), AppSessionCheckCounterNames (copy), handleUnauthorizedError (copy), ShowAccountAuthenticationFailureOverlay (copy)
	if p71 == StatusCodes.UNAUTHORIZED then
		reportEphemeralCounter(AppSessionCheckCounterNames.Failure401Unauthenticated, 1)
	else
		reportEphemeralCounter(AppSessionCheckCounterNames.FailureUnknownError, 1)
	end

	reportEphemeralCounter(AppSessionCheckCounterNames.Failure, 1)

	if p71 == StatusCodes.UNAUTHORIZED then
		handleUnauthorizedError(p72, p73, p74, p75)

		return
	end

	ShowAccountAuthenticationFailureOverlay(p73, function() -- line: 270
		-- upvalues: p76 (copy), p74 (copy), p75 (copy), p72 (copy), p73 (copy), p77 (copy), p78 (copy)
		handleAccountInfoFromLua(p76, p74, p75, p72, p73, p77, p78)
	end)
end

return {
	handleSessionCheckSuccess = handleSessionCheckSuccess,
	handleSessionCheckFailure = handleSessionCheckFailure,
	handleAccountInfoFromLua = handleAccountInfoFromLua
}
