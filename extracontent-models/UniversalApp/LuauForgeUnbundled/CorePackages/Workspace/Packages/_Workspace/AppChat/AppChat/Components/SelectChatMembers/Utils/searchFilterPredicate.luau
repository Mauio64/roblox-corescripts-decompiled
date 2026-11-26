return function(value, p2): boolean
	if not value or value == "" then
		return true
	end

	local v5 = p2.displayName

	if p2.alias ~= nil then
		v5 ..= p2.alias
	end

	return string.find(string.lower(v5), string.lower(value), 1, true) ~= nil
end
