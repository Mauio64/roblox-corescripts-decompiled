local function isCallable(p1) -- line: 7
	return type(p1) == "function" or type(p1) == "table" and (not not getmetatable(p1) and (getmetatable(p1).__call ~= nil or false))
end

return isCallable
