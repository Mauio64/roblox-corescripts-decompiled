local parent = script.Parent.Parent
local parentModule = require(script.Parent)
local instanceof = require(parent.instanceof)
local reduce = require(parent.Array.reduce)
require(parent.types)

local function coerceToTable(object)
	if instanceof(object, parentModule) then
		return reduce(object:entries(), function(p, list)
			p[list[1]] = list[2]
			return p
		end, {})
	end

	return object
end

return coerceToTable
