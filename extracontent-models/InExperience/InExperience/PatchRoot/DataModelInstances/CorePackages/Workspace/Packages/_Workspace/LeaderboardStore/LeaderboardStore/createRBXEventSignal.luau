local parent = script.Parent.Parent
local Signals = require(parent.Signals)

local function defaultFilter(...)
	return select(1, ...)
end

local function createRBXEventSignal(object, p, callback)
	local signal, v = Signals.createSignal(p)

	if callback == nil then
		callback = defaultFilter
	end

	return signal, (object:Connect(function(...)
		v(callback(...))
	end))
end

return createRBXEventSignal
