local Logger = require(script.Parent.Parent.Parent.Logger)
local v = Logger.new()
v:setContext({ foo = "foo" })
return v
