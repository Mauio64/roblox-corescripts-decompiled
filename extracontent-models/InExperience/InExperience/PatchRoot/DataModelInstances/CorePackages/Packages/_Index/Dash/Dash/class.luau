local scriptParent = script.Parent

require(scriptParent.Types)

local function throwNotImplemented(p1) -- line: 4
	-- upvalues: scriptParent (copy)
	require(scriptParent.Error).new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(p1)
end
local function v3() -- line: 13
	return {}
end
local function class(s1: string, p2: ((...any) -> ...any)?) -- line: 49
	-- upvalues: v3 (copy), class (copy), scriptParent (copy)
	local v8 = p2 or v3
	local t1 = {
		name = s1
	}

	function t1.new(...) -- line: 65
		-- upvalues: v8 (copy), t1 (copy)
		local v10 = v8(...)

		setmetatable(v10, {
			__index = t1,
			__tostring = t1.toString,
			__eq = t1.equals,
			__lt = t1.__lt,
			__le = t1.__le,
			__add = t1.__add,
			__sub = t1.__sub,
			__mul = t1.__mul,
			__div = t1.__div,
			__mod = t1.__mod
		})
		v10.Class = t1
		v10:_init(...)

		return v10
	end
	function t1._init(_) -- line: 114
	end
	function t1.isInstance(p4) -- line: 133
		-- upvalues: t1 (copy)
		local ok, result = pcall(function() -- line: 134
			-- upvalues: p4 (copy), t1 (copy)
			local mt = getmetatable(p4)

			while mt do
				if mt.__index == t1 then
					return true
				end

				mt = getmetatable(mt.__index)
			end

			return false
		end)

		return ok and result
	end
	function t1.extend(t2: {[any]: any}, s2: string, p5) -- line: 184
		-- upvalues: class (copy), t1 (copy)
		local v18 = class(s2, p5 or t1.new)

		setmetatable(v18, {
			__index = t2
		})

		return v18
	end
	function t1.toString(p6) -- line: 222
		return p6.name
	end
	function t1.equals(p7, p8) -- line: 230
		return (rawequal(p7, p8))
	end
	function t1.__lt(_, _) -- line: 238
		-- upvalues: s1 (copy), scriptParent (copy)
		local t3 = {
			methodName = "__lt",
			className = s1
		}

		require(scriptParent.Error).new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(t3)
	end
	function t1.__le(_, _) -- line: 250
		-- upvalues: s1 (copy), scriptParent (copy)
		local t4 = {
			methodName = "__le",
			className = s1
		}

		require(scriptParent.Error).new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(t4)
	end
	function t1.__add(_) -- line: 257
		-- upvalues: s1 (copy), scriptParent (copy)
		local t5 = {
			methodName = "__add",
			className = s1
		}

		require(scriptParent.Error).new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(t5)
	end
	function t1.__sub(_) -- line: 263
		-- upvalues: s1 (copy), scriptParent (copy)
		local t6 = {
			methodName = "__sub",
			className = s1
		}

		require(scriptParent.Error).new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(t6)
	end
	function t1.__mul(_) -- line: 269
		-- upvalues: s1 (copy), scriptParent (copy)
		local t7 = {
			methodName = "__mul",
			className = s1
		}

		require(scriptParent.Error).new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(t7)
	end
	function t1.__div(_) -- line: 275
		-- upvalues: s1 (copy), scriptParent (copy)
		local t8 = {
			methodName = "__div",
			className = s1
		}

		require(scriptParent.Error).new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(t8)
	end
	function t1.__mod(_) -- line: 281
		-- upvalues: s1 (copy), scriptParent (copy)
		local t9 = {
			methodName = "__mod",
			className = s1
		}

		require(scriptParent.Error).new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(t9)
	end

	return t1
end

return class
