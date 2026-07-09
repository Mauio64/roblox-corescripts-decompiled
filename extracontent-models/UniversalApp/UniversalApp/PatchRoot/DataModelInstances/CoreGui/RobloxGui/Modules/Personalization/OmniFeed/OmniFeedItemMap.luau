local CorePackages = game:GetService("CorePackages")
local isSubjectToDesktopPolicies = require(CorePackages.Workspace.Packages.SharedFlags).isSubjectToDesktopPolicies
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local SduiOmniFeedItem = ServerDrivenUi.SduiOmniFeedItem
local SduiV2OmniFeedItem = ServerDrivenUi.SduiV2OmniFeedItem
local OmniFeedTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedTypes
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local GameCarouselFeedItem = Modules.Personalization.OmniFeed.FeedItems.GameCarouselFeedItem
local SongCarouselFeedItem = Modules.Personalization.OmniFeed.FeedItems.SongCarouselFeedItem
local HomeGameGridFlexFeedItem = Modules.Personalization.OmniFeed.FeedItems.HomeGameGridFlexFeedItem
local SearchGameGridFeedItem = Modules.Personalization.OmniFeed.FeedItems.SearchGameGridFeedItem
local SearchTextFeedItem = Modules.Personalization.OmniFeed.FeedItems.SearchTextFeedItem
local GameFiltersFeedItem = Modules.Personalization.OmniFeed.FeedItems.GameFiltersFeedItem
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local UserInfoFeedItem = require(Modules2.Personalization.OmniFeed.FeedItems.UserInfoFeedItem)
local FriendCarouselFeedItem = require(Modules2.Personalization.OmniFeed.FeedItems.FriendCarouselFeedItem.FriendCarouselFeedItem)
local JoinYourFriendsFeedItem = require(Modules2.Personalization.OmniFeed.FeedItems.JoinYourFriendsFeedItem)
local FriendRecommendationCarouselFeedItem = require(Modules2.Personalization.OmniFeed.FeedItems.FriendRecommendationCarouselFeedItem)
local UserSearchGridFeedItem = require(Modules2.Personalization.OmniFeed.FeedItems.UserSearchGridFeedItem)
local UpsellCardFeedItem = require(Modules2.Personalization.OmniFeed.FeedItems.UpsellCardFeedItem)
local SearchPillCarouselFeedItem = require(Modules2.Personalization.OmniFeed.FeedItems.SearchPillCarouselFeedItem)
local PromptsFeedItem = require(Modules2.Personalization.OmniFeed.FeedItems.PromptsFeedItem)
local FFlagSearchOmniAutocompletePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchOmniAutocompletePage
local FFlagEnableTopSongsSort = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableTopSongsSort
local FFlagHomePagePromptsHandlerEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagHomePagePromptsHandlerEnabled
local FFlagEnableSduiV2HomeInterleave = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSduiV2HomeInterleave
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild

local function v28(p1) -- line: 39
	-- upvalues: OmniFeedTypes (copy), GameCarouselFeedItem (copy), FFlagEnableTopSongsSort (copy), SongCarouselFeedItem (copy), isSubjectToDesktopPolicies (copy), IsVRAppBuild (copy), UserInfoFeedItem (copy), JoinYourFriendsFeedItem (copy), FriendCarouselFeedItem (copy), SduiOmniFeedItem (copy), FFlagEnableSduiV2HomeInterleave (copy), SduiV2OmniFeedItem (copy), FriendRecommendationCarouselFeedItem (copy), HomeGameGridFlexFeedItem (copy), SearchGameGridFeedItem (copy), SearchTextFeedItem (copy), UpsellCardFeedItem (copy), FFlagHomePagePromptsHandlerEnabled (copy), PromptsFeedItem (copy), UserSearchGridFeedItem (copy), GameFiltersFeedItem (copy), FFlagSearchOmniAutocompletePage (copy), SearchPillCarouselFeedItem (copy)
	if p1 == OmniFeedTypes.Carousel then
		return GameCarouselFeedItem
	end

	if FFlagEnableTopSongsSort and p1 == OmniFeedTypes.SongCarousel then
		return SongCarouselFeedItem
	end

	if p1 == OmniFeedTypes.UserInfo then
		if (isSubjectToDesktopPolicies() or IsVRAppBuild()) and not _G.__TESTEZ_RUNNING_TEST__ then
			return nil
		end

		return UserInfoFeedItem
	end

	if p1 == OmniFeedTypes.JoinYourFriendsCarousel then
		return JoinYourFriendsFeedItem
	end

	if p1 == OmniFeedTypes.FriendCarousel then
		return FriendCarouselFeedItem
	end

	if p1 == OmniFeedTypes.AvatarCarousel then
		warn("AvatarCarousel is not currently supported on the client")

		return nil
	end

	if p1 == OmniFeedTypes.ServerDrivenUi then
		return SduiOmniFeedItem
	end

	if FFlagEnableSduiV2HomeInterleave and p1 == OmniFeedTypes.ServerDrivenUiV2 then
		return SduiV2OmniFeedItem
	end

	if p1 == OmniFeedTypes.FriendRecommendationCarousel then
		return FriendRecommendationCarouselFeedItem
	end

	if p1 == OmniFeedTypes.HomeGameGrid then
		return HomeGameGridFlexFeedItem
	end

	if p1 == OmniFeedTypes.GenreExplorer then
		warn("GenreExplorer is not currently supported on the client")

		return nil
	end

	if p1 == OmniFeedTypes.SearchGameGrid then
		return SearchGameGridFeedItem
	end

	if p1 == OmniFeedTypes.SearchText then
		return SearchTextFeedItem
	end

	if p1 == OmniFeedTypes.UpsellCard then
		return UpsellCardFeedItem
	end

	if FFlagHomePagePromptsHandlerEnabled and p1 == OmniFeedTypes.Prompts then
		return PromptsFeedItem
	end

	if p1 == OmniFeedTypes.UserSearchGrid then
		return UserSearchGridFeedItem
	end

	if p1 == OmniFeedTypes.Pills then
		return GameFiltersFeedItem
	end

	if FFlagSearchOmniAutocompletePage and p1 == OmniFeedTypes.SearchPillCarousel then
		return SearchPillCarouselFeedItem
	end

	warn("Unmapped omni feed item type: " .. tostring(p1))

	return nil
end

return {
	getComponent = v28,
	hasComponent = function(p2) -- line: 91
		-- upvalues: v28 (copy)
		return v28(p2) ~= nil
	end
}
