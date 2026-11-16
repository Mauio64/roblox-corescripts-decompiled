return {
	keysToString = function(items, p: string, flag: boolean?)
		local v = {}

		for k in items do
			table.insert(v, (tostring(k)))
		end

		if flag then
			table.sort(v)
		end

		return table.concat(v, p)
	end
}
