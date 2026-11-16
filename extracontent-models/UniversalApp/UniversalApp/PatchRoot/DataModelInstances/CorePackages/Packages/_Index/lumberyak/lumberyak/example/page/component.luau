local pageLogger = require(script.Parent.pageLogger)
local v = pageLogger:new()
v:setContext({ bar = "bar" })

return function(): string
	v:info("calling {root} {foo} {bar}")
	return "done"
end
