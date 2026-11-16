return function(value)
	if not value or value == "" then
		return false
	end

	assert(value, "")
	local v5 = string.find(value, "^%+*[%d%-%s%.%(%)]+$") ~= nil
	local v6 = #value:gsub("[^%d]", "") >= 6
	return v5 and v6
end
