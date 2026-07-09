local LocalizationService = game:GetService("LocalizationService")
local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local FetchLocale = require(Modules.LuaApp.Thunks.FetchLocale)
local FetchTheme = require(Modules.LuaApp.Thunks.FetchTheme)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local GetLocalUser = require(CorePackages.Workspace.Packages.UserLib).Thunks.GetLocalUser
local PreloadApplicationData = require(Modules.LuaApp.Thunks.PreloadApplicationData)
local User = require(Modules.LuaApp.Thunks.Authentication.User)
local ClearApp = require(Modules.LuaApp.Thunks.Authentication.ClearApp)
local AppStorageUtilities = require(Modules.LuaApp.Thunks.Authentication.AppStorageUtilities)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)

require(CorePackages.Workspace.Packages.Http)

local ReceivedUserCountryCode = require(CorePackages.Workspace.Packages.CountryCode).ReceivedUserCountryCode
local SetAuthenticationStatus = require(CorePackages.Workspace.Packages.AuthenticationStatus).Actions.SetAuthenticationStatus
local GetAccountInfo = require(Modules.LuaApp.Http.Requests.GetAccountInfo)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes
local AppSessionCheckCounterNames = require(Modules.Luobu.Analytics.Events.AppSessionCheckCounterNames)
local AppPage = require(Modules.LuaApp.AppPage)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local Promise = require(Modules.LuaApp.Promise)
local PromiseUtilities = require(Modules.LuaApp.PromiseUtilities)
local AuthenticationProtocol = require(CorePackages.Workspace.Packages.AuthenticationProtocol).AuthenticationProtocol

local function initABTesting(p1) -- line: 40
	-- upvalues: RoactAppExperiment (copy)
	RoactAppExperiment.initializeUserLayers(p1)
end
local function handleUserLoggedIn(p2, p3) -- line: 44
	-- upvalues: GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
	GuiService:BroadcastNotification(p2:toJsonData(), NotificationType.DID_LOG_IN)
	p3:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
end
local function resetOnNoAccountInfo(t1: {[any]: any}, p4, b1: boolean) -- line: 49
	-- upvalues: FetchLocale (copy), PromiseUtilities (copy), AppStorageUtilities (copy), LocalizationService (copy), ClearApp (copy), SetAuthenticationStatus (copy), LoginStatus (copy), ResetNavigationHistory (copy), AppPage (copy)
	local v43 = FetchLocale(p4)

	PromiseUtilities.Batch({ v43 }):andThen(function(p5) -- line: 51
		-- upvalues: AppStorageUtilities (copy), LocalizationService (copy), b1 (copy), t1 (copy), ClearApp (copy), SetAuthenticationStatus (copy), LoginStatus (copy), ResetNavigationHistory (copy), AppPage (copy)
		p5[1]:match(function(p6) -- line: 52
			-- upvalues: AppStorageUtilities (copy), LocalizationService (copy)
			AppStorageUtilities.setRobloxLocaleId(p6.signupAndLoginLocale)
			LocalizationService:SetRobloxLocaleId(p6.signupAndLoginLocale)
		end)

		if b1 then
			t1:dispatch(ClearApp())
		end

		t1:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_OUT))
		t1:dispatch(ResetNavigationHistory({{
			name = AppPage.Landing
		}}))
	end)
