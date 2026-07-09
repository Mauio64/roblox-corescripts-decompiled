local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.AffiliateLinks)["jest.config"],
		require(ParentParent.ExternalAttribution)["jest.config"],
		require(ParentParent.PlayerFeedback)["jest.config"]
	}
}
