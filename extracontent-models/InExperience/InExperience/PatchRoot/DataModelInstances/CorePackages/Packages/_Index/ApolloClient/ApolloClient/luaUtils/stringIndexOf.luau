return {
	stringIndexOf = function(s1: string, s2: string) -- line: 11
		local start, _ = string.find(s1, s2)

		if start == nil then
			return -1
		end

		return start
	end
}
