local parent = script.Parent

require(parent.Types)
local ValueChangedSignal = require(parent.ValueChangedSignal)

local AvailabilitySignal = {}
AvailabilitySignal.__index = AvailabilitySignal

function AvailabilitySignal.new(flag: boolean)
	return ValueChangedSignal.new(flag)
end

return AvailabilitySignal
