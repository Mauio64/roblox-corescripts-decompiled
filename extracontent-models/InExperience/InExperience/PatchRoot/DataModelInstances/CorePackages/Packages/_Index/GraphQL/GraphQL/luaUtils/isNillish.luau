local null = require(script.Parent.null)
local IsNillish = {}

function IsNillish.isNillish(p): boolean
	return p == nil or p == null
end

function IsNillish.isNotNillish(p): boolean
	return p ~= nil and p ~= null
end

return IsNillish
