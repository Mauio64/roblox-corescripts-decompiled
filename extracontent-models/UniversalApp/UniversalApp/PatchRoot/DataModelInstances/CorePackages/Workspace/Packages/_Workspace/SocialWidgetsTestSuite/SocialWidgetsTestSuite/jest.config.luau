local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.FriendsCarousel)["jest.config"],
		require(ParentParent.FriendsMenu)["jest.config"],
		require(ParentParent.PYMKCarousel)["jest.config"],
		require(ParentParent.SocialCarousel)["jest.config"]
	}
}
