local function isBlank(p2): boolean
	return p2 == nil or p2 == ""
end

local function resolveSuccessIdentity(p2, p3)
	local username

	if p2 then
		local username2 = p2.username

		if not (username2 == nil or username2 == "") then
			username = p2.username
		end
	end

	local v5 = username or p3.username or ""

	local v6 = not (username == nil) and username ~= p3.username

	local v7 = if p2 then p2.displayName else nil

	if v7 == nil or v7 == "" then
		v7 = if v6 then v5 else p3.displayName
	end

	return { username = v5, displayName = v7, didUsernameChange = v6 }
end

return resolveSuccessIdentity
