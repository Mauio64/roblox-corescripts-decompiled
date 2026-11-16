local Logger = require(script.Parent.Parent.Parent.Logger)
local v = Logger.new()
v:setContext({ root = "root" })
return v
