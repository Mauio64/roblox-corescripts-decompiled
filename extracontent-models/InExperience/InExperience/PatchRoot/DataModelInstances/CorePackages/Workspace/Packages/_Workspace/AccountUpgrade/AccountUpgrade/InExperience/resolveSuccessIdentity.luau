local function isBlank(p: string?): boolean -- 2 equivalent calls inferred from this helper
	return p == nil or p == ""
end

local function resolveSuccessIdentity(p, p2)
	local username

	if p then
		if not isBlank(p.username) then -- inferred equivalent call
			username = p.username
		end
	end

	local username2 = username or p2.username or ""
	local didUsernameChange

	if username == nil then
		didUsernameChange = false
	else
		didUsernameChange = username ~= p2.username
	end

	local displayName

	if p then
		displayName = p.displayName
	end

	if isBlank(displayName) then -- inferred equivalent call
		if didUsernameChange then
			displayName = username2
		else
			displayName = p2.displayName
		end
	end

	return {
		username = username2,
		displayName = displayName,
		didUsernameChange = didUsernameChange
	}
end

return resolveSuccessIdentity
