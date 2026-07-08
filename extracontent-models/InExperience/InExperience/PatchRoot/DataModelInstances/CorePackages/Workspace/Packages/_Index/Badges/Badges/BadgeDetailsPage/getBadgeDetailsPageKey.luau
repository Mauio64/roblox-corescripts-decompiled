local function getBadgeDetailsPageKey(s1: string?) -- line: 1
	if s1 == nil then
		return "BadgeDetails-Unknown"
	end

	return `BadgeDetails-{ s1 }`
end

return getBadgeDetailsPageKey
