local FormFactor = require(script.Parent.FormFactor)
local SetFormFactor = require(script.Parent.SetFormFactor)

return function(p, p2)
	local v = p or FormFactor.UNKNOWN

	return if p2.type == SetFormFactor.name then p2.formFactor else v
end
