local parent = script.Parent.Parent.Parent.Parent.Parent
local enumerate = require(parent.enumerate)

return enumerate(script.Name, { "State1", "State2", "State3", "State4" })
