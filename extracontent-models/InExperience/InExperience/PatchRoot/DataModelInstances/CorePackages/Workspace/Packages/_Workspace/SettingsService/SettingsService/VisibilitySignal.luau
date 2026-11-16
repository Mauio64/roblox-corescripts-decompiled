local parent = script.Parent

require(parent.Types)
local ValueChangedSignal = require(parent.ValueChangedSignal)

local VisibilitySignal = {}
VisibilitySignal.__index = VisibilitySignal

function VisibilitySignal.new(flag: boolean)
	return ValueChangedSignal.new(flag)
end

return VisibilitySignal
