local parent = script.Parent.Parent

require(parent.ES7Types)

local WeakMap = {}
WeakMap.__index = WeakMap

function WeakMap.new()
	return (setmetatable({
		_weakMap = setmetatable({}, { __mode = "k" })
	}, WeakMap))
end

function WeakMap:get(p)
	return self._weakMap[p]
end

function WeakMap:set(p, p2)
	self._weakMap[p] = p2
	return self
end

function WeakMap:has(p): boolean
	return self._weakMap[p] ~= nil
end

return WeakMap