end
local function getUserAccountInfo(p7, p8, p9, p10, p11) -- line: 65
	-- upvalues: GetAccountInfo (copy), AppSessionCheckCounterNames (copy), User (copy), ClearApp (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), RoactAppExperiment (copy), PreloadApplicationData (copy), FetchLocale (copy), AppStorageUtilities (copy), LocalizationService (copy), MemStorageService (copy), MemStorageKeys (copy), FetchTheme (copy), PromiseUtilities (copy), Promise (copy), StatusCodes (copy)
	return GetAccountInfo(p8):andThen(function(p12) -- line: 66
		-- upvalues: p9 (copy), AppSessionCheckCounterNames (copy), User (copy), p11 (copy), p10 (copy), p7 (copy), ClearApp (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), RoactAppExperiment (copy), PreloadApplicationData (copy), p8 (copy), FetchLocale (copy), AppStorageUtilities (copy), LocalizationService (copy), MemStorageService (copy), MemStorageKeys (copy), FetchTheme (copy), PromiseUtilities (copy), Promise (copy)
		p9.Diag:reportCounter(AppSessionCheckCounterNames.Success, 1)

		local v67 = User.fromRequest(p12)

		if not v67:isEqual(p11) or p10.useMSDKWebAuthentication() then
			v67:setToLocalPlayer()
			v67:setToLocalStorage()
			p7:dispatch(ClearApp())
			p7:dispatch(GetLocalUser())
			p7:dispatch(ReceivedUserCountryCode(v67.countryCode))
			p7:dispatch(ResetNavigationHistory({{
				name = AppPage.Home
			}}))

			local userId = v67.userId

			RoactAppExperiment.initializeUserLayers(userId)
		end

		p7:dispatch(PreloadApplicationData(p8, p9, p10))

		local t2 = {}

		table.insert(t2, FetchLocale(p8):andThen(function(p13) -- line: 86
			-- upvalues: AppStorageUtilities (copy), LocalizationService (copy)
			AppStorageUtilities.setRobloxLocaleId(p13.generalExperienceLocale)
			AppStorageUtilities.setGameLocaleId(p13.ugcLocale)
			LocalizationService:SetRobloxLocaleId(p13.generalExperienceLocale)
		end))

		local v70 = AppStorageUtilities.getAuthenticatedTheme()

		MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v70)
		table.insert(t2, FetchTheme(p8, v67.userId):andThen(function(p14) -- line: 98
			-- upvalues: AppStorageUtilities (copy), MemStorageService (copy), MemStorageKeys (copy)
			AppStorageUtilities.setAuthenticatedTheme(p14)
			MemStorageService:Fire(MemStorageKeys.ThemeUpdate, p14)
		end))
		PromiseUtilities.Batch(t2):andThen(function() -- line: 104
			-- upvalues: AppStorageUtilities (copy)
			AppStorageUtilities.flush()
		end)

		return Promise.resolve(v67)
	end, function(p15) -- line: 109
		-- upvalues: StatusCodes (copy), p9 (copy), AppSessionCheckCounterNames (copy), Promise (copy)
		if p15.StatusCodes == StatusCodes.UNAUTHORIZED then
			p9.Diag:reportCounter(AppSessionCheckCounterNames.Failure401Unauthenticated, 1)
		end

		p9.Diag:reportCounter(AppSessionCheckCounterNames.Failure, 1)

		return Promise.reject()
	end)
