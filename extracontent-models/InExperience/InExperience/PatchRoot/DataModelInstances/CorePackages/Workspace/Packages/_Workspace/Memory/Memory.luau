local MemoryTracker = require(script.Common.MemoryTracker)
local MemoryScope = require(script.Common.MemoryScope)
local MemoryShell = require(script.Profiling.MemoryShell)
local FFlagEnableMemoryShell = require(script.Flags.FFlagEnableMemoryShell)

return {
	["jest.config"] = script["jest.config"],
	MemoryTracker = MemoryTracker,
	MemoryScope = MemoryScope,
	start = function(b1: boolean?, s1: string?, p1) -- line: 6
		-- upvalues: MemoryTracker (copy), FFlagEnableMemoryShell (copy), MemoryShell (copy)
		if b1 then
			local v8 = MemoryTracker(s1, p1)

			if v8 then
				v8:start()
			end
		end

		if FFlagEnableMemoryShell then
			MemoryShell:start()
		end
	end
}
