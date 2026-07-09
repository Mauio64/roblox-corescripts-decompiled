local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 56
	-- upvalues: t1 (copy)
	return (setmetatable({
		type = t2.type or "default",
		category = t2.category,
		message = t2.message,
		data = t2.data,
		level = t2.level or "info",
		timestamp = t2.timestamp or os.time(),
		origin = t2.origin
	}, t1))
end

return t1
