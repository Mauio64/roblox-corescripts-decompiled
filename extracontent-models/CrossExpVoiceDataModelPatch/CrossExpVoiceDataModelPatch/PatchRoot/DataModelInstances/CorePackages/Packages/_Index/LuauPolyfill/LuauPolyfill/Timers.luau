local makeTimerImpl = require(script.makeTimerImpl)
local makeIntervalImpl = require(script.makeIntervalImpl)

return require(script.Parent.Object.assign)({}, makeTimerImpl(task.delay), makeIntervalImpl(task.delay))
