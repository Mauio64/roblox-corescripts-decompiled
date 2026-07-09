local Parent = script:FindFirstAncestor("ReadAloud").Parent
local Logger = require(Parent.Loggers).Logger

return function(s1: string) -- line: 10
	-- upvalues: Logger (copy)
	return Logger:new("ReadAloud." .. s1)
end
