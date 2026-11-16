local pageLogger = require(script.Parent.pageLogger)
local component = require(script.Parent.component)
local Page = {}

function Page.init(p)
	pageLogger:setParent(p)
end
function Page.doSomething()
	pageLogger:info("calling {root} {foo}")
	return component()
end

return Page
