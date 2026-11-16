local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local HttpService = game:GetService("HttpService")

local parent = GenericChallenges.Parent
local CredentialsProtocol = require(parent.CredentialsProtocol)
local default = CredentialsProtocol.CredentialsProtocol.default
local JavascriptHybrid = require(GenericChallenges.Types.JavascriptHybrid)
require(GenericChallenges.Middleware.BuildHybridCallback)

local CredentialsProtocol2 = require(parent.CredentialsProtocol)
local GetFFlagLuaAppEnableCredentialsProtocol = CredentialsProtocol2.Flags.GetFFlagLuaAppEnableCredentialsProtocol

local CredentialsProtocol3 = require(parent.CredentialsProtocol)
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol3.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local CredentialsProtocol4 = require(parent.CredentialsProtocol)
local GetFIntLuaAppCredentialsProtocolTimeout = CredentialsProtocol4.Flags.GetFIntLuaAppCredentialsProtocolTimeout

local defineFastFlag = game:DefineFastFlag("EnableGetCredentialsInCredentialsProtocolHook", false)
local ExecuteJavaScriptInWebView = require(GenericChallenges.Utils.ExecuteJavaScriptInWebView)

return function(data)
	local v = default
	local v2 = ExecuteJavaScriptInWebView
	local fFlagLuaAppEnableCredentialsProtocol = GetFFlagLuaAppEnableCredentialsProtocol()

	if data ~= nil and data.defaultExecuteJavaScriptInWebView ~= nil then
		v2 = data.defaultExecuteJavaScriptInWebView
	end

	if data ~= nil and data.defaultCredentialsProtocol ~= nil then
		v = data.defaultCredentialsProtocol
	end

	if data ~= nil and data.defaultCredentialsProtocolEnabled ~= nil then
		fFlagLuaAppEnableCredentialsProtocol = data.defaultCredentialsProtocolEnabled
	end

	return function(p): boolean
		if not fFlagLuaAppEnableCredentialsProtocol then
			return false
		end

		if p.feature == JavascriptHybrid.Feature.CredentialsProtocolAvailable then
			v:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p2)
				local isAvailable = p2.isAvailable or false
				v2.Execute(p.data.callId, (tostring(isAvailable)))
			end):catch(function()
				v2.Execute(p.data.callId, "false")
			end)
		elseif defineFastFlag and p.feature == JavascriptHybrid.Feature.GetCredentials then
			v:getCredentials(
				default.CredentialsTypes.FIDO2,
				p.data.authenticationOptionsJSON,
				GetFIntLuaAppCredentialsProtocolTimeout()
			):andThen(function(p2)
				v2.Execute(p.data.callId, not p2 and "" or HttpService:JSONEncode(p2))
			end):catch(function()
				v2.Execute(p.data.callId, "")
			end)
		end

		return false
	end
end
