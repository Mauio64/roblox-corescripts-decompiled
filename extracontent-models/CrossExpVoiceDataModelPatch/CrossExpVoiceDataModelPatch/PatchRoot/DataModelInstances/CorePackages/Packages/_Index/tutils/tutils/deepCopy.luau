local function deepCopy(items, options)
	if type(items) ~= "table" then
		return items
	end

	if options and options[items] then
		return options[items]
	end

	local v = options or {}
	local self = setmetatable({}, (getmetatable(items)))
	v[items] = self

	for k, item in pairs(items) do
		self[deepCopy(k, v)] = deepCopy(item, v)
	end

	return self
end

return deepCopy
