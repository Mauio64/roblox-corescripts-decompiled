local symbols = require(script.Parent.symbols)
local t1 = {}

t1.__index = t1

local t2 = {}

setmetatable(t2, {
	__mode = "kv"
})

function t1.new(p1) -- line: 12
	-- upvalues: symbols (copy), t1 (copy), t2 (copy)
	local t3 = {
		[symbols.Calls] = {}
	}

	setmetatable(t3, t1)

	local function v6(...) -- line: 18
		-- upvalues: p1 (copy), t3 (copy), symbols (copy)
		local t4 = {
			args = table.pack(...),
			result = table.pack(p1(...))
		}

		table.insert(t3[symbols.Calls], t4)

		return table.unpack(t4.result)
	end

	t3.inner = v6
	t2[v6] = t3

	return t3, v6
end
function t1.lookup(p2) -- line: 33
	-- upvalues: t2 (copy)
	return t2[p2]
end

return t1
