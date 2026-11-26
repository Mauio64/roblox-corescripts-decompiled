local LocalizationService = game:GetService("LocalizationService")
local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")

local CorePackages = game:GetService("CorePackages")

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local module = require("@luauforge/bundled/gfb")
local module2 = require("@luauforge/bundled/gib")
local module3 = require("@luauforge/bundled/dKv")
local getLocalUser = require("@luauforge/bundled/ciE").Thunks.GetLocalUser
local module4 = require("@luauforge/bundled/gfd")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module6 = require("@luauforge/bundled/ggd")
local module7 = require("@luauforge/bundled/gfG")
local module8 = require("@luauforge/bundled/ggi")
local module9 = require("@luauforge/bundled/ggp")

require("@game/CorePackages/Workspace/Packages/Http")
local receivedUserCountryCode = require("@luauforge/bundled/dAW").ReceivedUserCountryCode
local fFlagUseSignalsForCountryCode = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForCountryCode

local getCountryCodeStore = if fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dAW").GetCountryCodeStore else nil

local setAuthenticationStatus = require("@luauforge/bundled/ggh").Actions.SetAuthenticationStatus
local module10 = require("@luauforge/bundled/gsv")

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local module11 = require("@luauforge/bundled/ggj")
local module12 = require("@luauforge/bundled/gfK")
local module13 = require("@luauforge/bundled/gfH")
local module14 = require("@luauforge/bundled/fvN")
local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes

local module15 = require("@luauforge/bundled/gsw")

local module16 = require("@luauforge/bundled/dFu")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module17 = require("@luauforge/bundled/egs")
local module18 = require("@luauforge/bundled/gfe")

local authenticationProtocol = require("@luauforge/bundled/grY").AuthenticationProtocol

local function initABTesting(p2)
	RoactAppExperiment.initializeUserLayers(p2)
end

local function handleUserLoggedIn(object, object2)
	GuiService:BroadcastNotification(object:toJsonData(), module14.DID_LOG_IN)

	if fFlagUseSignalsForAuthenticationStatus then
		getAuthenticationStatusStore(false).setAuthenticationStatus(module11.LOGGED_IN)
	else
		object2:dispatch(setAuthenticationStatus(module11.LOGGED_IN))
	end
end

local function resetOnNoAccountInfo(object, p2, p3)
	local v5 = { (module(p2)) }
	module18.Batch(v5):andThen(function(list)
		list[1]:match(function(p4)
			module7.setRobloxLocaleId(p4.signupAndLoginLocale)
			LocalizationService:SetRobloxLocaleId(p4.signupAndLoginLocale)
		end)

		if p3 then
			object:dispatch(module6())
		end

		if fFlagUseSignalsForAuthenticationStatus then
			getAuthenticationStatusStore(false).setAuthenticationStatus(module11.LOGGED_OUT)
		else
			object:dispatch(setAuthenticationStatus(module11.LOGGED_OUT))
		end

		object:dispatch(module3({
			{ name = module16.Landing }
		}))
	end)
end

local function getUserAccountInfo(object, p2, p3, p4, p5)
	return module10(p2):andThen(function(p6)
		p3.Diag:reportCounter(module15.Success, 1)
		local v5 = Models.fromRequest(p6)

		if not v5:isEqual(p5) or p4.useMSDKWebAuthentication() then
			v5:setToLocalPlayer()
			v5:setToLocalStorage()
			object:dispatch(module6())
			object:dispatch(getLocalUser())

			if fFlagUseSignalsForCountryCode then
				getCountryCodeStore(false).setCountryCode(v5.countryCode)
			else
				object:dispatch(receivedUserCountryCode(v5.countryCode))
			end

			object:dispatch(module3({
				{ name = module16.Home }
			}))

			local userId = v5.userId
			RoactAppExperiment.initializeUserLayers(userId)
		end

		object:dispatch(module4(p2, p3, p4))

		local v6 = {}

		table.insert(v6, module(p2):andThen(function(p7)
			module7.setRobloxLocaleId(p7.generalExperienceLocale)
			module7.setGameLocaleId(p7.ugcLocale)
			LocalizationService:SetRobloxLocaleId(p7.generalExperienceLocale)
		end))

		local authenticatedTheme = module7.getAuthenticatedTheme()
		MemStorageService:Fire(module12.ThemeUpdate, authenticatedTheme)
		table.insert(v6, module2(p2, v5.userId):andThen(function(p7)
			module7.setAuthenticatedTheme(p7)
			MemStorageService:Fire(module12.ThemeUpdate, p7)
		end))

		module18.Batch(v6):andThen(function()
			module7.flush()
		end)

		return module17.resolve(v5)
	end, function(p6)
		if p6.StatusCodes == statusCodes.UNAUTHORIZED then
			p3.Diag:reportCounter(module15.Failure401Unauthenticated, 1)
		end

		p3.Diag:reportCounter(module15.Failure, 1)
		return module17.reject()
	end)
