local symbols = require(script.Parent.symbols)
local Spy = require(script.Parent.Spy)
local t1 = {}
local t3 = {
	__index = function(p1, p2) -- line: 7
		-- upvalues: symbols (copy), t1 (copy)
		local mt = getmetatable(p1)
		local v8 = mt[symbols.Children][p2]

		if v8 == nil then
			local v9 = t1.new()

			mt[symbols.Children][p2] = v9

			return v9
		end

		if v8 == symbols.None then
			return nil
		end

		return v8
	end,
	__newindex = function(p3, p4, p5) -- line: 22
		-- upvalues: Spy (copy), symbols (copy)
		local mt = getmetatable(p3)

		if type(p5) == "function" then
			local v14

			v14, p5 = Spy.new(p5)
		elseif p5 == nil then
			p5 = symbols.None
		end

		if p4 == symbols.ReturnValue then
			mt[symbols.ReturnValue] = {
				p5,
				n = 1
			}

			return
		end

		mt[symbols.Children][p4] = p5
	end,
	__call = function(p6, ...) -- line: 39
		-- upvalues: symbols (copy), t1 (copy)
		local mt = getmetatable(p6)
		local t2 = {
			args = table.pack(...),
			result = mt[symbols.ReturnValue]
		}

		if t2.result == nil then
			t2.result = {
				t1.new(),
				n = 1
			}
			mt[symbols.ReturnValue] = t2.result
		elseif t2.result == symbols.None then
			t2.result = {
				n = 1
			}
		end

		table.insert(mt[symbols.Calls], t2)

		return table.unpack(t2.result)
	end
}

function t1.new(p7) -- line: 60
	-- upvalues: symbols (copy), t3 (copy)
	local t4 = {
		[symbols.Calls] = {},
		[symbols.Children] = {},
		[symbols.Lock] = p7,
		[symbols.ReturnValue] = nil
	}

	for k, v in pairs(t3) do
		t4[k] = v
	end

	return (setmetatable({}, t4))
end

return t1
