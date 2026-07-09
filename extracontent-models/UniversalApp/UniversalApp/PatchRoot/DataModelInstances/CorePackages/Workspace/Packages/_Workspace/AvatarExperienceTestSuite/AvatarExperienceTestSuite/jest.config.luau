local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.AvatarExperienceCommon)["jest.config"],
		require(ParentParent.AvatarExperienceTimedOptions)["jest.config"],
		require(ParentParent.AvatarExperienceHeadRefinement)["jest.config"],
		require(ParentParent.AvatarExperienceInitialization)["jest.config"],
		require(ParentParent.AvatarExperienceNavigation)["jest.config"],
		require(ParentParent.AvatarExperienceSearch)["jest.config"],
		require(ParentParent.AvatarExperienceSlotBasedEditor)["jest.config"],
		require(ParentParent.AvatarExperienceCatalog)["jest.config"],
		require(ParentParent.AvatarExperienceControlBar)["jest.config"],
		require(ParentParent.AvatarExperienceSave)["jest.config"],
		require(ParentParent.AvatarExperienceAnalytics)["jest.config"],
		require(ParentParent.AvatarExperienceInspectAndBuy)["jest.config"],
		require(ParentParent.AvatarExperienceUIKit)["jest.config"],
		require(ParentParent.AvatarExperienceServerDrivenUi)["jest.config"],
		require(ParentParent.AvatarExperienceRodux)["jest.config"],
		require(ParentParent.AvatarExperiencePhotobooth)["jest.config"],
		require(ParentParent.AvatarExperienceTTIPerformance)["jest.config"],
		require(ParentParent.AvatarExperienceFavoritesManager)["jest.config"]
	}
}
