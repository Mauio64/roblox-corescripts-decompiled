local ParentParent = script.Parent.Parent

return {
	projects = { require(ParentParent.InExperienceTopBar)["jest.config"] }
}
