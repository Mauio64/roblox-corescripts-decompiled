local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local BuildHybridCallback = require(script.Parent.BuildHybridCallback)
require(script.Parent.ChallengeWebView)
local ChallengeError = require(script.Parent.ChallengeError)
local completionDataToRawHeaders = require(GenericChallenges.Utils.completionDataToRawHeaders)

local parent = GenericChallenges.Parent
require(parent.LuauPolyfill)
local ErrorKind = require(GenericChallenges.Types.ErrorKind)
local BuildCredentialsProtocolHook = require(script.Parent.Hooks.BuildCredentialsProtocolHook)

return function(challengeId: string, challengeType: string, object, callback, callback2, callback3, callback4)
	return BuildHybridCallback({
		Hooks = { BuildCredentialsProtocolHook() },
		OnChallengeLoadFailed = function(_)
			if callback2 ~= nil then
				callback2()
			end

			callback4(ChallengeError.new(ErrorKind.LoadFailed, { challengeType = challengeType }))

			object:close()
		end,
		OnChallengeInvalidated = function(p)
			if callback2 ~= nil and p.data ~= nil then
				callback2(p.data)
			end

			callback4(ChallengeError.new(ErrorKind.Invalidated, p.data))
			object:close()
		end,
		OnChallengeDisplayed = function(_)
			object:setVisible(true)
		end,
		OnChallengeCompleted = function(p)
			if p.data ~= nil and p.data.challengeType ~= nil and p.data.metadata ~= nil then
				callback3(callback(completionDataToRawHeaders({
					challengeId = challengeId,
					challengeType = p.data.challengeType,
					metadata = p.data.metadata
				})))
			end

			object:close()
		end
	})
end
