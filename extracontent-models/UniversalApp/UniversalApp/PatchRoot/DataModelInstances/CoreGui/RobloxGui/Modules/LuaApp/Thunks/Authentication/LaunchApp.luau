local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local MemStorageService = game:GetService("MemStorageService")
local Modules = CoreGui.RobloxGui.Modules
local User = require(script.Parent.User)
local GetLocalUser = require(CorePackages.Workspace.Packages.UserLib).Thunks.GetLocalUser
local SetLaunchContext = require(CorePackages.Workspace.Packages.AppStartup).Actions.SetLaunchContext
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local FetchLocale = require(Modules.LuaApp.Thunks.FetchLocale)
local PreloadApplicationData = require(Modules.LuaApp.Thunks.PreloadApplicationData)
local AppStorageUtilities = require(script.Parent.AppStorageUtilities)
local AppPage = require(Modules.LuaApp.AppPage)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local LaunchContext = require(Modules.LuaApp.Enum.LaunchContext)
local WebLogin = require(script.Parent.WebLogin)
local WebLaunchOption = require(Modules.LuaApp.Enum.WebLaunchOption)
local MemStorageKeys = require(Modules.LuaApp.Enum.MemStorageKeys)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local PostSignUpAttribution = require(CorePackages.Workspace.Packages.ExternalAttribution).PostSignUpAttribution
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local ResetOnNoAccountInfoFound = require(Modules.LuaApp.Thunks.Authentication.ResetOnNoAccountInfoFound)
local Constants = require(Modules.LuaApp.Constants)
local AccountSwitcherConstants = require(CorePackages.Workspace.Packages.AuthCommon).Common.AccountSwitcherConstants
local GetUserAppLaunchInfo = require(Modules.LuaApp.Http.Requests.GetUserAppLaunchInfo)
local GetCredentialsAvailabilityStore = require(CorePackages.Workspace.Packages.AuthCommon).Stores.GetCredentialsAvailabilityStore
local parseCredentialsProtocolIsAvailableResponse = require(CorePackages.Workspace.Packages.AuthCommon).Utils.parseCredentialsProtocolIsAvailableResponse
local ReceivedUserCountryCode = require(CorePackages.Workspace.Packages.CountryCode).ReceivedUserCountryCode
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local GetFFlagPasskeySignupEnabled = require(Modules.LuaApp.Flags.GetFFlagPasskeySignupEnabled)
local GetFFlagEnableMultiPageSignupExperiment = require(Modules.LuaApp.Flags.GetFFlagEnableMultiPageSignupExperiment)
local FFlagApplyLaunchContextForNewAccountSwitches = SharedFlags.FFlagApplyLaunchContextForNewAccountSwitches
local FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = SharedFlags.FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local FFlagUseIsAvailableCheckForIOSKeychainFetch = SharedFlags.FFlagUseIsAvailableCheckForIOSKeychainFetch
local FFlagEnableIosKeychainLoginLua = require(Modules.LuaApp.Flags.FFlagEnableIosKeychainLoginLua)
local GetFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local AttemptLoginWithKeystoreCredentials = require(Modules.LuaApp.Thunks.Authentication.AttemptLoginWithKeystoreCredentials)
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local Login = require(Modules.LuaApp.Thunks.Authentication.Login)
local KeystoreConstants = require(CorePackages.Workspace.Packages.AuthCommon).Common.KeystoreConstants
local AuthAnalytics = require(CorePackages.Workspace.Packages.AuthAnalytics)
local CheckForAndFireValidCookieForNoCachedUserEvent = AuthAnalytics.RobloxTelemetry.CheckForAndFireValidCookieForNoCachedUserEvent
local TelemetryConfigs = AuthAnalytics.TelemetryConfigs
local authPageload = AuthAnalytics.Events.authPageload
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local HandleAccountInfo = require(Modules.LuaApp.Thunks.Authentication.HandleAccountInfo)
local GetFFlagEnableHandleEngineSessionCheckAtStartup = require(Modules.LuaApp.Flags.GetFFlagEnableHandleEngineSessionCheckAtStartup)
local v49 = game:DefineFastFlag("DisableListenToSessionTerminalStatus", false)
local v50 = game:DefineFastFlag("LuaAppDeferLaunch", false)
local SessionCheckManager = require(Modules.LuaApp.Thunks.Authentication.SessionCheckManager.SessionCheckManager)
local Status = SessionCheckManager.Status
local SessionCheckUtils = require(Modules.LuaApp.Thunks.Authentication.SessionCheckUtils)
local handleSessionCheckSuccess = SessionCheckUtils.handleSessionCheckSuccess
local handleSessionCheckFailure = SessionCheckUtils.handleSessionCheckFailure
local Promise = require(CorePackages.Packages.Promise)
local CredentialsProtocol = require(CorePackages.Workspace.Packages.CredentialsProtocol)
local default2 = CredentialsProtocol.CredentialsProtocol.default
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local FFlagMorePageGateAccountSwitcherByCachedVariantId = SharedFlags.FFlagMorePageGateAccountSwitcherByCachedVariantId
local FFlagEnableNavigateToLoginAfterLogoutAll = SharedFlags.FFlagEnableNavigateToLoginAfterLogoutAll

