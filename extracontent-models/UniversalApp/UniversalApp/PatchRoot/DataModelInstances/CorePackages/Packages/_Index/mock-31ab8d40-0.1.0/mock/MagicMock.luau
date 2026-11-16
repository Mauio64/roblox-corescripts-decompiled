local symbols = require(script.Parent.symbols)
local Spy = require(script.Parent.Spy)

local MagicMock = {}
local v = {
	__index = function(p, p2)
		local metatable = getmetatable(p)
		local v = metatable[symbols.Children][p2]

		if v == nil then
			local v2 = MagicMock.new()
			metatable[symbols.Children][p2] = v2
			return v2
		else
			return if v ~= symbols.None then v else nil
		end
	end,
	__newindex = function(p, p2, callback)
		local metatable = getmetatable(p)

		if type(callback) == "function" then
			local _
			_, callback = Spy.new(callback)
		elseif callback == nil then
			callback = symbols.None
		end

		if p2 == symbols.ReturnValue then
			metatable[symbols.ReturnValue] = {
				callback,
				n = 1
			}
		else
			metatable[symbols.Children][p2] = callback
		end
	end,
	__call = function(p, ...)
		local metatable = getmetatable(p)
		local v = {
			args = table.pack(...),
			result = metatable[symbols.ReturnValue]
		}

		if v.result == nil then
			v.result = {
				MagicMock.new(),
				n = 1
			}
			metatable[symbols.ReturnValue] = v.result
		elseif v.result == symbols.None then
			v.result = { n = 1 }
		end

		table.insert(metatable[symbols.Calls], v)
		return table.unpack(v.result)
	end
}

function MagicMock.new(p)
	local class = {
		[symbols.Calls] = {},
		[symbols.Children] = {},
		[symbols.Lock] = p,
		[symbols.ReturnValue] = nil
	}

	for k, v2 in pairs(v) do
		class[k] = v2
	end

	return (setmetatable({}, class))
end

return MagicMock
