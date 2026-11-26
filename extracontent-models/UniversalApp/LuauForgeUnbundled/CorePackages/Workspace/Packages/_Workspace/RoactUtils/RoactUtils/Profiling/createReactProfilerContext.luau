local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/AppCommonLib").Signal

require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Profiling/types")

local function createReactProfilerContext()
	return { onRender = signal.new(), onCommit = signal.new() }
end

return createReactProfilerContext
