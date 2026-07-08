local Immutable = require(script.Parent.Immutable)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 16
	-- upvalues: t1 (copy)
	local t2 = {
		_listeners = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.Connect(p1, p2) -- line: 26
	-- upvalues: Immutable (copy)
	local t3 = {
		isConnected = true,
		callback = p2
	}

	p1._listeners = Immutable.Append(p1._listeners, t3)

	local function disconnect() -- line: 33
		-- upvalues: t3 (copy), p1 (copy), Immutable (copy)
		t3.isConnected = false
		p1._listeners = Immutable.RemoveValueFromList(p1._listeners, t3)
	end

	return {
		Disconnect = disconnect
	}
end
function t1.Fire(p3, ...) -- line: 43
	for _, v in ipairs(p3._listeners) do
		if v.isConnected then
			v.callback(...)
		end
	end
end

return t1
