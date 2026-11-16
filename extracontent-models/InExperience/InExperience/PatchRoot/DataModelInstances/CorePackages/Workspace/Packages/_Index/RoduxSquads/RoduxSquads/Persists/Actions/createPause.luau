local parent = script:FindFirstAncestor("RoduxSquads").Parent
local Rodux = require(parent.Rodux)

return function(p)
	local storage = p.storage
	assert(storage ~= nil, "Persist storage is required")

	local memStorageKey = storage.memStorageKey or ""
	return Rodux.makeActionCreator(memStorageKey .. "Pause", function()
		return {}
	end)
end
