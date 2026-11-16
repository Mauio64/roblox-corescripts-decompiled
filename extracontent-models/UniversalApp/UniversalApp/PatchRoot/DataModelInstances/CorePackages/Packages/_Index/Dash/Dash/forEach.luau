local function forEach(items, callback)
	for k, item in items do
		callback(item, k)
	end
end

return forEach
