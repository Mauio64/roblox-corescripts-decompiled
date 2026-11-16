local MemoryTracker = require(script.Common.MemoryTracker)
local MemoryScope = require(script.Common.MemoryScope)
local MemoryShell = require(script.Profiling.MemoryShell)
local FFlagEnableMemoryShell = require(script.Flags.FFlagEnableMemoryShell)

return {
	["jest.config"] = script["jest.config"],
	MemoryTracker = MemoryTracker,
	MemoryScope = MemoryScope,
	start = function(self: boolean?, p: string?, p2)
		local v = self and MemoryTracker(p, p2)

		if v then
			v:start()
		end

		if FFlagEnableMemoryShell then
			MemoryShell:start()
		end
	end
}
