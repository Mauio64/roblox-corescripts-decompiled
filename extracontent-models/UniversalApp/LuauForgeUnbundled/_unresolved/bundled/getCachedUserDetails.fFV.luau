local function getCachedUserDetails(items, value)
	if value == "" or type(items) ~= "table" then
		return nil, nil
	end

	local v5 = string.lower(value)

	for k, item in items do
		if type(item) ~= "table" then
			continue
		end

		local username = item.username or item.userIdentifier

		if type(username) == "string" and string.lower(username) == v5 then
			return tonumber(k), item.displayName
		end
	end

	return nil, nil
end

return getCachedUserDetails
