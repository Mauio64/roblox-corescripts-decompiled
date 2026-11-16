local HttpService = game:GetService("HttpService")

local passkeyCheck = require("@luauforge/bundled/fEg").Utils.PasskeyCheck
local logger = require("@luauforge/bundled/fDX").Logger
local module = require("@luauforge/bundled/fDZ")
local linkingProtocol = require("@luauforge/bundled/fEP").LinkingProtocol
local module2 = require("@luauforge/bundled/fEa")
local module3 = require("@luauforge/bundled/fER")
local module4 = require("@luauforge/bundled/fDY")
local module5 = require("@luauforge/bundled/fEd")
local default = require("@luauforge/bundled/fEZ").default
local telemetryConfigs = require("@luauforge/bundled/fES").TelemetryConfigs
local module6 = require("@luauforge/bundled/fES")
local ixpServiceWrapper = require("@luauforge/bundled/fET").IXPServiceWrapper
local appBtidLayers = require("@luauforge/bundled/fEU").AppBtidLayers
local authClientError = module6.Events.authClientError
local authMsgShown = module6.Events.authMsgShown
local authPageload = module6.Events.authPageload
local eventStreamConstants = module6.EventStreamConstants
local launchContext = require("@luauforge/bundled/fEc").Enums.LaunchContext
local userJustLoggedIn = module2.Checks.userJustLoggedIn
local fFlagEnableSilentUpgradeOnSignUp = module.FFlagEnableSilentUpgradeOnSignUp
local default2 = module3.CredentialsProtocol.default

local getFIntLuaAppCredentialsProtocolAvailableTimeout = module3.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local registerPasskey = module5.Thunks.RegisterPasskey
local passkeyRegistrationSource = module5.Enums.PasskeyRegistrationSource
local defineFastInt = game:DefineFastInt("SilentUpgradeReauthDelaySeconds", 4)
local fFlagEmitPasskeyRegistrationSourceOnFinish = module.FFlagEmitPasskeyRegistrationSourceOnFinish
local defineFastFlag = game:DefineFastFlag("SilentUpgradeOnSignupIXPBypass", false)

local function getShouldUseSilentPasskeyUpgrade(p2)
	if fFlagEnableSilentUpgradeOnSignUp and p2 == launchContext.SignUp then
		local btidLayerData = ixpServiceWrapper:GetBTIDLayerData(appBtidLayers.SignupLayer)

		if btidLayerData and btidLayerData.shouldUseSilentPasskeyUpgradeForSignup ~= nil then
			authPageload(
				eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
				eventStreamConstants.State.SignupLayerExposure
			)
		end

		return defineFastFlag or btidLayerData and btidLayerData.shouldUseSilentPasskeyUpgradeForSignup
	elseif p2 == launchContext.Login then
		return ixpServiceWrapper:GetBTIDLayerData(appBtidLayers.LoginLayer).shouldUseSilentPasskeyUpgrade
	else
		return false
	end
end

local function checkDeviceSupportsSilentPasskeyUpgrade(p2)
	local v5 = fFlagEnableSilentUpgradeOnSignUp and { source = p2 } or nil

	return default2:isAvailable(
		default2.CredentialsTypes.FIDO2,
		getFIntLuaAppCredentialsProtocolAvailableTimeout()
	):andThen(function(p3)
		if p3 and not p3.FIDO2 then
			authPageload(
				eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
				eventStreamConstants.State.FilteredByNoPasskeySupport
			)
		end

		if p3 and p3.FIDO2 and not p3.FIDO2.supportsSilentPasskeyUpgrade then
			authPageload(
				eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
				eventStreamConstants.State.FilteredByNoSilentUpgradeSupport
			)
		end

		local supportsSilentPasskeyUpgrade = p3 and p3.FIDO2 and p3.FIDO2.supportsSilentPasskeyUpgrade

		if supportsSilentPasskeyUpgrade then
			default:logRobloxTelemetryCounter(telemetryConfigs.SilentPasskeyUpgradeAvailableConfig, 1, v5)
		end

		return module4.resolve(supportsSilentPasskeyUpgrade)
	end):catch(function(p3)
		logger:warning("Failed to check device availability for silent upgrade: " .. tostring(p3))
		return module4.resolve(false)
	end)
