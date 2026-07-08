local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local HttpService = game:GetService("HttpService")
local GenericChallengesParent = GenericChallenges.Parent
local default = require(GenericChallengesParent.CredentialsProtocol).CredentialsProtocol.default
local JavascriptHybrid = require(GenericChallenges.Types.JavascriptHybrid)

require(GenericChallenges.Middleware.BuildHybridCallback)

local GetFFlagLuaAppEnableCredentialsProtocol = require(GenericChallengesParent.CredentialsProtocol).Flags.GetFFlagLuaAppEnableCredentialsProtocol
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = require(GenericChallengesParent.CredentialsProtocol).Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local GetFIntLuaAppCredentialsProtocolTimeout = require(GenericChallengesParent.CredentialsProtocol).Flags.GetFIntLuaAppCredentialsProtocolTimeout
local v9 = game:DefineFastFlag("EnableGetCredentialsInCredentialsProtocolHook", false)
local ExecuteJavaScriptInWebView = require(GenericChallenges.Utils.ExecuteJavaScriptInWebView)

return function(t1: {[any]: any}?) -- line: 19
	-- upvalues: default (copy), ExecuteJavaScriptInWebView (copy), GetFFlagLuaAppEnableCredentialsProtocol (copy), JavascriptHybrid (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), v9 (copy), GetFIntLuaAppCredentialsProtocolTimeout (copy), HttpService (copy)
	local u12 = default
	local u13 = ExecuteJavaScriptInWebView
	local u14 = GetFFlagLuaAppEnableCredentialsProtocol()

	if t1 ~= nil and t1.defaultExecuteJavaScriptInWebView ~= nil then
		u13 = t1.defaultExecuteJavaScriptInWebView
	end

	if t1 ~= nil and t1.defaultCredentialsProtocol ~= nil then
		u12 = t1.defaultCredentialsProtocol
	end

	if t1 ~= nil and t1.defaultCredentialsProtocolEnabled ~= nil then
		u14 = t1.defaultCredentialsProtocolEnabled
	end

	return function(p1) -- line: 36
		-- upvalues: u14 (ref), JavascriptHybrid (copy), u12 (ref), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), u13 (ref), v9 (copy), GetFIntLuaAppCredentialsProtocolTimeout (copy), HttpService (copy)
		if u14 then
			if p1.feature == JavascriptHybrid.Feature.CredentialsProtocolAvailable then
				u12:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p2) -- line: 44
					-- upvalues: u13 (ref), p1 (copy)
					local v17 = p2.isAvailable or false

					u13.Execute(p1.data.callId, (tostring(v17)))
				end):catch(function() -- line: 48
					-- upvalues: u13 (ref), p1 (copy)
					u13.Execute(p1.data.callId, "false")
				end)
			elseif v9 and p1.feature == JavascriptHybrid.Feature.GetCredentials then
				u12:getCredentials(default.CredentialsTypes.FIDO2, p1.data.authenticationOptionsJSON, GetFIntLuaAppCredentialsProtocolTimeout()):andThen(function(p3) -- line: 61
					-- upvalues: u13 (ref), p1 (copy), HttpService (copy)
					u13.Execute(p1.data.callId, not p3 and "" or HttpService:JSONEncode(p3))
				end):catch(function() -- line: 67
					-- upvalues: u13 (ref), p1 (copy)
					u13.Execute(p1.data.callId, "")
				end)
			end
		end

		return false
	end
end
