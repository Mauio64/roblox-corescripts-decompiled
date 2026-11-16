return function(value, p): boolean
	if not value or value == "" then
		return true
	end

	local v = p.displayName

	if p.alias ~= nil then
		v ..= p.alias
	end

	return string.find(string.lower(v), string.lower(value), 1, true) ~= nil
end
