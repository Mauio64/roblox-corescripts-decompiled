return {
	stringIndexOf = function(value: string, p: string)
		local v, _ = string.find(value, p)

		return if v == nil then -1 else v
	end
}
