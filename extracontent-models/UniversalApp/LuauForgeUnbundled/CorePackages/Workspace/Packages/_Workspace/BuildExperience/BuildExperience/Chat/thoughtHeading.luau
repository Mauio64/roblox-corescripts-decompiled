return {
	getThoughtHeading = function(value)
		if typeof(value) ~= "string" then
			return nil
		end

		local v5 = string.match(value, "^%s*%*%*([^\r\n]-)%*%*")

		if v5 == nil then
			return nil
		end

		local v6 = string.match(v5, "^%s*(.-)%s*$")

		if v6 == "" then
			return nil
		end

		return (string.sub(v6, 1, (utf8.offset(v6, 81) or #v6 + 1) - 1))
	end
}
