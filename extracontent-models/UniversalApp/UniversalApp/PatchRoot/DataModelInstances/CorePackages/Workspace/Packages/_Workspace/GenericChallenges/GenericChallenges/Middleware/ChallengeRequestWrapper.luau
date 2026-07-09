local Parent = script:FindFirstAncestor("GenericChallenges").Parent
local Promise = require(Parent.Promise)
local Cryo = require(Parent.Cryo)
local IsChallengeHttpResponse = require(script.Parent.IsChallengeHttpResponse)
local InterceptChallenge = require(script.Parent.InterceptChallenge)

require(Parent.Http)

return function(p1, p2) -- line: 13
	-- upvalues: InterceptChallenge (copy), Promise (copy), IsChallengeHttpResponse (copy), Cryo (copy)
	local u8 = InterceptChallenge

	if p2 ~= nil then
		u8 = p2
	end

	return function(s1: string, s2: string, p3) -- line: 18
		-- upvalues: p1 (copy), Promise (copy), IsChallengeHttpResponse (copy), Cryo (copy), u8 (ref)
		local v12, v13 = p1(s1, s2, p3)

		return v12:andThen(function(p4) -- line: 21
			-- upvalues: Promise (copy)
			return Promise.resolve(p4)
		end):catch(function(p5) -- line: 25
			-- upvalues: IsChallengeHttpResponse (copy), p1 (copy), s1 (copy), s2 (copy), Cryo (copy), p3 (copy), u8 (ref), Promise (copy)
			if p5.StatusCode ~= nil and (p5.Headers ~= nil and IsChallengeHttpResponse(p5.StatusCode, p5.Headers)) then
				local t1 = {
					retryRequestCallback = function(p6) -- line: 33
						-- upvalues: p1 (copy), s1 (copy), s2 (copy), Cryo (copy), p3 (copy)
						return p1(s1, s2, Cryo.Dictionary.join(p3, {
							headers = p6
						}))
					end,
					rawResponseHeaders = p5.Headers
				}

				return u8(t1)
			end

			return Promise.reject(p5)
		end), v13
	end
end
