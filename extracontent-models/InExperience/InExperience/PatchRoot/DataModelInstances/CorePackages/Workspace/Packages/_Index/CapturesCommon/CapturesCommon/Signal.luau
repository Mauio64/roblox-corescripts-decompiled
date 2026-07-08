local scriptParent = script.Parent
local Immutable = require(scriptParent.Immutable)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 34
	-- upvalues: t1 (copy)
	local t2 = {
		_listeners = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.connect(p1, p2) -- line: 44
	-- upvalues: Immutable (copy)
	local t3 = {
		isConnected = true,
		callback = p2
	}

	p1._listeners = Immutable.Append(p1._listeners, t3)

	return {
		Disconnect = function() -- line: 57
			-- upvalues: t3 (copy), p1 (copy), Immutable (copy)
			warn(string.format("Connection:Disconnect() has been deprecated, use Connection:disconnect()\n%s]", debug.traceback()))
			t3.isConnected = false
			p1._listeners = Immutable.RemoveValueFromList(p1._listeners, t3)
		end,
		disconnect = function() -- line: 51
			-- upvalues: t3 (copy), p1 (copy), Immutable (copy)
			t3.isConnected = false
			p1._listeners = Immutable.RemoveValueFromList(p1._listeners, t3)
		end
	}
end
function t1.fire(p3, ...) -- line: 70
	for _, v in ipairs(p3._listeners) do
		if v.isConnected then
			v.callback(...)
		end
	end
end
function t1.Connect(p4, ...) -- line: 78
	warn(string.format("Signal:Connect() has been deprecated, use Signal:connect()\n%s]", debug.traceback()))

	return p4:connect(...)
end
function t1.Fire(p5, ...) -- line: 83
	warn(string.format("Signal:Fire() has been deprecated, use Signal:fire()\n%s]", debug.traceback()))
	p5:fire(...)
end

return t1
