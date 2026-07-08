local pageLogger = require(script.Parent.pageLogger)
local component = require(script.Parent.component)

return {
	init = function(p1) -- line: 6
		-- upvalues: pageLogger (copy)
		pageLogger:setParent(p1)
	end,
	doSomething = function() -- line: 9
		-- upvalues: pageLogger (copy), component (copy)
		pageLogger:info("calling {root} {foo}")

		return component()
	end
}
