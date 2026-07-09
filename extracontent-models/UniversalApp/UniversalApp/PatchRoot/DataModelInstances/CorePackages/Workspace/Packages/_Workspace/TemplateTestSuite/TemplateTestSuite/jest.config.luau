local ParentParent = script.Parent.Parent

return {
	projects = { require(ParentParent.TemplatePackage)["jest.config"] }
}
