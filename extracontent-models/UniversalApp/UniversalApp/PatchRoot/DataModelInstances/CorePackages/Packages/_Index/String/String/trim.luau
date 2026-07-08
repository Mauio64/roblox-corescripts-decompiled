local trimStart = require(script.Parent.trimStart)
local trimEnd = require(script.Parent.trimEnd)

return function(s1: string) -- line: 20
	-- upvalues: trimStart (copy), trimEnd (copy)
	return trimStart(trimEnd(s1))
end
