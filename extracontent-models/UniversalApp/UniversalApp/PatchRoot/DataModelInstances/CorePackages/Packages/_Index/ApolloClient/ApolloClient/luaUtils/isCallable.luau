local function isCallable(p1) -- line: 9
	if typeof(p1) == "function" then
		return true
	end

	if typeof(p1) == "table" then
		local mt = getmetatable(p1)

		if mt and rawget(mt, "__call") then
			return true
		end

		if p1._isMockFunction then
			return true
		end
	end

	return false
end

return isCallable
