local ParentParent = script.Parent.Parent
local inspect = require(ParentParent.jsutils.inspect).inspect
local devAssert = require(ParentParent.jsutils.devAssert).devAssert
local instanceOf = require(ParentParent.jsutils.instanceOf)
local t1 = {}

t1.__index = t1

function t1.new(s1: string, s2: string?, t2: {[any]: any}?) -- line: 39
	-- upvalues: devAssert (copy), inspect (copy), t1 (copy)
	local v9 = s2 or "GraphQL request"
	local v10 = t2 or {
		line = 1,
		column = 1
	}

	devAssert(typeof(s1) == "string", "Body must be a string. Received: " .. inspect(s1) .. ".")

	local t3 = {
		body = s1,
		name = v9,
		locationOffset = v10
	}

	devAssert(t3.locationOffset.line > 0, "line in locationOffset is 1-indexed and must be positive.")
	devAssert(t3.locationOffset.column > 0, "column in locationOffset is 1-indexed and must be positive.")

	return (setmetatable(t3, t1))
end
function t1.__tostring(_) -- line: 61
	return "{table Source}"
end
function isSource(p2) -- line: 71
	-- upvalues: instanceOf (copy), t1 (copy)
	return instanceOf(p2, t1)
end

return {
	Source = t1,
	isSource = isSource
}
