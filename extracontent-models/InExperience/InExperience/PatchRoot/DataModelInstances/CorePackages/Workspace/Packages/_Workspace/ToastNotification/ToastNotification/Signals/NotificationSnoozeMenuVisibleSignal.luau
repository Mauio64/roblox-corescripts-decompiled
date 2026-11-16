local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.Signal.new()
