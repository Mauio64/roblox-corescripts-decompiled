local function reduce(items, callback, p)
	for k, item in items do
		p = callback(p, item, k)
	end

	return p
end

return reduce
