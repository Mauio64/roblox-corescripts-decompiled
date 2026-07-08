local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object

function t1.compact(...) -- line: 13
	-- upvalues: Object (copy)
	return Object.assign({}, ...)
end

return t1
