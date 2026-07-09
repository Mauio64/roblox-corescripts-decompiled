local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.PhoneUpsell)["jest.config"],
		require(ParentParent.AmpUpsell)["jest.config"],
		require(ParentParent.IdentityVerification)["jest.config"],
		require(ParentParent.InExperienceContainer)["jest.config"],
		require(ParentParent.AccountLockModal)["jest.config"]
	}
}
