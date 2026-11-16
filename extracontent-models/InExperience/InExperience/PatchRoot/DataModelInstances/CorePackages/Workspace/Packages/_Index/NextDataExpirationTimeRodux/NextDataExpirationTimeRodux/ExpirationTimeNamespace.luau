local parent = script:FindFirstAncestor("NextDataExpirationTimeRodux").Parent

local SharedFlags = require(parent.SharedFlags)
return {
	GameDetailPage = "GameDetailPage",
	GameDetailPlayability = "GameDetailPlayability",
	GameSortGroup = "GameSortGroup",
	SongDetailPage = SharedFlags.FFlagEnableTopSongsSort and "SongDetailPage" or nil
}
