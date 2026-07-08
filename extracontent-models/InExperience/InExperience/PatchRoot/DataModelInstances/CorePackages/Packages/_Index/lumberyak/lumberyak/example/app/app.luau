local appLogger = require(script.Parent.appLogger)
local page = require(script.Parent.Parent.page.page)

appLogger:addSink(require(script.Parent.PrintSink).new(appLogger.Levels.Error))

return function() -- line: 8
	-- upvalues: appLogger (copy), page (copy)
	appLogger:info("calling {root}")
	page.init(appLogger)

	return page.doSomething()
end
