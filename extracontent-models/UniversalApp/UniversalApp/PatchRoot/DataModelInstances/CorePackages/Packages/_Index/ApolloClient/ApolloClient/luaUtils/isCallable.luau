local function isCallable(value): boolean
	if typeof(value) == "function" then
		return true
	end

	if typeof(value) ~= "table" then
		return false
	end

	local metatable = getmetatable(value)

	if metatable and rawget(metatable, "__call") or value._isMockFunction then
		return true
	end

	return false
end

return isCallable
