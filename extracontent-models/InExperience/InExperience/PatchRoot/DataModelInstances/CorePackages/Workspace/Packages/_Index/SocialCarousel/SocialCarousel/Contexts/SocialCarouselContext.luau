local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)

require(SocialCarousel.Analytics.AnalyticsTypes)

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
