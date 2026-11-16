local function getBadgeDetailsPageKey(p: string?)
	if p == nil then
		return "BadgeDetails-Unknown"
	end

	return `BadgeDetails-{p}`
end

return getBadgeDetailsPageKey
