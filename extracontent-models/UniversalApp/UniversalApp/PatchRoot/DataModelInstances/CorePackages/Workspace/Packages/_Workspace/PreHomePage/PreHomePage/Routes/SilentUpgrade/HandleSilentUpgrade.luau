local PreHomePage = script:FindFirstAncestor("PreHomePage")
local HttpService = game:GetService("HttpService")
local PreHomePageParent = PreHomePage.Parent
local PasskeyCheck = require(PreHomePageParent.PasskeyUpsell).Utils.PasskeyCheck
local Logger = require(PreHomePageParent.Loggers).Logger
local SharedFlags = require(PreHomePageParent.SharedFlags)
local LinkingProtocol = require(PreHomePageParent.LinkingProtocol).LinkingProtocol
local Common = require(PreHomePage.Common)
local CredentialsProtocol = require(PreHomePageParent.CredentialsProtocol)
local Promise = require(PreHomePageParent.Promise)
local AuthCommon = require(PreHomePageParent.AuthCommon)
local default = require(PreHomePageParent.LoggingProtocol).default
local TelemetryConfigs = require(PreHomePageParent.AuthAnalytics).TelemetryConfigs
local AuthAnalytics = require(PreHomePageParent.AuthAnalytics)
local IXPServiceWrapper = require(PreHomePageParent.IXPServiceWrapper).IXPServiceWrapper
local AppBtidLayers = require(PreHomePageParent.ExperimentLayers).AppBtidLayers
local authClientError = AuthAnalytics.Events.authClientError
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authPageload = AuthAnalytics.Events.authPageload
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local LaunchContext = require(PreHomePageParent.AppStartup).Enums.LaunchContext
local userJustLoggedIn = Common.Checks.userJustLoggedIn
local FFlagPasskeySilentUpgradeEnabled = SharedFlags.FFlagPasskeySilentUpgradeEnabled
local FFlagEnableSilentUpgradeOnSignUp = SharedFlags.FFlagEnableSilentUpgradeOnSignUp
local default2 = CredentialsProtocol.CredentialsProtocol.default
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local RegisterPasskey = AuthCommon.Thunks.RegisterPasskey
local v28 = game:DefineFastInt("SilentUpgradeReauthDelaySeconds", 4)
local FFlagEmitPasskeyRegistrationSourceOnFinish = SharedFlags.FFlagEmitPasskeyRegistrationSourceOnFinish
local v30 = game:DefineFastFlag("SilentUpgradeOnSignupIXPBypass", false)

local function getShouldUseSilentPasskeyUpgrade(p1) -- line: 37
	-- upvalues: FFlagEnableSilentUpgradeOnSignUp (copy), LaunchContext (copy), IXPServiceWrapper (copy), AppBtidLayers (copy), authPageload (copy), EventStreamConstants (copy), v30 (copy)
	if FFlagEnableSilentUpgradeOnSignUp and p1 == LaunchContext.SignUp then
		local BTIDLayerData = IXPServiceWrapper:GetBTIDLayerData(AppBtidLayers.SignupLayer)

		if BTIDLayerData and BTIDLayerData.shouldUseSilentPasskeyUpgradeForSignup ~= nil then
			authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.SignupLayerExposure)
		end

		return v30 or BTIDLayerData and BTIDLayerData.shouldUseSilentPasskeyUpgradeForSignup
	end

	if p1 == LaunchContext.Login then
		return IXPServiceWrapper:GetBTIDLayerData(AppBtidLayers.LoginLayer).shouldUseSilentPasskeyUpgrade
	end

	return false
end
local function checkDeviceSupportsSilentPasskeyUpgrade(p2) -- line: 61
	-- upvalues: FFlagEnableSilentUpgradeOnSignUp (copy), default2 (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), authPageload (copy), EventStreamConstants (copy), default (copy), TelemetryConfigs (copy), Promise (copy), Logger (copy)
	local v39 = if not FFlagEnableSilentUpgradeOnSignUp then nil else {
		source = p2
	}

	return default2:isAvailable(default2.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p3) -- line: 65
		-- upvalues: authPageload (copy), EventStreamConstants (copy), default (copy), TelemetryConfigs (copy), v39 (copy), Promise (copy)
		if p3 and not p3.FIDO2 then
			authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.FilteredByNoPasskeySupport)
		end

		if p3 and p3.FIDO2 and not p3.FIDO2.supportsSilentPasskeyUpgrade then
			authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.FilteredByNoSilentUpgradeSupport)
		end

		local v51 = p3 and (p3.FIDO2 and p3.FIDO2.supportsSilentPasskeyUpgrade)

		if v51 then
			default:logRobloxTelemetryCounter(TelemetryConfigs.SilentPasskeyUpgradeAvailableConfig, 1, v39)
		end

		return Promise.resolve(v51)
	end):catch(function(p4) -- line: 98
		-- upvalues: Logger (copy), Promise (copy)
		Logger:warning("Failed to check device availability for silent upgrade: " .. tostring(p4))

		return Promise.resolve(false)
	end)
