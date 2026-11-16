local function getReplyQuote(p, p2)
	local v = p2 or p

	if v == nil or (v.type == "system" or v.visibility == "hidden") then
		return nil
	end

	if v.status == "Moderated" or v.status == "Failed" then
		return nil
	end

	local content = v.content

	if type(content) == "string" and content ~= "" then
		return content
	end

	return nil
end

return getReplyQuote
