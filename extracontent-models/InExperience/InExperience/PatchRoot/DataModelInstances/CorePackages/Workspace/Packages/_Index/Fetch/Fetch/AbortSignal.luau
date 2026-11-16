local parent = script.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Error = LuauPolyfill.Error

local class = {}
class.__index = class

function class.new()
	local v = {}
	setmetatable(v, class)

	v.aborted = false
	v.reason = Error.new("Undefined Error")

	v._signal = Instance.new("BindableEvent")

	return v
end

function class.abort(p)
	local v = class.new()
	v.reason = p or Error.new("Signal Aborted")
	return v
end

function class.timeout(p: number)
	local v = class.new()
	v.reason = Error.new("TimeoutError")
	task.delay(p / 1000, function()
		v:fire()
	end)
	return v
end

function class.throwIfAborted(p)
	if p.aborted then
		error(p.reason)
	end
end

function class:connect(onEvent)
	return self._signal.Event:Connect(onEvent)
end

function class:fire()
	self.aborted = true
	self._signal:Fire()
end

return { AbortSignal = class }
