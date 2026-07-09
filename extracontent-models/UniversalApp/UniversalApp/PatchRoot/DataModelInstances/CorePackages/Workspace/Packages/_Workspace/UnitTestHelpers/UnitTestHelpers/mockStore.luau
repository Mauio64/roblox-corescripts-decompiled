local ParentParent = script.Parent.Parent
local Rodux = require(ParentParent.Rodux)

return function(p1, p2: ((...any) -> ...any)?) -- line: 5
	-- upvalues: Rodux (copy)
	local v5 = p2 or function(p3) -- line: 6
		return p3
	end

	return Rodux.Store.new(v5, p1 or {}, { Rodux.thunkMiddleware })
end
