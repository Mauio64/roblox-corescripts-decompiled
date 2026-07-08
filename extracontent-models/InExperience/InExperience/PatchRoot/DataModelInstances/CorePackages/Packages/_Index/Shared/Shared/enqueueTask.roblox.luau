local ParentParent = script.Parent.Parent
local setTimeout = require(ParentParent.LuauPolyfill).setTimeout

return function(p1) -- line: 14
	-- upvalues: setTimeout (copy)
	return setTimeout(p1, 0)
end
