local parent = script:FindFirstAncestor("RoactUtils").Parent
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

require(script.Parent.types)

local function createReactProfilerContext()
	return { onRender = Signal.new(), onCommit = Signal.new() }
end

return createReactProfilerContext
