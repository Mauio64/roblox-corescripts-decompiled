return {
	getThoughtHeading = function(value)
		if typeof(value) ~= "string" then
			return nil
		end

		local v = string.match(value, "^%s*%*%*([^\r\n]-)%*%*")

		if v == nil then
			return nil
		end

		local v2 = string.match(v, "^%s*(.-)%s*$")

		if v2 == "" then
			return nil
		end

		return (string.sub(v2, 1, (utf8.offset(v2, 81) or #v2 + 1) - 1))
	end
}
