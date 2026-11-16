local function isLoggedOutUserId(p: string?): boolean
	return p == nil or p == "" or p == "-1" or p == "0"
end

return isLoggedOutUserId
