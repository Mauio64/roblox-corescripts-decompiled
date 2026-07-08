local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local v2 = require(ParentParent.flags.getFIntUGCValidationMaxMsPerFrame)() / 1000

return function(p1) -- line: 8
	-- upvalues: v2 (copy)
	if p1.shouldYield and tick() - p1.lastTickSeconds >= v2 then
		task.wait()
		p1.lastTickSeconds = tick()
	end
end
