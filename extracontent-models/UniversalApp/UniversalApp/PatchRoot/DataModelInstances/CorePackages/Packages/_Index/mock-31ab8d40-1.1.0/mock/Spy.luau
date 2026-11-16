local symbols = require(script.Parent.symbols)
local isAMagicMock = require(script.Parent.isAMagicMock)

local Spy = {}
Spy.__index = Spy
function Spy.__call(p, ...)
	return p.inner(...)
end

local v = {}
setmetatable(v, { __mode = "kv" })

function Spy.new(callback)
	local v2 = { [symbols.isSpy] = true, [symbols.Calls] = {} }

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

function Spy.is(p): boolean
	return not isAMagicMock(p) and type(p) == "table" and p[symbols.isSpy] ~= nil
end

return Spy