local function initializeForCachedUser(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12) -- line: 105
	-- upvalues: AppStorageUtilities (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy), v50 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), PreloadApplicationData (copy), HandleAccountInfo (copy)
	p5:setToLocalPlayer()

	local v78 = not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()
	local v79 = AppStorageUtilities.getAuthenticatedTheme()
	local v80 = v78 == "auth" and (GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment())

	if v79 ~= "" and not v80 then
		MemStorageService:Fire(MemStorageKeys.ThemeUpdate, v79)
	end

	RoactAppExperiment.initializeUserLayers(p5.userId);
	((if not v50 then spawn else task.defer))(function() -- line: 142
		-- upvalues: p7 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), p5 (copy), p10 (copy), ResetNavigationHistory (copy), AppPage (copy), v78 (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), AppStorageUtilities (copy), p6 (copy), PreloadApplicationData (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p9 (copy), p11 (copy), p12 (copy), HandleAccountInfo (copy), p8 (copy)
		p7:dispatch(GetLocalUser())
		p7:dispatch(ReceivedUserCountryCode(p5.countryCode))

		if p10 and p5.isUnder13 then
			p7:dispatch(ResetNavigationHistory({{
				name = AppPage.UAppBlock
			}}))
		elseif v78 == "auth" then
			if GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment() then
				p7:dispatch(ResetNavigationHistory({{
					name = AppPage.AddAuthMethodPage
				}}))
			else
				AppStorageUtilities.setSignupActionRequired("")
				AppStorageUtilities.flush()
				p7:dispatch(ResetNavigationHistory({{
					name = p6
				}}))
			end
		else
			p7:dispatch(ResetNavigationHistory({{
				name = p6
			}}))
		end

		p7:dispatch(PreloadApplicationData(p1, p2, p3, p4, p9, p11, p12))
		HandleAccountInfo(p1, p5, p8, true, p7, p6, function() -- line: 160
			-- upvalues: p7 (copy), PreloadApplicationData (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p9 (copy), p11 (copy), p12 (copy)
			return p7:dispatch(PreloadApplicationData(p1, p2, p3, p4, p9, p11, p12))
		end, p9, p10, true)
	end)
end
local function handleNavWithDataLoadAndSessionCheck(p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26) -- line: 193
	-- upvalues: GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), AppStorageUtilities (copy), PreloadApplicationData (copy), HandleAccountInfo (copy)
	spawn(function() -- line: 210
		-- upvalues: p13 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), p14 (copy), p15 (copy), ResetNavigationHistory (copy), AppPage (copy), p16 (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), AppStorageUtilities (copy), p17 (copy), PreloadApplicationData (copy), p18 (copy), p19 (copy), p20 (copy), p21 (copy), p22 (copy), p23 (copy), p24 (copy), HandleAccountInfo (copy), p26 (copy), p25 (copy)
		p13:dispatch(GetLocalUser())
		p13:dispatch(ReceivedUserCountryCode(p14.countryCode))

		if p15 and p14.isUnder13 then
			p13:dispatch(ResetNavigationHistory({{
				name = AppPage.UAppBlock
			}}))
		elseif p16 == "auth" then
			if GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment() then
				p13:dispatch(ResetNavigationHistory({{
					name = AppPage.AddAuthMethodPage
				}}))
			else
				AppStorageUtilities.setSignupActionRequired("")
				AppStorageUtilities.flush()
				p13:dispatch(ResetNavigationHistory({{
					name = p17
				}}))
			end
		else
			p13:dispatch(ResetNavigationHistory({{
				name = p17
			}}))
		end

		p13:dispatch(PreloadApplicationData(p18, p19, p20, p21, p22, p23, p24))
		HandleAccountInfo(p18, p14, p26, p25, p13, p17, function() -- line: 228
			-- upvalues: p13 (copy), PreloadApplicationData (copy), p18 (copy), p19 (copy), p20 (copy), p21 (copy), p22 (copy), p23 (copy), p24 (copy)
			return p13:dispatch(PreloadApplicationData(p18, p19, p20, p21, p22, p23, p24))
		end, p22, p15, true)
	end)
