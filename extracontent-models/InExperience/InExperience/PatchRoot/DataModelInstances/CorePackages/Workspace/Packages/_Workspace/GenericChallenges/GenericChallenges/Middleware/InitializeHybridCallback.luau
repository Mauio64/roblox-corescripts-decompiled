local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local BuildHybridCallback = require(script.Parent.BuildHybridCallback)

require(script.Parent.ChallengeWebView)

local ChallengeError = require(script.Parent.ChallengeError)
local completionDataToRawHeaders = require(GenericChallenges.Utils.completionDataToRawHeaders)
local GenericChallengesParent = GenericChallenges.Parent

require(GenericChallengesParent.LuauPolyfill)

local ErrorKind = require(GenericChallenges.Types.ErrorKind)
local BuildCredentialsProtocolHook = require(script.Parent.Hooks.BuildCredentialsProtocolHook)

return function(s1: string, s2: string, p1, p2: ((...any) -> ...any), p3, p4: ((...any) -> ...any), p5: ((...any) -> ...any)) -- line: 25
	-- upvalues: BuildHybridCallback (copy), BuildCredentialsProtocolHook (copy), ChallengeError (copy), ErrorKind (copy), completionDataToRawHeaders (copy)
	return BuildHybridCallback({
		Hooks = { BuildCredentialsProtocolHook() },
		OnChallengeLoadFailed = function(_: {[any]: any}) -- line: 37
			-- upvalues: p3 (copy), p5 (copy), ChallengeError (copy), ErrorKind (copy), s2 (copy), p1 (copy)
			if p3 ~= nil then
				p3()
			end

			p5(ChallengeError.new(ErrorKind.LoadFailed, {
				challengeType = s2
			}))
			p1:close()
		end,
		OnChallengeInvalidated = function(t2: {[any]: any}) -- line: 46
			-- upvalues: p3 (copy), p5 (copy), ChallengeError (copy), ErrorKind (copy), p1 (copy)
			if p3 ~= nil and t2.data ~= nil then
				p3(t2.data)
			end

			p5(ChallengeError.new(ErrorKind.Invalidated, t2.data))
			p1:close()
		end,
		OnChallengeCompleted = function(t3: {[any]: any}) -- line: 53
			-- upvalues: p4 (copy), p2 (copy), completionDataToRawHeaders (copy), s1 (copy), p1 (copy)
			if t3.data ~= nil and (t3.data.challengeType ~= nil and t3.data.metadata ~= nil) then
				p4(p2(completionDataToRawHeaders({
					challengeId = s1,
					challengeType = t3.data.challengeType,
					metadata = t3.data.metadata
				})))
			end

			p1:close()
		end
	})
end
