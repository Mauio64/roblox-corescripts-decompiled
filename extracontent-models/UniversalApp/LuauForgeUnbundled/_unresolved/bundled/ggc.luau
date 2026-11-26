local LocalizationService = game:GetService("LocalizationService")
local MemStorageService = game:GetService("MemStorageService")
local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/gfe")
local module2 = require("@luauforge/bundled/gfG")
local module3 = require("@luauforge/bundled/ggd")
local GuiService = game:GetService("GuiService")

local setAuthenticationStatus = require("@luauforge/bundled/ggh").Actions.SetAuthenticationStatus
local module4 = require("@luauforge/bundled/ggi")
local module5 = require("@luauforge/bundled/ggp")
local module6 = require("@luauforge/bundled/dKv")
local module7 = require("@luauforge/bundled/ggj")
local module8 = require("@luauforge/bundled/gfK")
local module9 = require("@luauforge/bundled/dFt")
local module10 = require("@luauforge/bundled/ehB")
local module11 = require("@luauforge/bundled/ghP")
local module12 = require("@luauforge/bundled/dFu")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local experimentCacheManager = require("@luauforge/bundled/ggm").ExperimentCacheManager
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module15 = require("@luauforge/bundled/ggo")
local TelemetryService = game:GetService("TelemetryService")

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local module16 = require("@luauforge/bundled/ggv")
local getFFlagKeystoreAutoLoginAvailable = SharedFlags.GetFFlagKeystoreAutoLoginAvailable
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local keystoreAnalyticsEvents = AuthCommon.Analytics.KeystoreAnalyticsEvents
local keystoreEventConstants = AuthCommon.Analytics.KeystoreEventConstants
local telemetryConfigs = require("@luauforge/bundled/fzT").TelemetryConfigs
local luaLogoutTelemetryConfig = telemetryConfigs.LuaLogoutTelemetryConfig
local keystoreRedirectTelemetryConfig = telemetryConfigs.KeystoreRedirectTelemetryConfig

local getFFlagEnableStorePreviousAccountData = SharedFlags.GetFFlagEnableStorePreviousAccountData
local storePreviousAccountData = AuthCommon.Thunks.StorePreviousAccountData

local fFlagEnableCallingLogoutOnResetIXP = SharedFlags.FFlagEnableCallingLogoutOnResetIXP
local appBtidLayers = require("@luauforge/bundled/dPQ").AppBtidLayers
local IXPService = game:GetService("IXPService")

local function isEnableCallingLogoutOnResetFromIxp()
	local success, result = pcall(function()
		return IXPService:GetBrowserTrackerLayerVariables(appBtidLayers.LandingLayer)
	end)

	if success and result ~= nil and result.iOSEnableCallingLogoutOnReset ~= nil then
		return result.iOSEnableCallingLogoutOnReset
	end

	return true
end

local function hasNonNilEntries(items): boolean
	if items == nil then
		return false
	end

	for k, item in pairs(items) do
		if item ~= nil then
			return true
		end
	end

	return false
end

return function(p2, object, p3, p4, p5, p6, p7, p8)
	module.Batch({ p4 }):andThen(function(list)
		if list and list[1] then
			list[1]:match(function(p9)
				module2.setRobloxLocaleId(p9.signupAndLoginLocale)
				LocalizationService:SetRobloxLocaleId(p9.signupAndLoginLocale)
			end)
		end

		if p2 then
			if fFlagEnableCallingLogoutOnResetIXP then
				local success, result = pcall(function()
					return IXPService:GetBrowserTrackerLayerVariables(appBtidLayers.LandingLayer)
				end)

				if
					(not success or result == nil or result.iOSEnableCallingLogoutOnReset == nil or result.iOSEnableCallingLogoutOnReset)
					and p5 == module5.UnauthorizedAutoLogin
				then
					object:dispatch(module4(p3, GuiService, p5))
				else
					if getFFlagEnableStorePreviousAccountData() then
						storePreviousAccountData()
					end

					object:dispatch(module3())
					MemStorageService:Fire(module8.ThemeUpdate, "dark")
				end
			else
				if getFFlagEnableStorePreviousAccountData() then
					storePreviousAccountData()
				end

				object:dispatch(module3())
				MemStorageService:Fire(module8.ThemeUpdate, "dark")
			end
		end

		if fFlagUseSignalsForAuthenticationStatus then
			getAuthenticationStatusStore(false).setAuthenticationStatus(module7.LOGGED_OUT)
		else
			object:dispatch(setAuthenticationStatus(module7.LOGGED_OUT))
		end

		if p5 ~= nil then
			LoggingProtocol.default:logRobloxTelemetryEvent(module15, nil, {
				lualogoutreasons = p5
			})
		end

		TelemetryService:LogCounter(luaLogoutTelemetryConfig, {
			customFields = {
				reason = p5 or module5.Unknown
			}
		}, 1)

		if module9.WeChatLoginEnabled() then
			object:dispatch(module6({
				{ name = module12.WeChatLoginWrapper }
			}))
		elseif module9.LuaAppLoginUIEnabled() then
			if getAppFeaturePolicies().getUseSingleSignOn() then
				local v5 = {
					{ name = module12.SingleSignOnContainer }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.to(navigationCommands.fromLegacyPage(v5[#v5]))
				else
					object:dispatch(module11(v5))
				end
			else
				local v5 = p6
				local v6

				if v5 == nil then
					v6 = false
				else
					local flag = true

					for k, v7 in pairs(v5) do
						if v7 ~= nil then
							v6 = true
							flag = false
							break
						end
					end

					if flag then
						v6 = false
					end
				end

				if (module16 or getFFlagKeystoreAutoLoginAvailable()) and p6 and v6 then
					local v7 = {}

					if p8 == nil or p8 == false then
						keystoreAnalyticsEvents.sendPageLoadEvent(keystoreEventConstants.origin.redirectToLandingPage)
						TelemetryService:LogCounter(keystoreRedirectTelemetryConfig, {
							customFields = { destination = "landing_page" }
						}, 1)

						object:dispatch(module6({
							{ name = module12.Landing, extraProps = v7 }
						}))
					else
						TelemetryService:LogCounter(keystoreRedirectTelemetryConfig, {
							customFields = { destination = "login_page" }
						}, 1)

						v7.forcedUsernameOverride = p6.username

						keystoreAnalyticsEvents.sendPageLoadEvent(keystoreEventConstants.origin.redirectToLoginPage)
						object:dispatch(module6({
							{ name = module12.Landing, extraProps = {} },
							{ name = module12.LoginV2, extraProps = v7 }
						}))
					end
				else
					if getFFlagEnableStorePreviousAccountData() then
						storePreviousAccountData()
					end

					object:dispatch(module6({
						{ name = module12.Landing, extraProps = {} }
					}))
				end
			end
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage({
				name = module12.LoginNative
			}))
		else
			object:dispatch(module10({ name = module12.LoginNative }))
		end

		RoactAppExperiment.clearUserLayers()
		experimentCacheManager.default:clearCache()
	end)
end
