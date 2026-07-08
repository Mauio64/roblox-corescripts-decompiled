local Parent = script:FindFirstAncestor("RoactUtils").Parent
local Signal = require(Parent.AppCommonLib).Signal

require(script.Parent.types)

local function createReactProfilerContext() -- line: 8
	-- upvalues: Signal (copy)
	return {
		onRender = Signal.new(),
		onCommit = Signal.new()
	}
end

return createReactProfilerContext
