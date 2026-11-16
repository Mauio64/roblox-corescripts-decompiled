local function getBadgeDetailsPageKey(p2)
	if p2 == nil then
		return "BadgeDetails-Unknown"
	end

	return `BadgeDetails-{p2}`
end

return getBadgeDetailsPageKey
