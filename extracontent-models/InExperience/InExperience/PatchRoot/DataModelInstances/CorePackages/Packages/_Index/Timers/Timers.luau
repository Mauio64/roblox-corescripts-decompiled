local scriptParent = script.Parent
local Object = require(scriptParent.Collections).Object
local makeTimerImpl = require(script.makeTimerImpl)
local makeIntervalImpl = require(script.makeIntervalImpl)

return Object.assign({}, makeTimerImpl(task.delay), makeIntervalImpl(task.delay))
