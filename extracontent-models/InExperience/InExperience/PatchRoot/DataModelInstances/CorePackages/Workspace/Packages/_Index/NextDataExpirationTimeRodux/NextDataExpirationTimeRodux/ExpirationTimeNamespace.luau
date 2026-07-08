local Parent = script:FindFirstAncestor("NextDataExpirationTimeRodux").Parent
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort

return {
	GameDetailPage = "GameDetailPage",
	GameDetailPlayability = "GameDetailPlayability",
	GameSortGroup = "GameSortGroup",
	SongDetailPage = if not FFlagEnableTopSongsSort then nil else "SongDetailPage"
}
