local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local GenericChallengesParent = GenericChallenges.Parent
local ErrorKind = require(GenericChallenges.Types.ErrorKind)
local LuauPolyfill = require(GenericChallengesParent.LuauPolyfill)
local t1 = {}

t1.__index = t1

function t1.new(p1, t2: {[any]: any}?) -- line: 25
	-- upvalues: t1 (copy)
	return (setmetatable({
		kind = p1,
		data = t2
	}, t1))
end
function t1.match(p2) -- line: 32
	-- upvalues: LuauPolyfill (copy), t1 (copy)
	return LuauPolyfill.instanceof(p2, t1)
end
function t1.matchAbandoned(p3) -- line: 36
	-- upvalues: t1 (copy), ErrorKind (copy)
	return t1.match(p3) and p3.kind == ErrorKind.Abandoned
end

return t1
