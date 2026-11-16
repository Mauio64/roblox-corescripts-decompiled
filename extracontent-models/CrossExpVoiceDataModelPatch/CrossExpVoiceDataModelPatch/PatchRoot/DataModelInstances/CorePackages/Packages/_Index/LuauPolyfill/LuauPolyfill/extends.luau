return function(p, p2, callback)
	local class = {}
	class.__index = class
	function class.__tostring(p3)
		return getmetatable(p).__tostring(p3)
	end

	local class2 = {}

	function class.new(...)
		local v = {}
		callback(v, ...)
		return (setmetatable(v, class))
	end

	if typeof((getmetatable(p))) == "table" and getmetatable(p).__call then
		function class2.__call(_, ...)
			return class.new(...)
		end
	end

	class2.__index = p
	function class2.__tostring(p3)
		if p3 == class then
			return (tostring(p2))
		end

		return getmetatable(p).__tostring(p3)
	end

	setmetatable(class, class2)

	return class
end
