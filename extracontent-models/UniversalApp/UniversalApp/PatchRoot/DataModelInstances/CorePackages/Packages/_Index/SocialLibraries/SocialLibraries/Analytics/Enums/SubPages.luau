local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, { PeekView = "peekView" })
