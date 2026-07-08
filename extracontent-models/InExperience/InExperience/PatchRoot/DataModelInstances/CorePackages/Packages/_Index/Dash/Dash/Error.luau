local scriptParent = script.Parent

require(scriptParent.Types)

local class = require(scriptParent.class)
local format = require(scriptParent.format)
local join = require(scriptParent.join)
local v5 = class("Error", function(s1: string, s2: string, p1) -- line: 18
	return {
		name = s1,
		message = s2 or "An error occurred",
		tags = p1 or {}
	}
end)

function v5.toString(p2) -- line: 26
	-- upvalues: format (copy)
	return format("{}: {}\n{}", p2.name, format(p2.message, p2.tags), p2.stack)
end
function v5.joinTags(p3, p4) -- line: 36
	-- upvalues: v5 (copy), join (copy)
	return v5.new(p3.name, p3.message, join(p3.tags, p4 or {}))
end
function v5.throw(p5, p6) -- line: 49
	local v14 = p5:joinTags(p6)

	v14.stack = debug.traceback()
	error(v14)
end

return v5
