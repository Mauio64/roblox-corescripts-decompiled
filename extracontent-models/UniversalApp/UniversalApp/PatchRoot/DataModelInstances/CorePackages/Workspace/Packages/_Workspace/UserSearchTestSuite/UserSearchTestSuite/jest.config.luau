local ParentParent = script.Parent.Parent

return {
	projects = { require(ParentParent.UserSearch)["jest.config"] }
}
