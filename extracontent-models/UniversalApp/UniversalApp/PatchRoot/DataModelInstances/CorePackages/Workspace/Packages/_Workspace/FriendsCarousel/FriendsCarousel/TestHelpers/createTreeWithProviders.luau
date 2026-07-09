local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local FriendsCarouselParent = FriendsCarousel.Parent
local React = require(FriendsCarouselParent.React)
local TestHelpers = require(FriendsCarouselParent.Dev.SocialTestHelpers).TestHelpers
local mockAnalytics = require(script.Parent.mockAnalytics)
local Analytics = require(FriendsCarousel.Analytics)

return function(p1, p2) -- line: 10
	-- upvalues: mockAnalytics (copy), React (copy), Analytics (copy), TestHelpers (copy)
	local v9 = p2.mockAnalytics or mockAnalytics()

	return React.createElement(Analytics.Context.Provider, {
		value = v9.value
	}, { TestHelpers.createTreeWithProviders(p1, p2) }), v9
end
