local function isLoggedOutUserId(p2): boolean
	return p2 == nil or p2 == "" or p2 == "-1" or p2 == "0"
end

return isLoggedOutUserId
