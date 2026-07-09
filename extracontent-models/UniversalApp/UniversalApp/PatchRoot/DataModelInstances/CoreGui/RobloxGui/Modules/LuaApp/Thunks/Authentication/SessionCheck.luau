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
local AppStorageUtilities = require(script.Parent.AppStorageUtilities)
local AppPage = require(Modules.LuaApp.AppPage)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local CloseAccountAuthenticationFailureOverlay = require(Modules.LuaApp.Thunks.CloseAccountAuthenticationFailureOverlay)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local ApiFetchUsersRoles = require(Modules.LuaApp.Thunks.ApiFetchUsersRoles)
local ReceivedUserCountryCode = require(CorePackages.Workspace.Packages.CountryCode).ReceivedUserCountryCode
local HttpService = game:GetService("HttpService")
local default = require(CorePackages.Workspace.Packages.CredentialsProtocol).CredentialsProtocol.default
local ContentProvider = game:GetService("ContentProvider")
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local KeystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local KeystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local KeystoreConstants = AuthCommon.Common.KeystoreConstants
local HandlePreHomePageRouting = require(CorePackages.Workspace.Packages.PreHomePage).HandlePreHomePageRouting
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPreHomePageRoutingEnabled = SharedFlags.FFlagPreHomePageRoutingEnabled
local FFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local GetFFlagEnableMultiPageSignupExperiment = require(Modules.LuaApp.Flags.GetFFlagEnableMultiPageSignupExperiment)
local StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes
local GetFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local GetFFlagAddPromCounterToKeystoreOps = SharedFlags.GetFFlagAddPromCounterToKeystoreOps
local TelemetryService = game:GetService("TelemetryService")
local KeystoreDeleteCredentialsTelemetryConfig = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs.KeystoreDeleteCredentialsTelemetryConfig
local ShowAccountAuthenticationFailureOverlay = require(Modules.LuaApp.Thunks.Authentication.ShowAccountAuthenticationFailureOverlay)
local DeleteAllCredentialsFromKeystore = require(Modules.LuaApp.Thunks.Authentication.DeleteAllCredentialsFromKeystore)
local FetchLocale = require(Modules.LuaApp.Thunks.FetchLocale)
local PreloadApplicationData = require(Modules.LuaApp.Thunks.PreloadApplicationData)
local AppStartupSequenceTag = require(CorePackages.Workspace.Packages.RoactServiceTags).AppStartupSequenceTag
local AppPrefetch = require(CorePackages.Workspace.Packages.RoactServiceTags).AppPrefetch
local InvoluntaryLogoutAnalyticsEvents = AuthCommon.Analytics.InvoluntaryLogoutAnalyticsEvents
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)

local function handleUserLoggedIn(p1, p2) -- line: 67
	-- upvalues: InvoluntaryLogoutAnalyticsEvents (copy), EventStreamConstants (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
	InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, EventStreamConstants.Context.SessionCheckDidLogin)
	GuiService:BroadcastNotification(p1:toJsonData(), NotificationType.DID_LOG_IN)
	p2:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
end
local function v49() -- line: 77
	-- upvalues: HttpService (copy), ContentProvider (copy), GetFFlagKeystoreAutoLoginAvailable (copy), DeleteAllCredentialsFromKeystore (copy), default (copy), KeystoreConstants (copy)
	local json = HttpService:JSONEncode({
		server = ContentProvider.BaseUrl
	})

	if GetFFlagKeystoreAutoLoginAvailable() then
		return DeleteAllCredentialsFromKeystore(json)
	end

	return default:deleteAllCredentialsFromiOSKeychain(default.CredentialsTypes.iosKeychainPassword, json, KeystoreConstants.KeystoreTimeout)
