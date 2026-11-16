local parent = script.Parent.Parent.Parent.Parent.Parent

local t = require(parent.t)

return t.interface({ getValue = t.callback, map = t.callback })
