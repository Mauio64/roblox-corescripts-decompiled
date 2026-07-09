_G.__TESTEZ_RUNNING_TEST__ = true

local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.AppLaunchTracker)["jest.config"],
		require(ParentParent.CollectionViews)["jest.config"],
		require(ParentParent.DetailsPageComponents)["jest.config"],
		require(ParentParent.Badges)["jest.config"],
		require(ParentParent.DevStore)["jest.config"],
		require(ParentParent.DiscoveryAnalytics)["jest.config"],
		require(ParentParent.DiscoveryHeroUnit)["jest.config"],
		require(ParentParent.DiscoveryMonolith)["jest.config"],
		require(ParentParent.DiscoveryRouting)["jest.config"],
		require(ParentParent.DiscoveryTypes)["jest.config"],
		require(ParentParent.DiscoveryUtils)["jest.config"],
		require(ParentParent.FetchStatusRodux)["jest.config"],
		require(ParentParent.GameCollections)["jest.config"],
		require(ParentParent.GameDetail)["jest.config"],
		require(ParentParent.GameDetailRodux)["jest.config"],
		require(ParentParent.GameFilters)["jest.config"],
		require(ParentParent.GameIconRodux)["jest.config"],
		require(ParentParent.GameInfosRodux)["jest.config"],
		require(ParentParent.GameLaunch)["jest.config"],
		require(ParentParent.GameModels)["jest.config"],
		require(ParentParent.GamePlayButton)["jest.config"],
		require(ParentParent.GameProductInfoRodux)["jest.config"],
		require(ParentParent.GameTile)["jest.config"],
		require(ParentParent.GameVotesRodux)["jest.config"],
		require(ParentParent.MediaGallery)["jest.config"],
		require(ParentParent.NextDataExpirationTimeRodux)["jest.config"],
		require(ParentParent.OmniFeedService)["jest.config"],
		require(ParentParent.PlayabilityRodux)["jest.config"],
		require(ParentParent.ScrollTelemetry)["jest.config"],
		require(ParentParent.SduiLandingPage)["jest.config"],
		require(ParentParent.SearchResults)["jest.config"],
		require(ParentParent.ServerDrivenUi)["jest.config"],
		require(ParentParent.SocialContextToasts)["jest.config"],
		require(ParentParent.TopicContentsRodux)["jest.config"],
		require(ParentParent.TopicInfosRodux)["jest.config"],
		require(ParentParent.UnifiedLogging)["jest.config"],
		require(ParentParent.UserSignals)["jest.config"],
		require(ParentParent.VariableItemWidthCarousel)["jest.config"],
		require(ParentParent.VideoUtils)["jest.config"]
	}
}
