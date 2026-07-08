local Parent = script:FindFirstAncestor("TimeToInteractiveTracker").Parent
local MemoryTracker = require(Parent.Memory).MemoryTracker

local function getMemoryMb() -- line: 14
	-- upvalues: MemoryTracker (copy)
	local v4 = MemoryTracker()

	if not v4 then
		return {}
	end

	local v5 = v4.getSnapshot()

	return {
		totalMemoryMB = if not v5.totalMemory then nil else tonumber(v5.totalMemory),
		luaHeapMB = tonumber(v5.luaHeapMb)
	}
end

return getMemoryMb
