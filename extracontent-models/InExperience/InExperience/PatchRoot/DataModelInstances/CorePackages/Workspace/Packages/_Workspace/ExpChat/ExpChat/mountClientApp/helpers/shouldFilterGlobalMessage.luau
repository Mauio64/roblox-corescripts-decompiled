return function(p, data, p2: number?)
	local textSource = p.TextSource

	if not textSource or p2 and textSource.UserId == p2 then
		return false
	end

	local username = string.lower(textSource.Username or "")
	local displayName = string.lower(textSource.DisplayName or "")
	return username ~= "" and data.isUsernameMuted(username)
		or displayName ~= "" and data.isDisplayNameMuted(displayName)
		or data.isUserIdMuted(textSource.UserId)
end
