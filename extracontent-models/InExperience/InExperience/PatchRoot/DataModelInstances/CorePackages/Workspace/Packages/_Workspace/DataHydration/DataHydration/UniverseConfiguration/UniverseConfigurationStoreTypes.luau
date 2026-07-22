local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.DataHydrationTypes)

return {
	PrivacyType = {
		Private = "Private",
		Public = "Public",
		FriendsOnly = "FriendsOnly"
	}
}
