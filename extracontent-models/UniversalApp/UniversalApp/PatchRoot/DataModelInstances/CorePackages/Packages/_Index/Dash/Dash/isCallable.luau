local function isCallable(value)
	return (type(value) == "function" or type(value) == "table" and getmetatable(value) and getmetatable(value).__call ~= nil)
		and true
		or false
end

return isCallable
