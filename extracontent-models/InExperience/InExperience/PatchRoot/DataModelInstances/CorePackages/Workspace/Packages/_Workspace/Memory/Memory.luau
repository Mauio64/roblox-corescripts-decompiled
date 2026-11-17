local MemoryTracker = require(script.Common.MemoryTracker)
local MemoryScope = require(script.Common.MemoryScope)
local MemoryShell = require(script.Profiling.MemoryShell)
local FFlagEnableMemoryShell = require(script.Flags.FFlagEnableMemoryShell)

return {
	["jest.config"] = script["jest.config"],
	MemoryTracker = MemoryTracker,
	MemoryScope = MemoryScope,
	start = function(flag: boolean?, value: string?, p)
		local v = flag and MemoryTracker(value, p)

		if v then
			v:start()
		end

		if FFlagEnableMemoryShell then
			MemoryShell.start(value or "app")
		end
	end
}
