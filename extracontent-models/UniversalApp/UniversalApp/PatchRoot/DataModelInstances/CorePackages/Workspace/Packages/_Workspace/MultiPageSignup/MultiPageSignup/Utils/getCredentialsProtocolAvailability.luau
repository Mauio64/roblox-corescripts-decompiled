local Parent = script:FindFirstAncestor("MultiPageSignup").Parent
local UserActivationFramework = require(Parent.UserActivationFramework)
local PayloadKey = UserActivationFramework.Enums.PayloadKey
local ActivationFrameworkContextAction = UserActivationFramework.Enums.ActivationFrameworkContextAction
local CredentialsProtocol = require(Parent.CredentialsProtocol)
local default = CredentialsProtocol.CredentialsProtocol.default
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local Logger = require(Parent.Loggers).Logger
local AuthAnalytics = require(Parent.AuthAnalytics)
local authPageload = AuthAnalytics.Events.authPageload
local authClientError = AuthAnalytics.Events.authClientError
local EventStreamConstants = AuthAnalytics.EventStreamConstants

local function getCredentialsProtocolAvailability(t1: {[any]: any}, s1: string, p1) -- line: 19
	-- upvalues: PayloadKey (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), authPageload (copy), EventStreamConstants (copy), ActivationFrameworkContextAction (copy), authClientError (copy), Logger (copy)
	local u17 = false
	local u18 = false
	local u19 = false

	if t1[PayloadKey.CredentialsProtocolPasskeyRegistrationAvailable] == nil then
		local elapsed = os.clock()

		default:isAvailable(default.CredentialsTypes.all, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p2) -- line: 36
			-- upvalues: authPageload (copy), EventStreamConstants (copy), elapsed (copy), u17 (ref), u19 (ref), u18 (ref), PayloadKey (copy), p1 (copy), ActivationFrameworkContextAction (copy)
			authPageload(EventStreamConstants.Context.MultiPageSignupIsAvailableFetch, (tostring(os.clock() - elapsed)))

			if p2.FIDO2 ~= nil then
				u17 = p2.FIDO2.isAvailable and p2.FIDO2.supportsDeviceBoundOnly
				u19 = true
			else
				u17 = not not p2.isAvailable and (p2.supportsDeviceBoundOnly or false)
			end

			if p2.password ~= nil then
				u18 = p2.password.isAvailable
			end

			local t2 = {
				[PayloadKey.CredentialsProtocolPasskeyRegistrationAvailable] = tostring(u17),
				[PayloadKey.CredentialsProtocolPasswordRegistrationAvailable] = tostring(u18),
				[PayloadKey.CredentialsProtocolV2InterfaceAvailable] = tostring(u19)
			}

			p1({
				type = ActivationFrameworkContextAction.SetMergePayload,
				data = {
					payloadTable = t2
				}
			})
		end):catch(function(p3) -- line: 69
			-- upvalues: authClientError (copy), s1 (copy), EventStreamConstants (copy), Logger (copy)
			authClientError(s1, EventStreamConstants.State.CredentialsProtocolNotAvailable)
			Logger:warning("Error checking for credential availability. Error: {}", p3)
		end)
	else
		authPageload(EventStreamConstants.Context.MultiPageSignupIsAvailableFetch, "0")
		u17 = t1[PayloadKey.CredentialsProtocolPasskeyRegistrationAvailable] == "true"
		u18 = t1[PayloadKey.CredentialsProtocolPasswordRegistrationAvailable] == "true"
		u19 = t1[PayloadKey.CredentialsProtocolV2InterfaceAvailable] == "true"
	end

	return u17, u18, u19
end

return getCredentialsProtocolAvailability