end

local function performSilentPasskeyUpgrade(p2, p3)
	local v5 = fFlagEnableSilentUpgradeOnSignUp and { source = p3 } or nil
	local v6

	if fFlagEmitPasskeyRegistrationSourceOnFinish then
		local v10

		if p3 == launchContext.SignUp then
			v10 = passkeyRegistrationSource.PasskeySilentUpgradeSignup
		else
			v10 = passkeyRegistrationSource.PasskeySilentUpgradeLogin
		end

		v6 = registerPasskey(p2, "passkeySilentUpgrade", true, v10)
	else
		v6 = registerPasskey(p2, "passkeySilentUpgrade", true)
	end

	return v6:andThen(function()
		default:logRobloxTelemetryCounter(telemetryConfigs.SilentPasskeyUpgradeSuccessConfig, 1, v5)

		authPageload(
			eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
			eventStreamConstants.State.UpgradeSuccess
		)

		if fFlagEmitPasskeyRegistrationSourceOnFinish then
			authMsgShown(
				eventStreamConstants.Context.PasskeyCreationSource,
				eventStreamConstants.State.FinishRegistration,
				"passkeySilentUpgrade"
			)
		end
	end, function(p4)
		return module4.reject(p4)
	end):catch(function(p4)
		local jsonEncode = HttpService:JSONEncode(p4)
		logger:warning("Silent passkey upgrade failed: " .. jsonEncode)
		authClientError(eventStreamConstants.Context.HandleSilentPasskeyUpgrade, jsonEncode)
		default:logRobloxTelemetryCounter(telemetryConfigs.SilentPasskeyUpgradeFailureConfig, 1, v5)

		authPageload(
			eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
			eventStreamConstants.State.UpgradeFailure
		)

		return module4.resolve()
	end)
end

local function attemptSilentPasskeyUpgrade(p2, p3, p4)
	if not getShouldUseSilentPasskeyUpgrade(p4) then
		authPageload(
			eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
			eventStreamConstants.State.FilteredByIXP
		)

		return
	end

	local v5 = not (linkingProtocol:getLastLuaURL() == nil) and linkingProtocol:getLastLuaURL() ~= ""

	if v5 then
		logger:info("Skipping passkey silent upgrade due to deep link")
		authPageload(
			eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
			eventStreamConstants.State.FilteredByDeepLink
		)
	elseif fFlagEnableSilentUpgradeOnSignUp or userJustLoggedIn(p3) then
		local v6 = fFlagEnableSilentUpgradeOnSignUp and { source = p4 } or nil
		default:logRobloxTelemetryCounter(telemetryConfigs.SilentPasskeyUpgradeAttemptedConfig, 1, v6)

		authPageload(
			eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
			eventStreamConstants.State.UpgradeAttempted
		)

		checkDeviceSupportsSilentPasskeyUpgrade(p4):andThen(function(p5)
			if p5 then
				return passkeyCheck(p2):andThen(function(p6)
					if not p6 then
						default:logRobloxTelemetryCounter(
							telemetryConfigs.SilentPasskeyUpgradeNoPasskeyConfig,
							1,
							v6
						)

						return module4.delay(defineFastInt):andThen(function()
							return performSilentPasskeyUpgrade(p2, p4)
						end)
					end

					logger:info("User already has a passkey, skipping silent upgrade")
					authPageload(
						eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
						eventStreamConstants.State.FilteredByExistingPasskey
					)
				end)
			end

			logger:info("Device does not support silent upgrade, skipping")
		end):catch(function(p5)
			local jsonEncode = HttpService:JSONEncode(p5)
			logger:warning("Silent passkey upgrade failed: " .. jsonEncode)
			authClientError(eventStreamConstants.Context.HandleSilentPasskeyUpgrade, jsonEncode)
			return module4.resolve()
		end)
	else
		logger:info("Skipping passkey silent upgrade due to cached login")
		authPageload(
			eventStreamConstants.Context.HandleSilentPasskeyUpgrade,
			eventStreamConstants.State.FilteredByCachedLogin
		)
	end
end

local function HandleSilentUpgrade(p2, p3, p4)
	attemptSilentPasskeyUpgrade(p2, p3, p4 or launchContext.Login)
end

return HandleSilentUpgrade
