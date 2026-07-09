local ParentParent = script.Parent.Parent

return {
	projects = { require(ParentParent.VideoServerScreen)["jest.config"] }
}
