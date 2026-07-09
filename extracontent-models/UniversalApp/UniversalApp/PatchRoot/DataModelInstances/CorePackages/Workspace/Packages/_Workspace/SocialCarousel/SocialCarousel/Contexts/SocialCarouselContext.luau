local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)

require(SocialCarousel.Analytics.AnalyticsTypes)

return React.createContext({
	hideCarouselHeader = false,
	openGameJoinCardUserId = nil,
	setOpenGameJoinCardUserId = nil,
	unifiedLogging = nil,
	sortAnalyticsData = nil,
	friendRequestCount = 0,
	friendCount = 0,
	recommendationCount = 0,
	selectionOrderBase = nil,
	source = nil,
	navigateToQRCodePage = nil,
	isLoading = false,
	eventIngest = function() -- line: 32
	end,
	appAnalytics = function() -- line: 33
	end,
	tiles = {},
	onSuccessfulRender = function() -- line: 43
	end
})
