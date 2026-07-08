local ParentParent = script.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local makeIntervalImpl = require(script.makeIntervalImpl)

return Object.assign({
	Object = require(script.Object)
}, makeIntervalImpl(delay))
