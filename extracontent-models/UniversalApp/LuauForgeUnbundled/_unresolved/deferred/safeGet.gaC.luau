local function safeGet(p2, p3, ...)
	if not p3 then
		return p2
	end

	if type(p2) == "table" then
		return safeGet(p2[p3], ...)
	end

	return nil
end

return safeGet
