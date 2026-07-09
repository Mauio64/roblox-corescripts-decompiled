local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.PasskeyUpsell)["jest.config"],
		require(ParentParent.AuthCommon)["jest.config"],
		require(ParentParent.AccountSwitching)["jest.config"],
		require(ParentParent.PreHomePage)["jest.config"],
		require(ParentParent.PlatformRestricted)["jest.config"]
	}
}
