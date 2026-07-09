local ParentParent = script.Parent.Parent

return {
	projects = { require(ParentParent.FriendsLanding)["jest.config"] }
}
