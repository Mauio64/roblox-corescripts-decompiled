local scriptParent = script.Parent

require(scriptParent.Types)

local ValueChangedSignal = require(scriptParent.ValueChangedSignal)
local t1 = {}

t1.__index = t1

function t1.new(b1: boolean) -- line: 18
	-- upvalues: ValueChangedSignal (copy)
	return ValueChangedSignal.new(b1)
end

return t1
