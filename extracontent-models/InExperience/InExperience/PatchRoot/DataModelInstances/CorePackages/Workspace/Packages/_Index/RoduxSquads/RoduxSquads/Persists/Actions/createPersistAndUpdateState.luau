local Parent = script:FindFirstAncestor("RoduxSquads").Parent
local Rodux = require(Parent.Rodux)

return function(p1) -- line: 5
	-- upvalues: Rodux (copy)
	local storage = p1.storage

	assert(storage ~= nil, "Persist storage is required")

	local v5 = storage.memStorageKey or ""

	return Rodux.makeActionCreator(v5 .. "PersistAndUpdateState", function() -- line: 10
		return {}
	end)
end
