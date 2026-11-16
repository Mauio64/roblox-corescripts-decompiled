local parent = script:FindFirstAncestor("GenericChallenges").Parent

local Promise = require(parent.Promise)
local Cryo = require(parent.Cryo)
local IsChallengeHttpResponse = require(script.Parent.IsChallengeHttpResponse)
local InterceptChallenge = require(script.Parent.InterceptChallenge)
require(parent.Http)

return function(callback, p)
	local v = InterceptChallenge

	if p ~= nil then
		v = p
	end

	return function(p2: string, p3: string, p4)
		local v2, v3 = callback(p2, p3, p4)

		return v2:andThen(function(p5)
			return Promise.resolve(p5)
		end):catch(function(p5)
			if p5.StatusCode == nil or p5.Headers == nil or not IsChallengeHttpResponse(p5.StatusCode, p5.Headers) then
				return Promise.reject(p5)
			end

			return v({
				retryRequestCallback = function(headers)
					return callback(p2, p3, Cryo.Dictionary.join(p4, { headers = headers }))
				end,
				rawResponseHeaders = p5.Headers
			})
		end), v3
	end
end
