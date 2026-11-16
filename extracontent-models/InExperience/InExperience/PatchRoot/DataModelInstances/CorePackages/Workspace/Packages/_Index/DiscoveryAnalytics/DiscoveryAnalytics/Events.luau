local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiExperienceDetailsSocialProof = SharedFlags.FFlagSduiExperienceDetailsSocialProof

local Events = {}
Events.gameDetailReferral = require(script.gameDetailReferral)
Events.gameCopyExperienceLink = require(script.gameCopyExperienceLink)
Events.gameCreatePrivateGame = require(script.gameCreatePrivateGame)
Events.gameDetailsSubpage = require(script.gameDetailsSubpage)
Events.gameFavorite = require(script.gameFavorite)
Events.gameFollow = require(script.gameFollow)
Events.gameJoinFriendsInGame = require(script.gameJoinFriendsInGame)
Events.gamePlayIntent = require(script.gamePlayIntent)
Events.gameShareExperienceLink = require(script.gameShareExperienceLink)
Events.gameVote = require(script.gameVote)
Events.invalidPlayIntent = require(script.invalidPlayIntent)
Events.sendPlayButtonLoadingDuration = require(script.sendPlayButtonLoadingDuration)
Events.unlockPlayIntent = require(script.unlockPlayIntent)
Events.sortDeeplinkFailureCounter = require(script.sortDeeplinkFailureCounter)
local gameConnectionsPlayedChipClicked

if FFlagSduiExperienceDetailsSocialProof then
	gameConnectionsPlayedChipClicked = require(script.gameConnectionsPlayedChipClicked)
end

Events.gameConnectionsPlayedChipClicked = gameConnectionsPlayedChipClicked

Events.gameTileOverflowMenuAction = require(script.gameTileOverflowMenuAction)

Events.discoveryVideoEndEvent = require(script.Video.discoveryVideoEndEvent)
Events.discoveryVideoLoadEvent = require(script.Video.discoveryVideoLoadEvent)
Events.discoveryVideoLoopEvent = require(script.Video.discoveryVideoLoopEvent)
Events.discoveryVideoPlayEvent = require(script.Video.discoveryVideoPlayEvent)

Events.gameDetailsPeekViewEvents = require(script.gameDetailsPeekViewEvents)

Events.reportGameAttributionError = require(script.reportGameAttributionError)

Events.sendSocialLinkClickEvent = require(script.sendSocialLinkClickEvent)
Events.sendSocialLinksImpressionsEvent = require(script.sendSocialLinksImpressionsEvent)
Events.sendOpenLeavingRobloxModalEvent = require(script.sendOpenLeavingRobloxModalEvent)
Events.sendSafetyResourceBannerEvent = require(script.sendSafetyResourceBannerEvent)
Events.sendRequestRefundClickEvent = require(script.sendRequestRefundClickEvent)

Events.fireInExperienceDetailsPromptOpenedEvent = require(script.fireInExperienceDetailsPromptOpenedEvent)
Events.fireInExperienceDetailsPromptPlayButtonClickedEvent = require(script.fireInExperienceDetailsPromptPlayButtonClickedEvent)

Events.fireInExperienceDetailsPromptClosedEvent = require(script.fireInExperienceDetailsPromptClosedEvent)
Events.fireInExperienceDetailsPromptLoadedEvent = require(script.fireInExperienceDetailsPromptLoadedEvent)

Events.sendMediaGalleryMediaChanged = require(script.sendMediaGalleryMediaChanged)
Events.openYouTubeVideoEvent = require(script.openYouTubeVideoEvent)
Events.sendMediaGalleryFullscreenEvent = require(script.sendMediaGalleryFullscreenEvent)

Events.sendPlayButtonContextualMessageImpressionEvent = require(script.sendPlayButtonContextualMessageImpressionEvent)
Events.showMoreClickEvent = require(script.showMoreClickEvent)
Events.backToTopClickEvent = require(script.backToTopClickEvent)
Events.openSearchResultsWithQueryDeeplink = require(script.openSearchResultsWithQueryDeeplink)
Events.querySuggestionClicked = require(script.querySuggestionClicked)

Events.aiOverviewSentiment = require(script.aiOverviewSentiment)
Events.aiOverviewExplicitFeedback = require(script.aiOverviewExplicitFeedback)
return Events