end
local function performSilentPasskeyUpgrade(p5, p6) -- line: 110
	-- upvalues: FFlagEnableSilentUpgradeOnSignUp (copy), RegisterPasskey (copy), default (copy), TelemetryConfigs (copy), authPageload (copy), EventStreamConstants (copy), FFlagEmitPasskeyRegistrationSourceOnFinish (copy), authMsgShown (copy), Promise (copy), HttpService (copy), Logger (copy), authClientError (copy)
	local v42 = if not FFlagEnableSilentUpgradeOnSignUp then nil else {
		source = p6
	}

	return RegisterPasskey(p5, "passkeySilentUpgrade", true):andThen(function() -- line: 113
		-- upvalues: default (copy), TelemetryConfigs (copy), v42 (copy), authPageload (copy), EventStreamConstants (copy), FFlagEmitPasskeyRegistrationSourceOnFinish (copy), authMsgShown (copy)
		default:logRobloxTelemetryCounter(TelemetryConfigs.SilentPasskeyUpgradeSuccessConfig, 1, v42)
		authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.UpgradeSuccess)

		if FFlagEmitPasskeyRegistrationSourceOnFinish then
			authMsgShown(EventStreamConstants.Context.PasskeyCreationSource, EventStreamConstants.State.FinishRegistration, "passkeySilentUpgrade")
		end
	end, function(p7) -- line: 130
		-- upvalues: Promise (copy)
		return Promise.reject(p7)
	end):catch(function(p8) -- line: 133
		-- upvalues: HttpService (copy), Logger (copy), authClientError (copy), EventStreamConstants (copy), default (copy), TelemetryConfigs (copy), v42 (copy), authPageload (copy), Promise (copy)
		local json = HttpService:JSONEncode(p8)

		Logger:warning("Silent passkey upgrade failed: " .. json)
		authClientError(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, json)
		default:logRobloxTelemetryCounter(TelemetryConfigs.SilentPasskeyUpgradeFailureConfig, 1, v42)
		authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.UpgradeFailure)

		return Promise.resolve()
	end)
end
local function attemptSilentPasskeyUpgrade(p9, p10, p11) -- line: 157
	-- upvalues: FFlagPasskeySilentUpgradeEnabled (copy), getShouldUseSilentPasskeyUpgrade (copy), authPageload (copy), EventStreamConstants (copy), LinkingProtocol (copy), Logger (copy), FFlagEnableSilentUpgradeOnSignUp (copy), userJustLoggedIn (copy), default (copy), TelemetryConfigs (copy), checkDeviceSupportsSilentPasskeyUpgrade (copy), PasskeyCheck (copy), Promise (copy), v28 (copy), performSilentPasskeyUpgrade (copy), HttpService (copy), authClientError (copy)
	if not FFlagPasskeySilentUpgradeEnabled then
		return
	end

	if not getShouldUseSilentPasskeyUpgrade(p11) then
		authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.FilteredByIXP)

		return
	end

	if LinkingProtocol:getLastLuaURL() ~= nil and LinkingProtocol:getLastLuaURL() ~= "" then
		Logger:info("Skipping passkey silent upgrade due to deep link")
		authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.FilteredByDeepLink)

		return
	end

	if not FFlagEnableSilentUpgradeOnSignUp and not userJustLoggedIn(p10) then
		Logger:info("Skipping passkey silent upgrade due to cached login")
		authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.FilteredByCachedLogin)

		return
	end

	local v46 = if not FFlagEnableSilentUpgradeOnSignUp then nil else {
		source = p11
	}

	default:logRobloxTelemetryCounter(TelemetryConfigs.SilentPasskeyUpgradeAttemptedConfig, 1, v46)
	authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.UpgradeAttempted)
	checkDeviceSupportsSilentPasskeyUpgrade(p11):andThen(function(p12) -- line: 206
		-- upvalues: Logger (copy), PasskeyCheck (copy), p9 (copy), authPageload (copy), EventStreamConstants (copy), default (copy), TelemetryConfigs (copy), v46 (copy), Promise (copy), v28 (copy), performSilentPasskeyUpgrade (copy), p11 (copy)
		if not p12 then
			Logger:info("Device does not support silent upgrade, skipping")

			return
		end

		return PasskeyCheck(p9):andThen(function(p13) -- line: 213
			-- upvalues: Logger (copy), authPageload (copy), EventStreamConstants (copy), default (copy), TelemetryConfigs (copy), v46 (copy), Promise (copy), v28 (copy), performSilentPasskeyUpgrade (copy), p9 (copy), p11 (copy)
			if p13 then
				Logger:info("User already has a passkey, skipping silent upgrade")
				authPageload(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, EventStreamConstants.State.FilteredByExistingPasskey)

				return
			end

			default:logRobloxTelemetryCounter(TelemetryConfigs.SilentPasskeyUpgradeNoPasskeyConfig, 1, v46)

			return Promise.delay(v28):andThen(function() -- line: 227
				-- upvalues: performSilentPasskeyUpgrade (copy), p9 (copy), p11 (copy)
				return performSilentPasskeyUpgrade(p9, p11)
			end)
		end)
	end):catch(function(p14) -- line: 232
		-- upvalues: HttpService (copy), Logger (copy), authClientError (copy), EventStreamConstants (copy), Promise (copy)
		local json = HttpService:JSONEncode(p14)

		Logger:warning("Silent passkey upgrade failed: " .. json)
		authClientError(EventStreamConstants.Context.HandleSilentPasskeyUpgrade, json)

		return Promise.resolve()
	end)
end
local function HandleSilentUpgrade(p15, p16, p17) -- line: 248
	-- upvalues: attemptSilentPasskeyUpgrade (copy), LaunchContext (copy)
	attemptSilentPasskeyUpgrade(p15, p16, p17 or LaunchContext.Login)
end

return HandleSilentUpgrade
