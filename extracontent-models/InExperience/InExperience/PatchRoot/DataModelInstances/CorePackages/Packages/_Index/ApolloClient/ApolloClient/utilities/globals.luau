local t1 = {
	DEV = require(script.DEV).default
}
local removeTemporaryGlobals = require(script.graphql).removeTemporaryGlobals

t1.removeTemporaryGlobals = removeTemporaryGlobals
t1.NULL = require(script.null).NULL
removeTemporaryGlobals()

return t1
