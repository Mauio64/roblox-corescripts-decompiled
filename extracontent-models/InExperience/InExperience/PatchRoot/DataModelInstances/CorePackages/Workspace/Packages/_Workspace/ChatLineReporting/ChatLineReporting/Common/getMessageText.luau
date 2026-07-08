function getMessageText(b1: boolean?, s1: string?, s2: string?) -- line: 2
	if s1 == nil or s1 == "" then
		return s2 or ""
	end

	if b1 then
		return s1 or ""
	end

	return s2 or ""
end

return getMessageText
