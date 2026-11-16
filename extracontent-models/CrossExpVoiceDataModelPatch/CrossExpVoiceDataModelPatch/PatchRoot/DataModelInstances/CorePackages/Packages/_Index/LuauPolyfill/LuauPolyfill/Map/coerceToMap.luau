local parent = script.Parent.Parent
local parentModule = require(script.Parent)
local Object = require(parent.Object)
local instanceof = require(parent.instanceof)
require(parent.types)

local function coerceToMap(p)
	return instanceof(p, parentModule) and p or parentModule.new(Object.entries(p))
end

return coerceToMap
