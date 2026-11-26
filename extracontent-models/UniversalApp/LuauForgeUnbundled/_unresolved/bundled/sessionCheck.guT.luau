local MemStorageService = game:GetService("MemStorageService")
local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/ghQ")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local getLocalUser = require("@luauforge/bundled/ciE").Thunks.GetLocalUser
local module3 = require("@luauforge/bundled/gfe")

local setAuthenticationStatus = require("@luauforge/bundled/ggh").Actions.SetAuthenticationStatus
local module4 = require("@luauforge/bundled/dKv")
local module5 = require("@luauforge/bundled/gib")
local module6 = require("@luauforge/bundled/gfG")
local isPioneerLaunch = require("@luauforge/bundled/gid").isPioneerLaunch
local module7 = require("@luauforge/bundled/dFu")
local module8 = require("@luauforge/bundled/gfK")
local module9 = require("@luauforge/bundled/ggj")
local module10 = require("@luauforge/bundled/fvN")
local module11 = require("@luauforge/bundled/gih")
local module12 = require("@luauforge/bundled/ehl")
local module13 = require("@luauforge/bundled/gij")

local receivedUserCountryCode = require("@luauforge/bundled/dAW").ReceivedUserCountryCode

local fFlagUseSignalsForModeration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForModeration

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/bundled/guU").GetModerationStore else nil

local HttpService = game:GetService("HttpService")
local default = require("@luauforge/bundled/ggu").CredentialsProtocol.default
local ContentProvider = game:GetService("ContentProvider")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local keystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local keystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local keystoreConstants = AuthCommon.Common.KeystoreConstants

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
local module16 = require("@luauforge/bundled/ghT")
local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes
local getFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local fFlagUseSignalsForCountryCode = SharedFlags.FFlagUseSignalsForCountryCode
local fFlagEnablePioneerPostAuthGameJoin = SharedFlags.FFlagEnablePioneerPostAuthGameJoin

local getCountryCodeStore = if fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dAW").GetCountryCodeStore else nil

local TelemetryService = game:GetService("TelemetryService")

local keystoreDeleteCredentialsTelemetryConfig = require("@luauforge/bundled/fzT").TelemetryConfigs.KeystoreDeleteCredentialsTelemetryConfig

local module17 = require("@luauforge/bundled/gii")
local module18 = require("@luauforge/bundled/ggt")
local module19 = require("@luauforge/bundled/gfb")
local module20 = require("@luauforge/bundled/gfd")
local appStartupSequenceTag = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppStartupSequenceTag
local appPrefetch = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppPrefetch
local involuntaryLogoutAnalyticsEvents = AuthCommon.Analytics.InvoluntaryLogoutAnalyticsEvents
local module21 = require("@luauforge/bundled/fzS")

local function handleUserLoggedIn(object, object2)
	involuntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(
		module21.Origin.LandingScreen,
		module21.Context.SessionCheckDidLogin
	)

	GuiService:BroadcastNotification(object:toJsonData(), module10.DID_LOG_IN)

	if fFlagUseSignalsForAuthenticationStatus then
		getAuthenticationStatusStore(false).setAuthenticationStatus(module9.LOGGED_IN)
	else
		object2:dispatch(setAuthenticationStatus(module9.LOGGED_IN))
	end
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

local function navigateToPostAuthPage(object, home, p2, p3)
	if fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch() then
		return
	end

	if (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or module6.getSignupActionRequired()) == "auth" then
		if module16() then
			object:dispatch(module4({
				{ name = module7.AddAuthMethodPage }
			}))
			return
		end

		module6.setSignupActionRequired("")
		module6.flush()
		object:dispatch(module4({
			{ name = home }
		}))
	elseif fFlagPreHomePageRoutingEnabled or fFlagPasskeyUpsellEnabled then
		handlePreHomePageRouting(p3, object, module4):andThen(function(p4)
			if not p4 then
				object:dispatch(module4({
					{ name = home }
				}))
			end
		end)
	else
		object:dispatch(module4({
			{ name = home }
		}))
	end
