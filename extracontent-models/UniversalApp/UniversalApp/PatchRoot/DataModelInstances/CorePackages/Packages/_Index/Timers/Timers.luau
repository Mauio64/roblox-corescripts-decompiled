local parent = script.Parent

local Collections = require(parent.Collections)
local Object = Collections.Object

local makeTimerImpl = require(script.makeTimerImpl)
local makeIntervalImpl = require(script.makeIntervalImpl)

return Object.assign({}, makeTimerImpl(task.delay), makeIntervalImpl(task.delay))
