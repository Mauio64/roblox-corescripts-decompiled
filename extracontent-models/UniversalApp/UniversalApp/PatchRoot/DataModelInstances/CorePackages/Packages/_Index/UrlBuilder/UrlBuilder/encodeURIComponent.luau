local function formatCharacter(value)
	return string.format("%%%02X", value:byte(1, 1))
end

return function(value)
	return value:gsub("[^%w_%-%!%.%~%*%'%(%)]", formatCharacter)
end
