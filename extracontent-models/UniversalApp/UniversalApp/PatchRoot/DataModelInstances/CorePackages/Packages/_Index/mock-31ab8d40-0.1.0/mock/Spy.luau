local symbols = require(script.Parent.symbols)

local Spy = {}
Spy.__index = Spy

local v = {}
setmetatable(v, { __mode = "kv" })

function Spy.new(callback)
	local v2 = { [symbols.Calls] = {} }

	setmetatable(v2, Spy)

	local function fn(...)
		local v3 = {
			args = table.pack(...),
			result = table.pack(callback(...))
		}

		table.insert(v2[symbols.Calls], v3)
		return table.unpack(v3.result)
	end

	v2.inner = fn
	v[fn] = v2

	return v2, fn
end

function Spy.lookup(p)
	return v[p]
end

return Spy
