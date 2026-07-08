local Parent = script:FindFirstAncestor("ContactsToast").Parent
local Rodux = require(Parent.Rodux)

return function(p1, p2) -- line: 5
	-- upvalues: Rodux (copy)
	local v5 = p2 or function(p3) -- line: 6
		return p3
	end

	return Rodux.Store.new(v5, p1 or {}, { Rodux.thunkMiddleware })
end
