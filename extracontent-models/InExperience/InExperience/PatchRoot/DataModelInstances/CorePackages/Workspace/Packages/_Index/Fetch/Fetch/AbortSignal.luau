local ParentParent = script.Parent.Parent
local Error = require(ParentParent.LuauPolyfill).Error
local t1 = {}

t1.__index = t1

function t1.new() -- line: 20
	-- upvalues: t1 (copy), Error (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.aborted = false
	t2.reason = Error.new("Undefined Error")
	t2._signal = Instance.new("BindableEvent")

	return t2
end
function t1.abort(p1) -- line: 32
	-- upvalues: t1 (copy), Error (copy)
	local v6 = t1.new()

	v6.reason = p1 or Error.new("Signal Aborted")

	return v6
end
function t1.timeout(n1: number) -- line: 38
	-- upvalues: t1 (copy), Error (copy)
	local v8 = t1.new()

	v8.reason = Error.new("TimeoutError")
	task.delay(n1 / 1000, function() -- line: 41
		-- upvalues: v8 (copy)
		v8:fire()
	end)

	return v8
end
function t1.throwIfAborted(p2) -- line: 47
	if p2.aborted then
		error(p2.reason)
	end
end
function t1.connect(p3, p4) -- line: 55
	return p3._signal.Event:Connect(p4)
end
function t1.fire(p5) -- line: 60
	p5.aborted = true
	p5._signal:Fire()
end

return {
	AbortSignal = t1
}
