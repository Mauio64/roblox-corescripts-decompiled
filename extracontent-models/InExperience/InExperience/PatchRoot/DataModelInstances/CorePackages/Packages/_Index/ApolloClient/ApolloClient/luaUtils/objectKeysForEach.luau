return function(items, callback)
	for k, _ in items do
		callback(k)
	end
end
