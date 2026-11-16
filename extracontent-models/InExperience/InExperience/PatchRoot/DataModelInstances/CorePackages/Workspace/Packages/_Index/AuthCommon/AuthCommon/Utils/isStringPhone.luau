return function(value: string?)
	if not value or value == "" then
		return false
	end

	assert(value, "")
	local v = string.find(value, "^%+*[%d%-%s%.%(%)]+$") ~= nil
	local v2 = #value:gsub("[^%d]", "") >= 6
	return v and v2
end
