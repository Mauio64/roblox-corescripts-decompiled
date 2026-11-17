local parent = script:FindFirstAncestor("Memory").Parent

local DevShell = require(parent.DevShell)

local MemoryTracker = require(script.Parent.Parent.Common.MemoryTracker)
local GarbageCollector = require(script.Parent.Parent.Common.GarbageCollector)

local function getMemoryTracker() -- 2 equivalent calls inferred from this helper
	return MemoryTracker()
end

local methods = {
	getLuaHeap = function()
		GarbageCollector.collect()
		local memoryTracker = getMemoryTracker() -- inferred equivalent call

		if memoryTracker then
			return memoryTracker.getLuaHeapOnly()
		end

		return { luaHeapMb = "-1" }
	end,
	getSnapshot = function()
		GarbageCollector.collect()
		local memoryTracker = getMemoryTracker() -- inferred equivalent call

		if memoryTracker then
			return memoryTracker.getSnapshot()
		end

		return { luaHeapMb = "-1" }
	end,
	forceGC = function(): string
		GarbageCollector.collect()
		return "ok"
	end
}

return {
	methods = methods,
	start = function(context: string)
		DevShell.registerMethods("memory", methods)
		DevShell.start({ context = context })
	end
}
