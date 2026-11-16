local prettyPrint = require(script.Parent.prettyPrint)
local LoggerMiddleware = { outputFunction = print }

function LoggerMiddleware.middleware(callback, object)
	return function(p)
		local v = callback(p)

		LoggerMiddleware.outputFunction(("Action dispatched: %s\nState changed to: %s"):format(
			prettyPrint(p),
			prettyPrint(object:getState())
		))

		return v
	end
end

return LoggerMiddleware
