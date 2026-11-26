local err = require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/LuauPolyfill").Error

local class = {}
class.__index = class

function class.new()
	local v5 = {}
	setmetatable(v5, class)

	v5.aborted = false
	v5.reason = err.new("Undefined Error")

	v5._signal = Instance.new("BindableEvent")

	return v5
end

function class.abort(p2)
	local v5 = class.new()
	v5.reason = p2 or err.new("Signal Aborted")
	return v5
end

function class:timeout()
	local v5 = class.new()
	v5.reason = err.new("TimeoutError")
	task.delay(self / 1000, function()
		v5:fire()
	end)
	return v5
end

function class.throwIfAborted(p2)
	if p2.aborted then
		error(p2.reason)
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
