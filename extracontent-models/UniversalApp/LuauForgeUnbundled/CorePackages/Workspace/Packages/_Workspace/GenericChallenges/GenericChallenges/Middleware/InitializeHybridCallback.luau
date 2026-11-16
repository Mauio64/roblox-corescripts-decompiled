local BuildHybridCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/BuildHybridCallback")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/ChallengeWebView")
local ChallengeError = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/ChallengeError")
local completionDataToRawHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/completionDataToRawHeaders")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LuauPolyfill")
local ErrorKind = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ErrorKind")
local BuildCredentialsProtocolHook = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Hooks/BuildCredentialsProtocolHook")

return function(p2, p3, object, callback, callback2, callback3, callback4)
	return BuildHybridCallback({
		Hooks = { BuildCredentialsProtocolHook() },
		OnChallengeLoadFailed = function(p4)
			if callback2 ~= nil then
				callback2()
			end

			callback4(ChallengeError.new(ErrorKind.LoadFailed, { challengeType = p3 }))

			object:close()
		end,
		OnChallengeInvalidated = function(p4)
			if callback2 ~= nil and p4.data ~= nil then
				callback2(p4.data)
			end

			callback4(ChallengeError.new(ErrorKind.Invalidated, p4.data))
			object:close()
		end,
		OnChallengeDisplayed = function(p4)
			object:setVisible(true)
		end,
		OnChallengeCompleted = function(p4)
			if p4.data ~= nil and p4.data.challengeType ~= nil and p4.data.metadata ~= nil then
				callback3(callback(completionDataToRawHeaders({
					challengeId = p2,
					challengeType = p4.data.challengeType,
					metadata = p4.data.metadata
				})))
			end

			object:close()
		end
	})
end
