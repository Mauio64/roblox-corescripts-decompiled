local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.AvatarSwitcher)["jest.config"],
		require(ParentParent.CurrencyTransfers)["jest.config"],
		require(ParentParent.InExperienceShop)["jest.main.config"],
		require(ParentParent.InExperienceShop)["jest.mockDataModel.config"]
	}
}