end
local function navigateToPostAuthPage(p3, p4, _, p6) -- line: 93
	-- upvalues: AppStorageUtilities (copy), GetFFlagEnableMultiPageSignupExperiment (copy), ResetNavigationHistory (copy), AppPage (copy), FFlagPreHomePageRoutingEnabled (copy), FFlagPasskeyUpsellEnabled (copy), HandlePreHomePageRouting (copy)
	if (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()) == "auth" then
		if GetFFlagEnableMultiPageSignupExperiment() then
			p3:dispatch(ResetNavigationHistory({{
				name = AppPage.AddAuthMethodPage
			}}))

			return
		end

		AppStorageUtilities.setSignupActionRequired("")
		AppStorageUtilities.flush()
		p3:dispatch(ResetNavigationHistory({{
			name = p4
		}}))

		return
	end

	if FFlagPreHomePageRoutingEnabled or FFlagPasskeyUpsellEnabled then
		HandlePreHomePageRouting(p6, p3, ResetNavigationHistory):andThen(function(p7) -- line: 107
			-- upvalues: p3 (copy), ResetNavigationHistory (copy), p4 (copy)
			if not p7 then
				p3:dispatch(ResetNavigationHistory({{
					name = p4
				}}))
			end
		end)

		return
	end

	p3:dispatch(ResetNavigationHistory({{
		name = p4
	}}))
end
local function isUserModerated(p8) -- line: 117
	local Moderation = p8:getState().Moderation

	return not not Moderation and (Moderation.userModerated or false)
