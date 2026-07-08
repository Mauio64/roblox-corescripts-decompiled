local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)

return t.interface({
	getValue = t.callback,
	map = t.callback
})
