local function escapePattern(s1: string) -- line: 3
	return s1:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
end

return escapePattern
