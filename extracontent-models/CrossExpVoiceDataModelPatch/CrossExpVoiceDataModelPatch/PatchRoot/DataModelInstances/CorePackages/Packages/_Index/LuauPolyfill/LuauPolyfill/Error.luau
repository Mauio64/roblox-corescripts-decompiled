local class = {}

class.__index = class
function class.__tostring(p)
	return getmetatable(class).__tostring(p)
end

function class.new(value: string?)
	return (setmetatable({
		name = "Error",
		message = value or "",
		stack = debug.traceback(nil, 2)
	}, class))
end

return (setmetatable(class, {
	__call = function(_, ...)
		local v = class.new(...)
		v.stack = debug.traceback(nil, 2)
		return v
	end,
	__tostring = function(p)
		if p.name == nil then
			return (tostring("Error"))
		end

		if p.message and p.message ~= "" then
			return string.format("%s: %s", tostring(p.name), (tostring(p.message)))
		end

		return (tostring(p.name))
	end
}))
