local module = require("@luauforge/bundled/hBs")
local payloadKey = module.Enums.PayloadKey
local activationFrameworkContextAction = module.Enums.ActivationFrameworkContextAction
local module2 = require("@luauforge/bundled/hCA")
local default = module2.CredentialsProtocol.default

local getFIntLuaAppCredentialsProtocolAvailableTimeout = module2.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local logger = require("@luauforge/bundled/hCB").Logger
local module3 = require("@luauforge/bundled/hCq")
local authPageload = module3.Events.authPageload
local authClientError = module3.Events.authClientError
local eventStreamConstants = module3.EventStreamConstants

local function getCredentialsProtocolAvailability(p2, p3, callback)
	local v5 = false
	local v6 = false
	local v7 = false

	if p2[payloadKey.CredentialsProtocolPasskeyRegistrationAvailable] == nil then
		local lastTime = os.clock()

		default:isAvailable(
			default.CredentialsTypes.all,
			getFIntLuaAppCredentialsProtocolAvailableTimeout()
		):andThen(function(data)
			authPageload(
				eventStreamConstants.Context.MultiPageSignupIsAvailableFetch,
				(tostring(os.clock() - lastTime))
			)

			if data.FIDO2 == nil then
				v5 = if data.isAvailable then data.supportsDeviceBoundOnly or false else false
			else
				v5 = data.FIDO2.isAvailable and data.FIDO2.supportsDeviceBoundOnly

				v7 = true
			end

			if data.password ~= nil then
				v6 = data.password.isAvailable
			end

			local v8 = {
				[payloadKey.CredentialsProtocolPasskeyRegistrationAvailable] = tostring(v5),
				[payloadKey.CredentialsProtocolPasswordRegistrationAvailable] = tostring(v6),
				[payloadKey.CredentialsProtocolV2InterfaceAvailable] = tostring(v7)
			}

			callback({
				type = activationFrameworkContextAction.SetMergePayload,
				data = { payloadTable = v8 }
			})
		end):catch(function(p4)
			authClientError(p3, eventStreamConstants.State.CredentialsProtocolNotAvailable)
			logger:warning("Error checking for credential availability. Error: {}", p4)
		end)
	else
		authPageload(eventStreamConstants.Context.MultiPageSignupIsAvailableFetch, "0")

		v5 = p2[payloadKey.CredentialsProtocolPasskeyRegistrationAvailable] == "true"
		v6 = p2[payloadKey.CredentialsProtocolPasswordRegistrationAvailable] == "true"
		v7 = p2[payloadKey.CredentialsProtocolV2InterfaceAvailable] == "true"
	end

	return v5, v6, v7
end

return getCredentialsProtocolAvailability
