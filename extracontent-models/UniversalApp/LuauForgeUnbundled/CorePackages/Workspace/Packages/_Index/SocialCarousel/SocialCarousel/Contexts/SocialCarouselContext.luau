local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")

require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/AnalyticsTypes")

return React.createContext({
	eventIngest = function() end,
	appAnalytics = function() end,
	hideCarouselHeader = false,
	openGameJoinCardUserId = nil,
	setOpenGameJoinCardUserId = nil,
	openBuildCardUserId = nil,
	setOpenBuildCardUserId = nil,
	unifiedLogging = nil,
	sortAnalyticsData = nil,
	tiles = {},
	friendRequestCount = 0,
	friendCount = 0,
	recommendationCount = 0,
	onSuccessfulRender = function() end,
	selectionOrderBase = nil,
	source = nil,
	navigateToQRCodePage = nil,
	isLoading = false
})
