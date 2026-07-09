local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.ScreenTime)["jest.config"],
		require(ParentParent.SettingsTabVisibility)["jest.config"],
		require(ParentParent.VerifiedParentalConsentDialog)["jest.config"],
		require(ParentParent.LegallySensitiveContent)["jest.config"]
	}
}