end
local function sessionCheck(p9, p10, p11, p12, _, p14) -- line: 122
	-- upvalues: InvoluntaryLogoutAnalyticsEvents (copy), EventStreamConstants (copy), FetchLocale (copy), AppPage (copy), AppStartupSequenceTag (copy), AppPrefetch (copy), PreloadApplicationData (copy), GetUserAppLaunchInfo (copy), User (copy), OverlayType (copy), CloseAccountAuthenticationFailureOverlay (copy), navigateToPostAuthPage (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), AppStorageUtilities (copy), LocalizationService (copy), FetchTheme (copy), ApiFetchUsersRoles (copy), MemStorageService (copy), MemStorageKeys (copy), PromiseUtilities (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), StatusCodes (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreDeleteCredentialsTelemetryConfig (copy), v49 (copy), ShowAccountAuthenticationFailureOverlay (copy), sessionCheck (copy)
	return function(p15) -- line: 123
		-- upvalues: InvoluntaryLogoutAnalyticsEvents (copy), EventStreamConstants (copy), FetchLocale (copy), p9 (copy), AppPage (copy), AppStartupSequenceTag (copy), AppPrefetch (copy), PreloadApplicationData (copy), p11 (copy), p12 (copy), p14 (copy), GetUserAppLaunchInfo (copy), User (copy), OverlayType (copy), CloseAccountAuthenticationFailureOverlay (copy), p10 (copy), navigateToPostAuthPage (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), AppStorageUtilities (copy), LocalizationService (copy), FetchTheme (copy), ApiFetchUsersRoles (copy), MemStorageService (copy), MemStorageKeys (copy), PromiseUtilities (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), StatusCodes (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreDeleteCredentialsTelemetryConfig (copy), v49 (copy), ShowAccountAuthenticationFailureOverlay (copy), sessionCheck (copy)
		local Moderation = p15:getState().Moderation

		if not not Moderation and (Moderation.userModerated or false) then
			InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, EventStreamConstants.Context.SessionCheckSkippedForModeratedUser)

			return
		end

		local v71 = FetchLocale(p9)
		local Home = AppPage.Home
		local v73 = AppStartupSequenceTag
		local v74 = AppPrefetch

		local function v75() -- line: 139
			-- upvalues: p15 (copy), PreloadApplicationData (copy), p9 (copy), p11 (copy), p12 (copy), p14 (copy), v73 (copy), v74 (copy)
			return p15:dispatch(PreloadApplicationData(p9, p9, p11, p12, p14, v73, v74))
		end

		return GetUserAppLaunchInfo(p9):andThen(function(p16) -- line: 153
			-- upvalues: InvoluntaryLogoutAnalyticsEvents (copy), EventStreamConstants (copy), User (copy), p15 (copy), OverlayType (copy), CloseAccountAuthenticationFailureOverlay (copy), p10 (copy), navigateToPostAuthPage (copy), Home (copy), p9 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), v71 (copy), AppStorageUtilities (copy), LocalizationService (copy), FetchTheme (copy), ApiFetchUsersRoles (copy), MemStorageService (copy), MemStorageKeys (copy), PromiseUtilities (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
			InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, EventStreamConstants.Context.SessionCheckSuccess)

			local v77 = User.fromUserInfoRequest(p16)

			if p15:getState().CentralOverlay.OverlayType == OverlayType.AccountAuthenticationFailureOverlay then
				p15:dispatch(CloseAccountAuthenticationFailureOverlay())

				if v77:isEqual(p10) then
					InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, EventStreamConstants.Context.SessionCheckLocalPlayerMatch)
					navigateToPostAuthPage(p15, Home, v77, p9)
				end
			end

			if not v77:isEqual(p10) then
				InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, EventStreamConstants.Context.SessionCheckLocalPlayerMismatch)
				v77:setToLocalPlayer()
				v77:setToLocalStorage()
				p15:dispatch(GetLocalUser())
				p15:dispatch(ReceivedUserCountryCode(v77.countryCode))
				navigateToPostAuthPage(p15, Home, v77, p9)
			end

			local t1 = {}

			table.insert(t1, v71:andThen(function(p17) -- line: 190
				-- upvalues: AppStorageUtilities (copy), LocalizationService (copy)
				AppStorageUtilities.setRobloxLocaleId(p17.generalExperienceLocale)
				AppStorageUtilities.setGameLocaleId(p17.ugcLocale)
				LocalizationService:SetRobloxLocaleId(p17.generalExperienceLocale)
			end))

			local v79 = FetchTheme(p9, v77.userId)

			p15:dispatch(ApiFetchUsersRoles(p9))

			local v80 = (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()) == "auth"

			table.insert(t1, v79:andThen(function(p18) -- line: 207
				-- upvalues: AppStorageUtilities (copy), v80 (copy), MemStorageService (copy), MemStorageKeys (copy)
				AppStorageUtilities.setAuthenticatedTheme(p18)

				if not v80 then
					MemStorageService:Fire(MemStorageKeys.ThemeUpdate, p18)
				end
			end))
			PromiseUtilities.Batch(t1):andThen(function() -- line: 217
				-- upvalues: AppStorageUtilities (copy)
				AppStorageUtilities.flush()
			end)

			local v81 = p15

			InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, EventStreamConstants.Context.SessionCheckDidLogin)
			GuiService:BroadcastNotification(v77:toJsonData(), NotificationType.DID_LOG_IN)
			v81:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
		end, function(p19) -- line: 221
			-- upvalues: StatusCodes (copy), InvoluntaryLogoutAnalyticsEvents (copy), EventStreamConstants (copy), KeystoreAnalyticsEvents (copy), KeystoreEventConstants (copy), GetFFlagAddPromCounterToKeystoreOps (copy), TelemetryService (copy), KeystoreDeleteCredentialsTelemetryConfig (copy), v49 (copy), ShowAccountAuthenticationFailureOverlay (copy), p15 (copy), sessionCheck (copy), p9 (copy), p10 (copy), v71 (copy), Home (copy), v75 (copy)
			if p19.StatusCode == StatusCodes.UNAUTHORIZED then
				InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, EventStreamConstants.Context.SessionCheckUnauthorized)
				KeystoreAnalyticsEvents.sendPageLoadEvent(KeystoreEventConstants.origin.remoteLogoutDelete)

				if GetFFlagAddPromCounterToKeystoreOps() then
					TelemetryService:LogCounter(KeystoreDeleteCredentialsTelemetryConfig, {
						customFields = {
							reason = "remote_logout"
						}
					}, 1)
				end

				v49()

				return
			end

			InvoluntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(EventStreamConstants.Origin.LandingScreen, "ErrorCode: " .. tostring(p19.StatusCode) .. " Msg: " .. tostring(p19))
			ShowAccountAuthenticationFailureOverlay(p15, function() -- line: 243
				-- upvalues: sessionCheck (copy), p9 (copy), p10 (copy), v71 (copy), Home (copy), v75 (copy)
				sessionCheck(p9, p10, v71, true, Home, v75)
			end)
		end)
	end
end

return sessionCheck
