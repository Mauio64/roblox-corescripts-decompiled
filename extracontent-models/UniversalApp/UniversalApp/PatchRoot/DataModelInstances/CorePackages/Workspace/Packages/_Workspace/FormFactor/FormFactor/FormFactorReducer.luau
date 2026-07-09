local FormFactor = require(script.Parent.FormFactor)
local SetFormFactor = require(script.Parent.SetFormFactor)

return function(p1, p2) -- line: 6
	-- upvalues: FormFactor (copy), SetFormFactor (copy)
	local v5 = p1 or FormFactor.UNKNOWN

	if p2.type == SetFormFactor.name then
		return p2.formFactor
	end

	return v5
end
