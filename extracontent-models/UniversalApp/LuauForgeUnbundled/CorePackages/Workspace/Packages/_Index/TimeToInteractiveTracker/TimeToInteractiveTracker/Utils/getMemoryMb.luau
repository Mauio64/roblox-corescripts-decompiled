local memoryTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/Memory").MemoryTracker

local function getMemoryMb()
	local v5 = memoryTracker()

	if not v5 then
		return {}
	end

	local snapshot = v5.getSnapshot()

	local v7 = if snapshot.totalMemory then tonumber(snapshot.totalMemory) else nil
	return { totalMemoryMB = v7, luaHeapMB = tonumber(snapshot.luaHeapMb) }
end

return getMemoryMb