end

local function isUserModerated(object)
	if fFlagUseSignalsForModeration then
		return getModerationStore(false).getUserModerated(false) or false
	end

	local moderation = object:getState().Moderation
	return moderation and moderation.userModerated or false
end

local function sessionCheck(p2, p3, p4, p5, home, fn2)
	return function(object)
		local v5

		if fFlagUseSignalsForModeration then
			v5 = getModerationStore(false).getUserModerated(false) or false
		else
			local moderation = object:getState().Moderation
			v5 = moderation and moderation.userModerated or false
		end

		if v5 then
			involuntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(
				module21.Origin.LandingScreen,
				module21.Context.SessionCheckSkippedForModeratedUser
			)

			return
		end

		local v6 = module19(p2)

		local home2 = module7.Home
		local v7 = appStartupSequenceTag
		local v8 = appPrefetch

		local function fn3()
			return object:dispatch(module20(p2, p2, p4, p5, fn2, v7, v8))
		end

		return module(p2):andThen(function(p6)
			involuntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(
				module21.Origin.LandingScreen,
				module21.Context.SessionCheckSuccess
			)

			local v9 = Models.fromUserInfoRequest(p6)

			if object:getState().CentralOverlay.OverlayType == module12.AccountAuthenticationFailureOverlay then
				object:dispatch(module11())

				if v9:isEqual(p3) then
					involuntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(
						module21.Origin.LandingScreen,
						module21.Context.SessionCheckLocalPlayerMatch
					)

					navigateToPostAuthPage(object, home2, v9, p2)
				end
			end

			if not v9:isEqual(p3) then
				involuntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(
					module21.Origin.LandingScreen,
					module21.Context.SessionCheckLocalPlayerMismatch
				)

				v9:setToLocalPlayer()
				v9:setToLocalStorage()

				object:dispatch(getLocalUser())

				if fFlagUseSignalsForCountryCode then
					getCountryCodeStore(false).setCountryCode(v9.countryCode)
				else
					object:dispatch(receivedUserCountryCode(v9.countryCode))
				end

				navigateToPostAuthPage(object, home2, v9, p2)
			end

			local v10 = {}
			table.insert(v10, v6:andThen(function(p7)
				module6.setRobloxLocaleId(p7.generalExperienceLocale)
				module6.setGameLocaleId(p7.ugcLocale)
				LocalizationService:SetRobloxLocaleId(p7.generalExperienceLocale)
			end))

			local v11 = module5(p2, v9.userId)

			object:dispatch(module13(p2))
			local v12 = (not game:GetEngineFeature("SignupActionRequiredKeyAvailable") and "" or module6.getSignupActionRequired()) == "auth"

			local v13 = fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch()

			table.insert(v10, v11:andThen(function(p7)
				module6.setAuthenticatedTheme(p7)

				if not (v12 or v13) then
					MemStorageService:Fire(module8.ThemeUpdate, p7)
				end
			end))

			module3.Batch(v10):andThen(function()
				module6.flush()
			end)
			handleUserLoggedIn(v9, object)
			return v9
		end, function(p6)
			if p6.StatusCode == statusCodes.UNAUTHORIZED then
				involuntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(
					module21.Origin.LandingScreen,
					module21.Context.SessionCheckUnauthorized
				)

				keystoreAnalyticsEvents.sendPageLoadEvent(keystoreEventConstants.origin.remoteLogoutDelete)
				TelemetryService:LogCounter(keystoreDeleteCredentialsTelemetryConfig, {
					customFields = { reason = "remote_logout" }
				}, 1)

				fn()
			else
				involuntaryLogoutAnalyticsEvents.sendImmediatelyPageLoadEvent(
					module21.Origin.LandingScreen,
					"ErrorCode: " .. tostring(p6.StatusCode) .. " Msg: " .. tostring(p6)
				)

				module17(object, function()
					sessionCheck(p2, p3, v6, true, home2, fn3)
				end)
			end
		end)
	end
end

return sessionCheck