end
local function handleCachedUser(p16, p17, p18, p19, p20) -- line: 119
	-- upvalues: RoactAppExperiment (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), getUserAccountInfo (copy), AuthenticationProtocol (copy), Logger (copy), resetOnNoAccountInfo (copy), Logout (copy), GuiService (copy), luaLogoutReasonNames (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
	p20:setToLocalPlayer()

	local userId = p20.userId

	RoactAppExperiment.initializeUserLayers(userId)
	spawn(function() -- line: 124
		-- upvalues: p16 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), p20 (copy), ResetNavigationHistory (copy), AppPage (copy), getUserAccountInfo (copy), p17 (copy), p18 (copy), p19 (copy), AuthenticationProtocol (copy), Logger (copy), resetOnNoAccountInfo (copy), Logout (copy), GuiService (copy), luaLogoutReasonNames (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
		p16:dispatch(GetLocalUser())
		p16:dispatch(ReceivedUserCountryCode(p20.countryCode))
		p16:dispatch(ResetNavigationHistory({{
			name = AppPage.Home
		}}))
		getUserAccountInfo(p16, p17, p18, p19, p20):andThen(function(p21) -- line: 129
			-- upvalues: AuthenticationProtocol (copy), Logger (copy), resetOnNoAccountInfo (copy), p16 (copy), p17 (copy), p18 (copy), Logout (copy), GuiService (copy), luaLogoutReasonNames (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
			local v85, v86 = AuthenticationProtocol.default:requestAuth(AuthenticationProtocol.AuthProviders.MSDK, AuthenticationProtocol.AuthMethods.NONE):await()

			if not v85 or v86.statusCode ~= 0 then
				Logger:info("MSDK Auto Login with ErrorCode: " .. v86.statusCode)
				resetOnNoAccountInfo(p16, p17, true)
				p18.Diag:reportCounter("MSDKAutoLoginErrorCode_" .. v86.statusCode, 1)
				p16:dispatch(Logout(p17, GuiService, luaLogoutReasonNames.UnauthorizedAutoLogin))

				return
			end

			local v87 = p16

			GuiService:BroadcastNotification(p21:toJsonData(), NotificationType.DID_LOG_IN)
			v87:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
		end, function() -- line: 142
			-- upvalues: resetOnNoAccountInfo (copy), p16 (copy), p17 (copy)
			resetOnNoAccountInfo(p16, p17, true)
		end)
	end)
end
local function handleNoCachedUser(p22, p23, p24, p25, p26, p27) -- line: 148
	-- upvalues: resetOnNoAccountInfo (copy), getUserAccountInfo (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
	if p27 then
		resetOnNoAccountInfo(p22, p23, false)

		return
	end

	spawn(function() -- line: 152
		-- upvalues: getUserAccountInfo (copy), p22 (copy), p23 (copy), p24 (copy), p25 (copy), p26 (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), resetOnNoAccountInfo (copy)
		getUserAccountInfo(p22, p23, p24, p25, p26):andThen(function(p28) -- line: 153
			-- upvalues: p22 (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
			local v89 = p22

			GuiService:BroadcastNotification(p28:toJsonData(), NotificationType.DID_LOG_IN)
			v89:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
		end, function() -- line: 155
			-- upvalues: resetOnNoAccountInfo (copy), p22 (copy), p23 (copy)
			resetOnNoAccountInfo(p22, p23, false)
		end)
	end)
end

return function(p29, t3: {[any]: any}, t4: {[any]: any}, s1: string?) -- line: 162
	-- upvalues: User (copy), Logger (copy), LaunchContext (copy), resetOnNoAccountInfo (copy), getUserAccountInfo (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), RoactAppExperiment (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), AuthenticationProtocol (copy), Logout (copy), luaLogoutReasonNames (copy)
	return function(p30) -- line: 168
		-- upvalues: User (copy), t4 (copy), Logger (copy), p29 (copy), t3 (copy), s1 (copy), LaunchContext (copy), resetOnNoAccountInfo (copy), getUserAccountInfo (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), RoactAppExperiment (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), AuthenticationProtocol (copy), Logout (copy), luaLogoutReasonNames (copy)
		local v73 = User.fromLocalStorage()

		if v73.userId == -1 or t4.useMSDKWebAuthentication() then
			Logger:info(string.format("[%f] LaunchLuobuApp::handleNoCachedUser()", tick()))

			local v74 = p29
			local v75 = t3
			local v76 = t4

			if s1 == LaunchContext.Startup then
				resetOnNoAccountInfo(p30, v74, false)

				return
			end

			spawn(function() -- line: 152
				-- upvalues: getUserAccountInfo (copy), p30 (copy), v74 (copy), v75 (copy), v76 (copy), v73 (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy), resetOnNoAccountInfo (copy)
				getUserAccountInfo(p30, v74, v75, v76, v73):andThen(function(p31) -- line: 153
					-- upvalues: p30 (copy), GuiService (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
					local v91 = p30

					GuiService:BroadcastNotification(p31:toJsonData(), NotificationType.DID_LOG_IN)
					v91:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
				end, function() -- line: 155
					-- upvalues: resetOnNoAccountInfo (copy), p30 (copy), v74 (copy)
					resetOnNoAccountInfo(p30, v74, false)
				end)
			end)

			return
		end

		Logger:info(string.format("[%f] LaunchLuobuApp::handleCachedUser()", tick()))

		local v77 = p29
		local v78 = t3
		local v79 = t4

		v73:setToLocalPlayer()

		local userId = v73.userId

		RoactAppExperiment.initializeUserLayers(userId)
		spawn(function() -- line: 124
			-- upvalues: p30 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), v73 (copy), ResetNavigationHistory (copy), AppPage (copy), getUserAccountInfo (copy), v77 (copy), v78 (copy), v79 (copy), AuthenticationProtocol (copy), Logger (copy), resetOnNoAccountInfo (copy), Logout (copy), GuiService (copy), luaLogoutReasonNames (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
			p30:dispatch(GetLocalUser())
			p30:dispatch(ReceivedUserCountryCode(v73.countryCode))
			p30:dispatch(ResetNavigationHistory({{
				name = AppPage.Home
			}}))
			getUserAccountInfo(p30, v77, v78, v79, v73):andThen(function(p32) -- line: 129
				-- upvalues: AuthenticationProtocol (copy), Logger (copy), resetOnNoAccountInfo (copy), p30 (copy), v77 (copy), v78 (copy), Logout (copy), GuiService (copy), luaLogoutReasonNames (copy), NotificationType (copy), SetAuthenticationStatus (copy), LoginStatus (copy)
				local v93, v94 = AuthenticationProtocol.default:requestAuth(AuthenticationProtocol.AuthProviders.MSDK, AuthenticationProtocol.AuthMethods.NONE):await()

				if not v93 or v94.statusCode ~= 0 then
					Logger:info("MSDK Auto Login with ErrorCode: " .. v94.statusCode)
					resetOnNoAccountInfo(p30, v77, true)
					v78.Diag:reportCounter("MSDKAutoLoginErrorCode_" .. v94.statusCode, 1)
					p30:dispatch(Logout(v77, GuiService, luaLogoutReasonNames.UnauthorizedAutoLogin))

					return
				end

				local v95 = p30

				GuiService:BroadcastNotification(p32:toJsonData(), NotificationType.DID_LOG_IN)
				v95:dispatch(SetAuthenticationStatus(LoginStatus.LOGGED_IN))
			end, function() -- line: 142
				-- upvalues: resetOnNoAccountInfo (copy), p30 (copy), v77 (copy)
				resetOnNoAccountInfo(p30, v77, true)
			end)
		end)
	end
end
