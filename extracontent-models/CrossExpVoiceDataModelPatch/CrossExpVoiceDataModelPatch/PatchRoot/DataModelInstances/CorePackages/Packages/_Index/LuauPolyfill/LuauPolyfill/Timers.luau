local makeTimerImpl = require(script.makeTimerImpl)
local makeIntervalImpl = require(script.makeIntervalImpl)
local assign = require(script.Parent.Object.assign)

return assign({}, makeTimerImpl(task.delay), makeIntervalImpl(task.delay))
