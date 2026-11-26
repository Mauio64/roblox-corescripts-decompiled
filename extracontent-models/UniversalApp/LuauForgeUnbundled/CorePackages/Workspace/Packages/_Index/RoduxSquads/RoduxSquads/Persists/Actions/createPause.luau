local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Rodux")

return function(p2)
	local storage = p2.storage
	assert(storage ~= nil, "Persist storage is required")

	local memStorageKey = storage.memStorageKey or ""
	return Rodux.makeActionCreator(memStorageKey .. "Pause", function()
		return {}
	end)
end
