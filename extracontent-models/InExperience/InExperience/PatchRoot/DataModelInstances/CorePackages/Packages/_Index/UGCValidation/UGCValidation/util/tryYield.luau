local parent = script.Parent.Parent

require(parent.util.Types)
local getFIntUGCValidationMaxMsPerFrame = require(parent.flags.getFIntUGCValidationMaxMsPerFrame)

local v = getFIntUGCValidationMaxMsPerFrame() / 1000

return function(state)
	if state.shouldYield and v <= tick() - state.lastTickSeconds then
		task.wait()
		state.lastTickSeconds = tick()
	end
end
