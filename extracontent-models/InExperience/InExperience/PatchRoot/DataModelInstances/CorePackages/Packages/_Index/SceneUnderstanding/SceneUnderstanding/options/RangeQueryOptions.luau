local v = { maxDistance = 100, limit = 1e999 }

return {
	new = function(items)
		local clone = table.clone(v)

		if items then
			for k, item in items do
				clone[k] = item
			end
		end

		return clone
	end
}
