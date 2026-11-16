local fFlagSduiExperienceDetailsSocialProof = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagSduiExperienceDetailsSocialProof

local v5 = {}
v5.gameDetailReferral = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameDetailReferral")
v5.gameCopyExperienceLink = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameCopyExperienceLink")
v5.gameCreatePrivateGame = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameCreatePrivateGame")
v5.gameDetailsSubpage = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameDetailsSubpage")
v5.gameFavorite = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameFavorite")
v5.gameFollow = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameFollow")
v5.gameJoinFriendsInGame = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameJoinFriendsInGame")
v5.gamePlayIntent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gamePlayIntent")
v5.gameShareExperienceLink = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameShareExperienceLink")
v5.gameVote = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameVote")
v5.invalidPlayIntent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/invalidPlayIntent")
v5.sendPlayButtonLoadingDuration = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendPlayButtonLoadingDuration")
v5.unlockPlayIntent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/unlockPlayIntent")
v5.sortDeeplinkFailureCounter = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sortDeeplinkFailureCounter")

local v6 = if fFlagSduiExperienceDetailsSocialProof then require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameConnectionsPlayedChipClicked") else nil
v5.gameConnectionsPlayedChipClicked = v6

v5.gameTileOverflowMenuAction = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameTileOverflowMenuAction")

v5.discoveryVideoEndEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/Video/discoveryVideoEndEvent")
v5.discoveryVideoLoadEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/Video/discoveryVideoLoadEvent")
v5.discoveryVideoLoopEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/Video/discoveryVideoLoopEvent")
v5.discoveryVideoPlayEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/Video/discoveryVideoPlayEvent")

v5.gameDetailsPeekViewEvents = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/gameDetailsPeekViewEvents")

v5.reportGameAttributionError = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/reportGameAttributionError")

v5.sendSocialLinkClickEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendSocialLinkClickEvent")
v5.sendSocialLinksImpressionsEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendSocialLinksImpressionsEvent")
v5.sendOpenLeavingRobloxModalEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendOpenLeavingRobloxModalEvent")
v5.sendSafetyResourceBannerEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendSafetyResourceBannerEvent")
v5.sendRequestRefundClickEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendRequestRefundClickEvent")

v5.fireInExperienceDetailsPromptOpenedEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/fireInExperienceDetailsPromptOpenedEvent")
v5.fireInExperienceDetailsPromptPlayButtonClickedEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/fireInExperienceDetailsPromptPlayButtonClickedEvent")

v5.fireInExperienceDetailsPromptClosedEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/fireInExperienceDetailsPromptClosedEvent")
v5.fireInExperienceDetailsPromptLoadedEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/fireInExperienceDetailsPromptLoadedEvent")

v5.sendMediaGalleryMediaChanged = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendMediaGalleryMediaChanged")
v5.openYouTubeVideoEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/openYouTubeVideoEvent")
v5.sendMediaGalleryFullscreenEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendMediaGalleryFullscreenEvent")

v5.sendPlayButtonContextualMessageImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/sendPlayButtonContextualMessageImpressionEvent")
v5.showMoreClickEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/showMoreClickEvent")
v5.backToTopClickEvent = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/backToTopClickEvent")
v5.openSearchResultsWithQueryDeeplink = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/openSearchResultsWithQueryDeeplink")
v5.querySuggestionClicked = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/querySuggestionClicked")

v5.aiOverviewSentiment = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/aiOverviewSentiment")
v5.aiOverviewExplicitFeedback = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/aiOverviewExplicitFeedback")
return v5
