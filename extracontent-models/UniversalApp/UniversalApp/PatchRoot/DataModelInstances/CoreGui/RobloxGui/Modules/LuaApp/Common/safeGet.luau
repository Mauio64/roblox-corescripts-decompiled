local function safeGet(p1, p2, ...) -- line: 3
	-- upvalues: safeGet (copy)
	if not p2 then
		return p1
	end

	if type(p1) ~= "table" then
		return nil
	end

	return safeGet(p1[p2], ...)
end

return safeGet
