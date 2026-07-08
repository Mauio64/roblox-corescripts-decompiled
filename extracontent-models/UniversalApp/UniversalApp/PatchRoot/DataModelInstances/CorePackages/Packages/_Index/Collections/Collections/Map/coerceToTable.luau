local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Map = require(scriptParent.Map)
local InstanceOf = require(scriptParentParentParent.InstanceOf)
local reduce = require(scriptParentParent.Array.reduce)

require(scriptParentParentParent.ES7Types)

local function coerceToTable(p1) -- line: 27
	-- upvalues: InstanceOf (copy), Map (copy), reduce (copy)
	if not InstanceOf(p1, Map) then
		return p1
	end

	return reduce(p1:entries(), function(p2, p3) -- line: 33
		p2[p3[1]] = p3[2]

		return p2
	end, {})
end

return coerceToTable
