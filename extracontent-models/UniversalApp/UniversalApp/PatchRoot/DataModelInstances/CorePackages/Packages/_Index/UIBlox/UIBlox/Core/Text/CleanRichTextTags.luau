local function cleanRichTextTags(s1: string) -- line: 4
	local s2 = ""
	local n1 = 0

	for i = 1, #s1 do
		local v6 = string.sub(s1, i, i)

		if v6 == "<" then
			n1 += 1
		elseif v6 == ">" and n1 > 0 then
			n1 -= 1
		elseif n1 == 0 then
			s2 ..= v6
		end
	end

	if n1 ~= 0 then
		return s1
	end

	return s2
end

return cleanRichTextTags
