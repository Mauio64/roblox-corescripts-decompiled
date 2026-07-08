return function(s1: string?) -- line: 1
	if not s1 or s1 == "" then
		return false
	end

	assert(s1, "")

	local v2 = string.find(s1, "^%+*[%d%-%s%.%(%)]+$") ~= nil
	local v3 = #s1:gsub("[^%d]", "") >= 6

	return v2 and v3
end
