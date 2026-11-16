local parent = script.Parent.Parent.Parent.Parent.Parent.Parent

local enumerate = require(parent.enumerate)

return enumerate(script.Name, { "Bottom", "Top", "Right", "Left" })
