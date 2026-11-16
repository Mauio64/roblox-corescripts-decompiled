local trimStart = require(script.Parent.trimStart)
local trimEnd = require(script.Parent.trimEnd)

return function(p: string)
	return trimStart(trimEnd(p))
end
