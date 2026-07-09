return function(p1, p2, n1: number?) -- line: 3
	local TextSource = p1.TextSource

	if not TextSource then
		return false
	end

	if n1 and n1 == TextSource.UserId then
		return false
	end

	local v5 = string.lower(TextSource.Username or "")
	local v6 = string.lower(TextSource.DisplayName or "")

	return v5 ~= "" and p2.isUsernameMuted(v5) or (v6 ~= "" and p2.isDisplayNameMuted(v6) or p2.isUserIdMuted(TextSource.UserId))
end
