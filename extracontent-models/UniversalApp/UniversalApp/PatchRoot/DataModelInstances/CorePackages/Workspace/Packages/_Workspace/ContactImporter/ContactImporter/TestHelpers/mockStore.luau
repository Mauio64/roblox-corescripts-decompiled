local ContactImporter = script:FindFirstAncestor("ContactImporter")
local Rodux = require(ContactImporter.dependencies).Rodux

return function(p1, p2) -- line: 8
	-- upvalues: Rodux (copy)
	local v5 = p2 or function(p3) -- line: 9
		return p3
	end

	return Rodux.Store.new(v5, p1 or {}, { Rodux.thunkMiddleware })
end
