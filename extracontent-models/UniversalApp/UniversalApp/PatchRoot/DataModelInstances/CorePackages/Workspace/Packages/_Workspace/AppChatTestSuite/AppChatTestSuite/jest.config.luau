local ParentParent = script.Parent.Parent

return {
	testTimeout = 30000,
	projects = { require(ParentParent.AppChat)["jest.config"] }
}
