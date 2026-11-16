local parent = script:FindFirstAncestor("TimeToInteractiveTracker").Parent

local Memory = require(parent.Memory)
local MemoryTracker = Memory.MemoryTracker

local function getMemoryMb()
	local memoryTracker = MemoryTracker()

	if not memoryTracker then
		return {}
	end

	local snapshot = memoryTracker.getSnapshot()
	local totalMemoryMB

	if snapshot.totalMemory then
		totalMemoryMB = tonumber(snapshot.totalMemory)
	end

	return { totalMemoryMB = totalMemoryMB, luaHeapMB = tonumber(snapshot.luaHeapMb) }
end

return getMemoryMb
