local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Promise")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Cryo")
local IsChallengeHttpResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/IsChallengeHttpResponse")
local InterceptChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/InterceptChallenge")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Http")

return function(callback, p2)
	local v5 = InterceptChallenge

	if p2 ~= nil then
		v5 = p2
	end

	return function(p3, p4, p5)
		local v6, v7 = callback(p3, p4, p5)

		return v6:andThen(function(p6)
			return Promise.resolve(p6)
		end):catch(function(p6)
			if p6.StatusCode == nil or p6.Headers == nil or not IsChallengeHttpResponse(p6.StatusCode, p6.Headers) then
				return Promise.reject(p6)
			end

			return v5({
				retryRequestCallback = function(p7)
					return callback(p3, p4, Cryo.Dictionary.join(p5, { headers = p7 }))
				end,
				rawResponseHeaders = p6.Headers
			})
		end), v7
	end
end
