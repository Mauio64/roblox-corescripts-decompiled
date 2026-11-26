local DevShell = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/DevShell")

local MemoryTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Common/MemoryTracker")
local GarbageCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Common/GarbageCollector")

local function getMemoryTracker()
	return MemoryTracker()
end

local v5 = {
	getLuaHeap = function()
		GarbageCollector.collect()
		local v6 = MemoryTracker()

		if v6 then
			return v6.getLuaHeapOnly()
		end

		return { luaHeapMb = "-1" }
	end,
	getSnapshot = function()
		GarbageCollector.collect()
		local v6 = MemoryTracker()

		if v6 then
			return v6.getSnapshot()
		end

		return { luaHeapMb = "-1" }
	end,
	forceGC = function(): string
		GarbageCollector.collect()
		return "ok"
	end
}

return {
	methods = v5,
	start = function(p2)
		DevShell.registerMethods("memory", v5)
		DevShell.start({ context = p2 })
	end
}
