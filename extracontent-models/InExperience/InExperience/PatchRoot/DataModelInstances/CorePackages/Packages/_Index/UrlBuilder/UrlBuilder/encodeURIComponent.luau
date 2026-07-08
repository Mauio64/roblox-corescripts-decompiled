local function formatCharacter(p1) -- line: 1
	return string.format("%%%02X", p1:byte(1, 1))
end

return function(p2) -- line: 5
	-- upvalues: formatCharacter (copy)
	return p2:gsub("[^%w_%-%!%.%~%*%'%(%)]", formatCharacter)
end
