local parent = script.Parent
require(parent.Types)

local function throwNotImplemented(p) -- 7 equivalent calls inferred from this helper
	local Error = require(parent.Error)

	Error.new("NotImplemented", "The method \"{methodName}\" is not implemented on the class \"{className}\""):throw(p)
end

local function fn()
	return {}
end

local function class(p: string, callback)
	local v = callback or fn
	local class2 = { name = p }

	function class2.new(...)
		local v2 = v(...)
		setmetatable(v2, {
			__index = class2,
			__tostring = class2.toString,
			__eq = class2.equals,
			__lt = class2.__lt,
			__le = class2.__le,
			__add = class2.__add,
			__sub = class2.__sub,
			__mul = class2.__mul,
			__div = class2.__div,
			__mod = class2.__mod
		})

		v2.Class = class2
		v2:_init(...)
		return v2
	end

	function class2:_init() end

	function class2.isInstance(p2)
		local success, result = pcall(function(): boolean
			local metatable = getmetatable(p2)

			while metatable do
				if metatable.__index == class2 then
					return true
				end

				metatable = getmetatable(metatable.__index)
			end

			return false
		end)

		return success and result
	end

	function class2.extend(p2, p3: string, p4)
		local v2 = class(p3, p4 or class2.new)
		setmetatable(v2, { __index = p2 })
		return v2
	end

	function class2.toString(p2)
		return p2.name
	end

	function class2.equals(p2, p3)
		return (rawequal(p2, p3))
	end

	function class2.__lt(_, _)
		throwNotImplemented({ methodName = "__lt", className = p }) -- inferred equivalent call
	end

	function class2.__le(_, _)
		throwNotImplemented({ methodName = "__le", className = p }) -- inferred equivalent call
	end

	function class2.__add(_)
		throwNotImplemented({ methodName = "__add", className = p }) -- inferred equivalent call
	end
	function class2.__sub(_)
		throwNotImplemented({ methodName = "__sub", className = p }) -- inferred equivalent call
	end
	function class2.__mul(_)
		throwNotImplemented({ methodName = "__mul", className = p }) -- inferred equivalent call
	end
	function class2.__div(_)
		throwNotImplemented({ methodName = "__div", className = p }) -- inferred equivalent call
	end
	function class2.__mod(_)
		throwNotImplemented({ methodName = "__mod", className = p }) -- inferred equivalent call
	end

	return class2
end

return class
