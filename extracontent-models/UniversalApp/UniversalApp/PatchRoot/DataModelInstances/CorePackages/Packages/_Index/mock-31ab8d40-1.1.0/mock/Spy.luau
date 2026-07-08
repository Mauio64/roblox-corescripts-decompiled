local symbols = require(script.Parent.symbols)
local isAMagicMock = require(script.Parent.isAMagicMock)
local t1 = {}

t1.__index = t1

function t1.__call(p1, ...) -- line: 9
	return p1.inner(...)
end

local t2 = {}

setmetatable(t2, {
	__mode = "kv"
})

function t1.new(p2) -- line: 16
	-- upvalues: symbols (copy), t1 (copy), t2 (copy)
	local t3 = {
		[symbols.isSpy] = true,
		[symbols.Calls] = {}
	}

	setmetatable(t3, t1)

	local function v8(...) -- line: 23
		-- upvalues: p2 (copy), t3 (copy), symbols (copy)
		local t4 = {
			args = table.pack(...),
			result = table.pack(p2(...))
		}

		table.insert(t3[symbols.Calls], t4)

		return table.unpack(t4.result)
	end

	t3.inner = v8
	t2[v8] = t3

	return t3, v8
end
function t1.lookup(p3) -- line: 38
	-- upvalues: t2 (copy)
	return t2[p3]
end
function t1.is(p4) -- line: 42
	-- upvalues: isAMagicMock (copy), symbols (copy)
	if not isAMagicMock(p4) then
		return type(p4) == "table" and p4[symbols.isSpy] ~= nil
	end

	return false
end

return t1
