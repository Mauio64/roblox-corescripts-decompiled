local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local t1 = {
	runAfterInteractions = function(_, p2: ((...any) -> ...any)) -- line: 20
		p2()

		return nil
	end
}
local t2 = {}

t2.__index = t2

function t2.new(p3: ((...any) -> ...any), n1: number) -- line: 64
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self._delay = n1
	self._callback = p3

	return self
end
function t2.dispose(t3: {[any]: any}, t4: {[any]: any}?) -- line: 71
	local v14 = t4 or {
		abort = false
	}

	if t3._taskHandle then
		t3._taskHandle.cancel()

		if not v14.abort then
			t3._callback()
		end

		t3._taskHandle = nil
	end
end
function t2.schedule(p4) -- line: 85
	-- upvalues: setTimeout (copy), t1 (copy), clearTimeout (copy)
	if p4._taskHandle then
		return
	end

	local v16 = setTimeout(function() -- line: 90
		-- upvalues: p4 (copy), t1 (copy)
		p4._taskHandle = t1:runAfterInteractions(function() -- line: 91
			-- upvalues: p4 (copy)
			p4._taskHandle = nil
			p4._callback()
		end)
	end, p4._delay)

	p4._taskHandle = {
		cancel = function() -- line: 100
			-- upvalues: clearTimeout (copy), v16 (copy)
			return clearTimeout(v16)
		end
	}
end

return t2
