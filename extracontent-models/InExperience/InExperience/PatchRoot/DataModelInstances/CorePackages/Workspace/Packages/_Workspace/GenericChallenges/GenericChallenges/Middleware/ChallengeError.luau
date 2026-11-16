local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent
local ErrorKind = require(GenericChallenges.Types.ErrorKind)
local LuauPolyfill = require(parent.LuauPolyfill)

local ChallengeError = {}
ChallengeError.__index = ChallengeError

function ChallengeError.new(kind, p)
	return (setmetatable({ ["kind"] = kind, data = p }, ChallengeError))
end

function ChallengeError.match(p)
	return LuauPolyfill.instanceof(p, ChallengeError)
end

function ChallengeError.matchAbandoned(p)
	return ChallengeError.match(p) and p.kind == ErrorKind.Abandoned
end

return ChallengeError
