local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Map = require(parent.Map)
local InstanceOf = require(parent3.InstanceOf)
local reduce = require(parent2.Array.reduce)
require(parent3.ES7Types)

local function coerceToTable(object)
	if InstanceOf(object, Map) then
		return reduce(object:entries(), function(p, list)
			p[list[1]] = list[2]
			return p
		end, {})
	end

	return object
end

return coerceToTable