end
local function initializeForCachedUserV2(p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38) -- line: 261
	-- upvalues: AppStorageUtilities (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), MemStorageService (copy), MemStorageKeys (copy), RoactAppExperiment (copy), PreloadApplicationData (copy), v49 (copy), SessionCheckManager (copy), Status (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), handleSessionCheckSuccess (copy), handleSessionCheckFailure (copy), HandleAccountInfo (copy)
	p31:setToLocalPlayer()

	local v107 = not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()
	local v108 = AppStorageUtilities.getAuthenticatedTheme()
	local v109 = v107 == "auth" and (GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment())
	local s1 = "dark"

	if v108 == "light" or v108 == "dark" then
		s1 = v108
	end

	if v109 then
		s1 = "dark"
	end

	MemStorageService:Fire(MemStorageKeys.ThemeUpdate, s1)
	RoactAppExperiment.initializeUserLayers(p31.userId)

	local function v111() -- line: 305
		-- upvalues: p33 (copy), PreloadApplicationData (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy), p35 (copy), p37 (copy), p38 (copy)
		return p33:dispatch(PreloadApplicationData(p27, p28, p29, p30, p35, p37, p38))
	end

	if v49 then
		SessionCheckManager:listenToSessionStatusChange(function(p39) -- line: 320
			-- upvalues: Status (copy), p33 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), p31 (copy), p36 (copy), ResetNavigationHistory (copy), AppPage (copy), v107 (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), AppStorageUtilities (copy), p32 (copy), PreloadApplicationData (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy), p35 (copy), p37 (copy), p38 (copy), handleSessionCheckSuccess (copy), p34 (copy), v111 (copy), handleSessionCheckFailure (copy), HandleAccountInfo (copy)
			local status = p39.status

			if status == Status.Success then
				p33:dispatch(GetLocalUser())
				p33:dispatch(ReceivedUserCountryCode(p31.countryCode))

				if p36 and p31.isUnder13 then
					p33:dispatch(ResetNavigationHistory({{
						name = AppPage.UAppBlock
					}}))
				elseif v107 == "auth" then
					if GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment() then
						p33:dispatch(ResetNavigationHistory({{
							name = AppPage.AddAuthMethodPage
						}}))
					else
						AppStorageUtilities.setSignupActionRequired("")
						AppStorageUtilities.flush()
						p33:dispatch(ResetNavigationHistory({{
							name = p32
						}}))
					end
				else
					p33:dispatch(ResetNavigationHistory({{
						name = p32
					}}))
				end

				p33:dispatch(PreloadApplicationData(p27, p28, p29, p30, p35, p37, p38))
				handleSessionCheckSuccess(p27, p31, p34, true, p33, p32, v111, p35, p36, true)

				return
			end

			if status == Status.Failed then
				local v148 = p39.httpStatusCode or p39.errorStatus

				handleSessionCheckFailure(v148, true, p33, p27, p34, p31, p32, v111)

				return
			end

			local v149 = p33
			local v150 = p31
			local v151 = p36
			local v152 = v107
			local v153 = p32
			local v154 = p27
			local v155 = p28
			local v156 = p29
			local v157 = p30
			local v158 = p35
			local v159 = p37
			local v160 = p38
			local v161 = p34
			local v162 = true

			spawn(function() -- line: 210
				-- upvalues: v149 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), v150 (copy), v151 (copy), ResetNavigationHistory (copy), AppPage (copy), v152 (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), AppStorageUtilities (copy), v153 (copy), PreloadApplicationData (copy), v154 (copy), v155 (copy), v156 (copy), v157 (copy), v158 (copy), v159 (copy), v160 (copy), HandleAccountInfo (copy), v161 (copy), v162 (copy)
				v149:dispatch(GetLocalUser())
				v149:dispatch(ReceivedUserCountryCode(v150.countryCode))

				if v151 and v150.isUnder13 then
					v149:dispatch(ResetNavigationHistory({{
						name = AppPage.UAppBlock
					}}))
				elseif v152 == "auth" then
					if GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment() then
						v149:dispatch(ResetNavigationHistory({{
							name = AppPage.AddAuthMethodPage
						}}))
					else
						AppStorageUtilities.setSignupActionRequired("")
						AppStorageUtilities.flush()
						v149:dispatch(ResetNavigationHistory({{
							name = v153
						}}))
					end
				else
					v149:dispatch(ResetNavigationHistory({{
						name = v153
					}}))
				end

				v149:dispatch(PreloadApplicationData(v154, v155, v156, v157, v158, v159, v160))
				HandleAccountInfo(v154, v150, v161, v162, v149, v153, function() -- line: 228
					-- upvalues: v149 (copy), PreloadApplicationData (copy), v154 (copy), v155 (copy), v156 (copy), v157 (copy), v158 (copy), v159 (copy), v160 (copy)
					return v149:dispatch(PreloadApplicationData(v154, v155, v156, v157, v158, v159, v160))
				end, v158, v151, true)
			end)
		end)

		return
	end

	SessionCheckManager:registerSessionStatusChange()
	SessionCheckManager:waitForSessionCheckTerminalStatus():andThen(function(p40) -- line: 392
		-- upvalues: Status (copy), p33 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), p31 (copy), p36 (copy), ResetNavigationHistory (copy), AppPage (copy), v107 (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), AppStorageUtilities (copy), p32 (copy), PreloadApplicationData (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy), p35 (copy), p37 (copy), p38 (copy), handleSessionCheckSuccess (copy), p34 (copy), v111 (copy), handleSessionCheckFailure (copy)
		if p40 and p40.status == Status.Success then
			p33:dispatch(GetLocalUser())
			p33:dispatch(ReceivedUserCountryCode(p31.countryCode))

			if p36 and p31.isUnder13 then
				p33:dispatch(ResetNavigationHistory({{
					name = AppPage.UAppBlock
				}}))
			elseif v107 == "auth" then
				if GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment() then
					p33:dispatch(ResetNavigationHistory({{
						name = AppPage.AddAuthMethodPage
					}}))
				else
					AppStorageUtilities.setSignupActionRequired("")
					AppStorageUtilities.flush()
					p33:dispatch(ResetNavigationHistory({{
						name = p32
					}}))
				end
			else
				p33:dispatch(ResetNavigationHistory({{
					name = p32
				}}))
			end

			p33:dispatch(PreloadApplicationData(p27, p28, p29, p30, p35, p37, p38))
			handleSessionCheckSuccess(p27, p31, p34, true, p33, p32, v111, p35, p36, true)

			return
		end

		if p40 and p40.status == Status.Failed then
			handleSessionCheckFailure(p40.errorStatus, true, p33, p27, p34, p31, p32, v111)
		end
	end, function(_) -- line: 442
		-- upvalues: p33 (copy), p31 (copy), p36 (copy), v107 (copy), p32 (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy), p35 (copy), p37 (copy), p38 (copy), p34 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), ResetNavigationHistory (copy), AppPage (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), AppStorageUtilities (copy), PreloadApplicationData (copy), HandleAccountInfo (copy)
		local v165 = p33
		local v166 = p31
		local v167 = p36
		local v168 = v107
		local v169 = p32
		local v170 = p27
		local v171 = p28
		local v172 = p29
		local v173 = p30
		local v174 = p35
		local v175 = p37
		local v176 = p38
		local v177 = p34
		local v178 = true

		spawn(function() -- line: 210
			-- upvalues: v165 (copy), GetLocalUser (copy), ReceivedUserCountryCode (copy), v166 (copy), v167 (copy), ResetNavigationHistory (copy), AppPage (copy), v168 (copy), GetFFlagPasskeySignupEnabled (copy), GetFFlagEnableMultiPageSignupExperiment (copy), AppStorageUtilities (copy), v169 (copy), PreloadApplicationData (copy), v170 (copy), v171 (copy), v172 (copy), v173 (copy), v174 (copy), v175 (copy), v176 (copy), HandleAccountInfo (copy), v177 (copy), v178 (copy)
			v165:dispatch(GetLocalUser())
			v165:dispatch(ReceivedUserCountryCode(v166.countryCode))

			if v167 and v166.isUnder13 then
				v165:dispatch(ResetNavigationHistory({{
					name = AppPage.UAppBlock
				}}))
			elseif v168 == "auth" then
				if GetFFlagPasskeySignupEnabled() or GetFFlagEnableMultiPageSignupExperiment() then
					v165:dispatch(ResetNavigationHistory({{
						name = AppPage.AddAuthMethodPage
					}}))
				else
					AppStorageUtilities.setSignupActionRequired("")
					AppStorageUtilities.flush()
					v165:dispatch(ResetNavigationHistory({{
						name = v169
					}}))
				end
			else
				v165:dispatch(ResetNavigationHistory({{
					name = v169
				}}))
			end

			v165:dispatch(PreloadApplicationData(v170, v171, v172, v173, v174, v175, v176))
			HandleAccountInfo(v170, v166, v177, v178, v165, v169, function() -- line: 228
				-- upvalues: v165 (copy), PreloadApplicationData (copy), v170 (copy), v171 (copy), v172 (copy), v173 (copy), v174 (copy), v175 (copy), v176 (copy)
				return v165:dispatch(PreloadApplicationData(v170, v171, v172, v173, v174, v175, v176))
			end, v174, v167, true)
		end)
	end)
