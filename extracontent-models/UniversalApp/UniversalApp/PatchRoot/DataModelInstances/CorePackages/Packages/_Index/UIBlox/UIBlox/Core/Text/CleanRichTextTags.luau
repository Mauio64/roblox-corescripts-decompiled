local function cleanRichTextTags(value: string)
	local v = 0
	local v2 = ""

	for i = 1, #value do
		local v3 = string.sub(value, i, i)

		if v3 == "<" then
			v += 1
		elseif v3 == ">" and v > 0 then
			v -= 1
		elseif v == 0 then
			v2 ..= v3
		end
	end

	return if v == 0 then v2 else value
end

return cleanRichTextTags
