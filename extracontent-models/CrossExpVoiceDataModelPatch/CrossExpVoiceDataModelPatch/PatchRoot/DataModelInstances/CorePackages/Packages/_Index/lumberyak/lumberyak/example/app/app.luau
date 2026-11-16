local appLogger = require(script.Parent.appLogger)

local page = require(script.Parent.Parent.page.page)
local PrintSink = require(script.Parent.PrintSink)

appLogger:addSink(PrintSink.new(appLogger.Levels.Error))

return function()
	appLogger:info("calling {root}")
	page.init(appLogger)

	return page.doSomething()
end
