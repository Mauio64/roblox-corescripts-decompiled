return function(p1, t1: {[any]: any}) -- line: 8
	if not p1 or p1 == "" then
		return true
	end

	local displayName = t1.displayName

	if t1.alias ~= nil then
		displayName ..= t1.alias
	end

	return string.find(string.lower(displayName), string.lower(p1), 1, true) ~= nil
end
