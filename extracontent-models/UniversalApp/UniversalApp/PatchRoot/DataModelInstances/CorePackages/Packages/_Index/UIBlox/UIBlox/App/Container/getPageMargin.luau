local ParentParent = script.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)

return function(p1) -- line: 8
	-- upvalues: t (copy)
	assert(t.number(p1))

	if p1 < 360 then
		return 12
	end

	if p1 < 600 then
		return 24
	end

	return 48
end