end
local function handleNoCachedUser(p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55) -- line: 464
	-- upvalues: FlagSettings (copy), PreloadApplicationData (copy), HandleAccountInfo (copy), AppStorageUtilities (copy), ResetNavigationHistory (copy), AppPage (copy), FFlagEnableLuaAccountSwitch (copy), FFlagEnableNavigateToLoginAfterLogoutAll (copy), AccountSwitcherConstants (copy), CheckForAndFireValidCookieForNoCachedUserEvent (copy), default (copy), GetUserAppLaunchInfo (copy), FFlagEnableIosKeychainLoginLua (copy), GetFFlagKeystoreAutoLoginAvailable (copy), ResetOnNoAccountInfoFound (copy), HttpService (copy), ContentProvider (copy), default2 (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), KeystoreConstants (copy), Promise (copy), FFlagUseIsAvailableCheckForIOSKeychainFetch (copy), Login (copy), AttemptLoginWithKeystoreCredentials (copy)
	local u126 = p55 or false

	if FlagSettings.LuaAppLoginUIEnabled() and p46 then
		HandleAccountInfo(p42, p47, p48, false, p49, p50, function() -- line: 487
			-- upvalues: p49 (copy), PreloadApplicationData (copy), p42 (copy), p43 (copy), p44 (copy), p45 (copy), p51 (copy), p53 (copy), p54 (copy)
			return p49:dispatch(PreloadApplicationData(p42, p43, p44, p45, p51, p53, p54))
		end, p51, p52, false)
	elseif FlagSettings.LuaAppLoginUIEnabled() then
		if (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or AppStorageUtilities.getSignupActionRequired()) == "auth" then
			p49:dispatch(ResetNavigationHistory({{
				name = AppPage.AddAuthMethodPage
			}}))

			return
		end

		if FFlagEnableLuaAccountSwitch and FFlagEnableNavigateToLoginAfterLogoutAll then
			local v127 = AppStorageUtilities.getAccountSwitchStatus()
			local v128 = v127 == AccountSwitcherConstants.AccountSwitcherPendingLoginAfterLogoutAll
			local v129 = v127 == AccountSwitcherConstants.AccountSwitcherPendingLoginV2AfterLogoutAll
			local v130 = v127 == AccountSwitcherConstants.AccountSwitcherPendingPasskeyLoginV1AfterLogoutAll
			local v131 = v127 == AccountSwitcherConstants.AccountSwitcherPendingPasskeyLoginV2AfterLogoutAll

			if v128 or v129 or v130 or v131 then
				local v132 = AppStorageUtilities.getAccountSwitchTargetUsername()

				AppStorageUtilities.setAccountSwitchStatus("")
				AppStorageUtilities.setAccountSwitchTargetUsername("")
				AppStorageUtilities.flush()

				local t1 = {}

				if v132 ~= "" then
					t1.forcedUsernameOverride = v132
				end

				if v130 or v131 then
					t1.retryPasskey = true
				end

				if v129 or v131 then
					p49:dispatch(ResetNavigationHistory({{
						name = AppPage.LoginV2,
						extraProps = t1
					}}))
				else
					p49:dispatch(ResetNavigationHistory({{
						name = AppPage.Login,
						extraProps = t1
					}}))
				end

				return
			end
		end

		spawn(function() -- line: 567
			-- upvalues: p49 (copy), CheckForAndFireValidCookieForNoCachedUserEvent (copy), p42 (copy), default (copy), GetUserAppLaunchInfo (copy)
			p49:dispatch(CheckForAndFireValidCookieForNoCachedUserEvent(p42, default, GetUserAppLaunchInfo))
		end)

		if (FFlagEnableIosKeychainLoginLua or GetFFlagKeystoreAutoLoginAvailable()) and not u126 then
			local function handleResetOnNoAccountInfoFound(p56, p57, p58) -- line: 588
				-- upvalues: ResetOnNoAccountInfoFound (copy), p49 (copy), p42 (copy), p48 (copy)
				ResetOnNoAccountInfoFound(false, p49, p42, p48, nil, p56, p57, p58)
			end
			local function loginCallback(p59, p60) -- line: 664
				-- upvalues: Login (copy)
				return function(p61) -- line: 665
					-- upvalues: Login (copy), p59 (copy), p60 (copy)
					return p61:dispatch(Login(p59, p60.username, p60.password, nil, nil, nil, nil, nil, false))
				end
			end;

			((if not GetFFlagKeystoreAutoLoginAvailable() then AttemptLoginWithKeystoreCredentials(p42, function() --[[ getIosKeychainCredentials ]] -- line: 606
				-- upvalues: HttpService (copy), ContentProvider (copy), default2 (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), KeystoreConstants (copy), Promise (copy), FFlagUseIsAvailableCheckForIOSKeychainFetch (copy)
				local json = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})
				local v183 = default2:isAvailable(default2.CredentialsTypes.iosKeychainPassword, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p62) -- line: 614
					-- upvalues: default2 (copy), json (copy), KeystoreConstants (copy), Promise (copy)
					if p62 and p62.isAvailable then
						return default2:getCredentials(default2.CredentialsTypes.iosKeychainPassword, json, KeystoreConstants.KeystoreTimeout)
					end

					return Promise.resolve(nil)
				end)

				if FFlagUseIsAvailableCheckForIOSKeychainFetch then
					return v183()
				end

				return default2:getCredentials(default2.CredentialsTypes.iosKeychainPassword, json, KeystoreConstants.KeystoreTimeout)
			end, loginCallback)(p49) else AttemptLoginWithKeystoreCredentials(p42, function() --[[ getKeystoreCredentials ]] -- line: 638
				-- upvalues: HttpService (copy), ContentProvider (copy), default2 (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), KeystoreConstants (copy), Promise (copy)
				local json = HttpService:JSONEncode({
					server = ContentProvider.BaseUrl
				})

				return (default2:isAvailable(default2.CredentialsTypes.keystore, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p63) -- line: 645
					-- upvalues: default2 (copy), json (copy), KeystoreConstants (copy), Promise (copy)
					if p63 and (p63.keystore and p63.keystore.isAvailable) then
						return default2:getCredentials(default2.CredentialsTypes.keystore, json, KeystoreConstants.KeystoreTimeout)
					end

					return Promise.resolve(nil)
				end))
			end, loginCallback)(p49))):andThen(function(p64) -- line: 697
				-- upvalues: u126 (ref), AppStorageUtilities (copy), p42 (copy), p43 (copy), p44 (copy), p45 (copy), p51 (copy), p53 (copy), p54 (copy), p49 (copy), ResetOnNoAccountInfoFound (copy), p48 (copy)
				if p64.loginResult then
					u126 = true
					AppStorageUtilities.setAccountBlob(p64.loginResult.accountBlob)
					AppStorageUtilities.flush()
					launchApp(p42, p43, p44, p45, nil, p51, p53, p54, u126)(p49)

					return
				end

				local credentials = p64.credentials
				local credentialsValidForLogin = p64.credentialsValidForLogin
				local redirectToLoginPage = p64.redirectToLoginPage

				ResetOnNoAccountInfoFound(false, p49, p42, p48, nil, credentials, credentialsValidForLogin, redirectToLoginPage)
			end):catch(function(p65) -- line: 722
				-- upvalues: ResetOnNoAccountInfoFound (copy), p49 (copy), p42 (copy), p48 (copy)
				local credentials = p65.credentials
				local credentialsValidForLogin = p65.credentialsValidForLogin
				local redirectToLoginPage = p65.redirectToLoginPage

				ResetOnNoAccountInfoFound(false, p49, p42, p48, nil, credentials, credentialsValidForLogin, redirectToLoginPage)
			end)
		else
			ResetOnNoAccountInfoFound(false, p49, p42, p48, nil, nil, nil, false)
		end
	else
		HandleAccountInfo(p42, p47, p48, false, p49, p50, function() -- line: 740
			-- upvalues: p49 (copy), PreloadApplicationData (copy), p42 (copy), p43 (copy), p44 (copy), p45 (copy), p51 (copy), p53 (copy), p54 (copy)
			return p49:dispatch(PreloadApplicationData(p42, p43, p44, p45, p51, p53, p54))
		end, p51, p52, false)
	end
