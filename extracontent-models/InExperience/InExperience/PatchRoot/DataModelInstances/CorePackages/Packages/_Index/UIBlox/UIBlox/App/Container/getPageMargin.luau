local parent = script.Parent.Parent.Parent.Parent

local t = require(parent.t)

return function(p): number
	assert(t.number(p))

	if p < 360 then
		return 12
	end

	return if p < 600 then 24 else 48
end
