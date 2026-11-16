local class = {}
class.__index = class

require(script.Parent.message)

function class.new(items)
	local types = {}

	for _, item in items do
		types[item.descriptor.fullName] = item
	end

	return (setmetatable({ _types = types }, class))
end

function class:findMessage(p: string)
	return self._types[p]
end

function class:register(p)
	self._types[p.descriptor.fullName] = p
end

return { TypeRegistry = class, default = class.new({}) }
