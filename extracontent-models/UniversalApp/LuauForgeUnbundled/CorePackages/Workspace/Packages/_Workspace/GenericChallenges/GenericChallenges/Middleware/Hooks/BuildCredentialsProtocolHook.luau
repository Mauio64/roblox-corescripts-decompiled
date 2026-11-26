local HttpService = game:GetService("HttpService")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/CredentialsProtocol").CredentialsProtocol.default
local JavascriptHybrid = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/JavascriptHybrid")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/BuildHybridCallback")

local getFFlagLuaAppEnableCredentialsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/CredentialsProtocol").Flags.GetFFlagLuaAppEnableCredentialsProtocol

local getFIntLuaAppCredentialsProtocolAvailableTimeout = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/CredentialsProtocol").Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout

local getFIntLuaAppCredentialsProtocolTimeout = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/CredentialsProtocol").Flags.GetFIntLuaAppCredentialsProtocolTimeout

local defineFastFlag = game:DefineFastFlag("EnableGetCredentialsInCredentialsProtocolHook", false)
local ExecuteJavaScriptInWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/ExecuteJavaScriptInWebView")

return function(data)
	local v5 = default
	local v6 = ExecuteJavaScriptInWebView
	local v7 = getFFlagLuaAppEnableCredentialsProtocol()

	if data ~= nil and data.defaultExecuteJavaScriptInWebView ~= nil then
		v6 = data.defaultExecuteJavaScriptInWebView
	end

	if data ~= nil and data.defaultCredentialsProtocol ~= nil then
		v5 = data.defaultCredentialsProtocol
	end

	if data ~= nil and data.defaultCredentialsProtocolEnabled ~= nil then
		v7 = data.defaultCredentialsProtocolEnabled
	end

	return function(p2): boolean
		if not v7 then
			return false
		end

		if p2.feature == JavascriptHybrid.Feature.CredentialsProtocolAvailable then
			v5:isAvailable(
				default.CredentialsTypes.FIDO2,
				getFIntLuaAppCredentialsProtocolAvailableTimeout()
			):andThen(function(p3)
				local isAvailable = p3.isAvailable or false
				v6.Execute(p2.data.callId, (tostring(isAvailable)))
			end):catch(function()
				v6.Execute(p2.data.callId, "false")
			end)
		elseif defineFastFlag and p2.feature == JavascriptHybrid.Feature.GetCredentials then
			v5:getCredentials(
				default.CredentialsTypes.FIDO2,
				p2.data.authenticationOptionsJSON,
				getFIntLuaAppCredentialsProtocolTimeout()
			):andThen(function(p3)
				v6.Execute(p2.data.callId, not p3 and "" or HttpService:JSONEncode(p3))
			end):catch(function()
				v6.Execute(p2.data.callId, "")
			end)
		end

		return false
	end
end
