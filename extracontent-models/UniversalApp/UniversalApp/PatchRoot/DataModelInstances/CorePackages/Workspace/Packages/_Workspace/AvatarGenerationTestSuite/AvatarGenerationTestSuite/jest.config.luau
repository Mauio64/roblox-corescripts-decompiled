local ParentParent = script.Parent.Parent

return {
	projects = { require(ParentParent.SelfieConsent)["jest.config"] }
}
