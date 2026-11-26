local ErrorKind = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ErrorKind")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LuauPolyfill")

local class = {}
class.__index = class

function class.new(p2, p3)
	return (setmetatable({ ["kind"] = p2, data = p3 }, class))
end

function class.match(p2)
	return LuauPolyfill.instanceof(p2, class)
end

function class.matchAbandoned(p2)
	return class.match(p2) and p2.kind == ErrorKind.Abandoned
end

return class