end

local function handleCachedUser(object, p2, p3, p4, object2)
	object2:setToLocalPlayer()
	local userId = object2.userId
	RoactAppExperiment.initializeUserLayers(userId)

	spawn(function()
		object:dispatch(getLocalUser())

		if fFlagUseSignalsForCountryCode then
			getCountryCodeStore(false).setCountryCode(object2.countryCode)
		else
			object:dispatch(receivedUserCountryCode(object2.countryCode))
		end

		object:dispatch(module3({
			{ name = module16.Home }
		}))

		getUserAccountInfo(object, p2, p3, p4, object2):andThen(function(p5)
			local v5, v6 = authenticationProtocol.default:requestAuth(
				authenticationProtocol.AuthProviders.MSDK,
				authenticationProtocol.AuthMethods.NONE
			):await()

			if v5 and v6.statusCode == 0 then
				handleUserLoggedIn(p5, object)
				return
			end

			logger:info("MSDK Auto Login with ErrorCode: " .. v6.statusCode)
			resetOnNoAccountInfo(object, p2, true)
			p3.Diag:reportCounter("MSDKAutoLoginErrorCode_" .. v6.statusCode, 1)
			object:dispatch(module8(p2, GuiService, module9.UnauthorizedAutoLogin))
		end, function()
			resetOnNoAccountInfo(object, p2, true)
		end)
	end)
end

local function handleNoCachedUser(p2, p3, p4, p5, p6, p7)
	if p7 then
		resetOnNoAccountInfo(p2, p3, false)
	else
		spawn(function()
			getUserAccountInfo(p2, p3, p4, p5, p6):andThen(function(p8)
				handleUserLoggedIn(p8, p2)
			end, function()
				resetOnNoAccountInfo(p2, p3, false)
			end)
		end)
	end
end

return function(p2, p3, p4, p5)
	return function(object)
		local v5 = Models.fromLocalStorage()

		if v5.userId == -1 or p4.useMSDKWebAuthentication() then
			logger:info(string.format("[%f] LaunchLuobuApp::handleNoCachedUser()", tick()))

			local v6 = p2
			local v7 = p3
			local v8 = p4

			if p5 == module13.Startup then
				resetOnNoAccountInfo(object, v6, false)
			else
				spawn(function()
					getUserAccountInfo(object, v6, v7, v8, v5):andThen(function(p6)
						handleUserLoggedIn(p6, object)
					end, function()
						resetOnNoAccountInfo(object, v6, false)
					end)
				end)
			end
		else
			logger:info(string.format("[%f] LaunchLuobuApp::handleCachedUser()", tick()))
			local v6 = p2
			local v7 = p3
			local v8 = p4
			v5:setToLocalPlayer()
			local userId = v5.userId
			RoactAppExperiment.initializeUserLayers(userId)

			spawn(function()
				object:dispatch(getLocalUser())

				if fFlagUseSignalsForCountryCode then
					getCountryCodeStore(false).setCountryCode(v5.countryCode)
				else
					object:dispatch(receivedUserCountryCode(v5.countryCode))
				end

				object:dispatch(module3({
					{ name = module16.Home }
				}))

				getUserAccountInfo(object, v6, v7, v8, v5):andThen(function(p6)
					local v9, v10 = authenticationProtocol.default:requestAuth(
						authenticationProtocol.AuthProviders.MSDK,
						authenticationProtocol.AuthMethods.NONE
					):await()

					if v9 and v10.statusCode == 0 then
						handleUserLoggedIn(p6, object)
						return
					end

					logger:info("MSDK Auto Login with ErrorCode: " .. v10.statusCode)
					resetOnNoAccountInfo(object, v6, true)
					v7.Diag:reportCounter("MSDKAutoLoginErrorCode_" .. v10.statusCode, 1)
					object:dispatch(module8(v6, GuiService, module9.UnauthorizedAutoLogin))
				end, function()
					resetOnNoAccountInfo(object, v6, true)
				end)
			end)
		end
	end
end
