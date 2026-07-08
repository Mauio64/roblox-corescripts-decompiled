local function isFoundationImage(s1: string?) -- line: 1
	return s1 ~= nil and (s1 ~= "" and s1:match("^%w+://.*$") == nil)
end

return isFoundationImage
