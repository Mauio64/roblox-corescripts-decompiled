local module = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Common/MemoryTracker")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Common/MemoryScope")
local MemoryShell = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Profiling/MemoryShell")
local FFlagEnableMemoryShell = require("@game/CorePackages/Workspace/Packages/_Workspace/Memory/Memory/Flags/FFlagEnableMemoryShell")

return {
	MemoryTracker = module,
	MemoryScope = module2,
	start = function(p2, value, p3)
		local v5 = p2 and module(value, p3)

		if v5 then
			v5:start()
		end

		if FFlagEnableMemoryShell then
			MemoryShell.start(value or "app")
		end
	end
}
