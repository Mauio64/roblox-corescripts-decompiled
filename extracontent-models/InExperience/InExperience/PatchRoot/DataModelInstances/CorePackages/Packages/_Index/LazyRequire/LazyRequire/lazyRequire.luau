return function(p1) -- line: 1
	local t1 = {}
	local lib = nil

	setmetatable(t1, {
		__mode = "kv",
		__index = function(_, p3) -- line: 15
			-- upvalues: lib (ref), p1 (copy)
			local v6

			if lib then
				v6 = lib
			else
				lib = require(p1)
				v6 = lib
			end

			return v6[p3]
		end,
		__newindex = function(_, p5, p6) -- line: 20
			-- upvalues: lib (ref), p1 (copy)
			local v10

			if lib then
				v10 = lib
			else
				lib = require(p1)
				v10 = lib
			end

			v10[p5] = p6
		end,
		__call = function(_, ...) -- line: 25
			-- upvalues: lib (ref), p1 (copy)
			local v12

			if lib then
				v12 = lib
			else
				lib = require(p1)
				v12 = lib
			end

			return v12(...)
		end,
		__len = function(_) -- line: 30
			-- upvalues: lib (ref), p1 (copy)
			local v14

			if lib then
				v14 = lib
			else
				lib = require(p1)
				v14 = lib
			end

			return #v14
		end,
		__iter = function(_) -- line: 34
			-- upvalues: lib (ref), p1 (copy)
			local _next = next

			if lib then
				return _next, lib
			end

			lib = require(p1)

			return _next, lib
		end
	})

	return t1
end
