local ParentParent = script.Parent.Parent

return {
	projects = { require(ParentParent.SocialTab)["jest.config"] }
}