end

function launchApp(p66, p67, p68, p69, p70, p71, p72, p73, p74) -- line: 769
	-- upvalues: FetchLocale (copy), User (copy), AppPage (copy), SetLaunchContext (copy), default2 (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), GetCredentialsAvailabilityStore (copy), parseCredentialsProtocolIsAvailableResponse (copy), Logger (copy), default (copy), TelemetryConfigs (copy), FFlagEnableLuaAccountSwitch (copy), FFlagMorePageGateAccountSwitcherByCachedVariantId (copy), AppStorageUtilities (copy), authPageload (copy), WebLogin (copy), WebLaunchOption (copy), handleNoCachedUser (copy), PostSignUpAttribution (copy), GetFFlagEnableHandleEngineSessionCheckAtStartup (copy), LaunchContext (copy), initializeForCachedUserV2 (copy), initializeForCachedUser (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), FFlagApplyLaunchContextForNewAccountSwitches (copy), AccountSwitcherConstants (copy), Constants (copy)
	return function(p75) -- line: 780
		-- upvalues: p74 (ref), FetchLocale (copy), p66 (copy), User (copy), AppPage (copy), SetLaunchContext (copy), p70 (copy), default2 (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), GetCredentialsAvailabilityStore (copy), parseCredentialsProtocolIsAvailableResponse (copy), Logger (copy), default (copy), TelemetryConfigs (copy), FFlagEnableLuaAccountSwitch (copy), FFlagMorePageGateAccountSwitcherByCachedVariantId (copy), AppStorageUtilities (copy), authPageload (copy), WebLogin (copy), WebLaunchOption (copy), handleNoCachedUser (copy), p67 (copy), p68 (copy), p69 (copy), p71 (copy), p72 (copy), p73 (copy), PostSignUpAttribution (copy), GetFFlagEnableHandleEngineSessionCheckAtStartup (copy), LaunchContext (copy), initializeForCachedUserV2 (copy), initializeForCachedUser (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), FFlagApplyLaunchContextForNewAccountSwitches (copy), AccountSwitcherConstants (copy), Constants (copy)
		p74 = p74 or false

		local v196 = FetchLocale(p66)
		local u197 = User.fromLocalStorage()
		local Home = AppPage.Home

		p75:dispatch(SetLaunchContext(p70))
		default2:isAvailable(default2.CredentialsTypes.all, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p76) -- line: 792
			-- upvalues: GetCredentialsAvailabilityStore (copy), parseCredentialsProtocolIsAvailableResponse (copy)
			local v207 = GetCredentialsAvailabilityStore(false)
			local v208 = parseCredentialsProtocolIsAvailableResponse(p76)

			v207.setFido2Available(v208.fido2Available)
			v207.setFido2SupportsDeviceBoundOnly(v208.fido2SupportsDeviceBoundOnly)
			v207.setPasswordsAvailable(v208.passwordsAvailable)
			v207.setV2InterfaceSupported(v208.v2InterfaceSupported)
		end):catch(function(_) -- line: 803
			-- upvalues: Logger (copy)
			Logger:warning("Error prefetching CredentialsProtocol:isAvailable")
		end)
		pcall(function() -- line: 807
			-- upvalues: default (copy), TelemetryConfigs (copy), p70 (copy), u197 (ref)
			default:logRobloxTelemetryCounter(TelemetryConfigs.LaunchAppThunkInitiatedConfig, 1, {
				launchContext = p70,
				hasCachedUser = tostring(not not u197 and (not not u197.userId and (u197.userId ~= -1 or false)))
			})
		end)

		if FFlagEnableLuaAccountSwitch and FFlagMorePageGateAccountSwitcherByCachedVariantId then
			local v199 = AppStorageUtilities.getAccountSwitcherAvailableByVariantId()

			authPageload("launchAppCachedAsValue", (tostring(v199)))
		end

		if WebLogin.getWebLogin() ~= WebLaunchOption.NotFromWeb then
			Logger:info(string.format("[%f] LaunchApp::handleNoCachedUser(), WebLogin", tick()))
			User.clearLocalStorage()
			AppStorageUtilities.flush()
			u197 = User.fromLocalStorage()

			local v200 = WebLogin.getWebLogin() == WebLaunchOption.FromWebBanner or (WebLogin.getWebLogin() == WebLaunchOption.FromWebPlayGame or WebLogin.getWebLogin() == WebLaunchOption.FromCommandLine)

			handleNoCachedUser(p66, p67, p68, p69, v200, u197, v196, p75, Home, p71, false, p72, p73, p74)
		else
			PostSignUpAttribution.attributeV2(p66, p70)

			if u197.userId ~= -1 then
				Logger:info(string.format("[%f] LaunchApp::initializeForCachedUser()", tick()))

				if GetFFlagEnableHandleEngineSessionCheckAtStartup() and p70 == LaunchContext.Startup then
					initializeForCachedUserV2(p66, p67, p68, p69, u197, Home, p75, v196, p71, false, p72, p73)
				else
					initializeForCachedUser(p66, p67, p68, p69, u197, Home, p75, v196, p71, false, p72, p73)
				end
			else
				Logger:info(string.format("[%f] LaunchApp::handleNoCachedUser()", tick()))

				local v201 = p70 ~= LaunchContext.Startup

				if FFlagEnableLuaAccountSwitch then
					local v202 = AppStorageUtilities.getAccountSwitchStatus()

					if not (not FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues and not FFlagApplyLaunchContextForNewAccountSwitches) and v202 == AccountSwitcherConstants.AccountSwitcherSwitchedStatus or (v202 == AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus or v202 == AccountSwitcherConstants.AccountSwitcherSwitchedFromSignupStatus) then
						v201 = true
						AppStorageUtilities.setAccountSwitchStatus("")
						AppStorageUtilities.setAccountSwitchTargetUsername("")
					elseif not FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues and v202 == Constants.Auth.AccountSwitcherSwitchedStatus then
						v201 = true
						AppStorageUtilities.setAccountSwitchStatus("")
						AppStorageUtilities.setAccountSwitchTargetUsername("")
					end

					if AppStorageUtilities.getSignupActionRequired() == "auth" then
						v201 = false
					end
				end

				handleNoCachedUser(p66, p67, p68, p69, v201, u197, v196, p75, Home, p71, false, p72, p73, p74)
			end
		end
	end
end

return launchApp
