local isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/SharedFlags").isSubjectToDesktopPolicies

local module = require("@luauforge/bundled/dDZ")
local sduiOmniFeedItem = module.SduiOmniFeedItem
local sduiV2OmniFeedItem = module.SduiV2OmniFeedItem
local omniFeedTypes = require("@luauforge/bundled/cBc").OmniFeedTypes
local modules = require("@luauforge/bundled/dtb").Modules
local gameCarouselFeedItem = modules.Personalization.OmniFeed.FeedItems.GameCarouselFeedItem
local songCarouselFeedItem = modules.Personalization.OmniFeed.FeedItems.SongCarouselFeedItem
local homeGameGridFlexFeedItem = modules.Personalization.OmniFeed.FeedItems.HomeGameGridFlexFeedItem
local searchGameGridFeedItem = modules.Personalization.OmniFeed.FeedItems.SearchGameGridFeedItem
local searchTextFeedItem = modules.Personalization.OmniFeed.FeedItems.SearchTextFeedItem
local gameFiltersFeedItem = modules.Personalization.OmniFeed.FeedItems.GameFiltersFeedItem

local module2 = require("@luauforge/bundled/iqp")

local module3 = require("@luauforge/bundled/iqq")
local module4 = require("@luauforge/bundled/iqs")

local module5 = require("@luauforge/bundled/iqz")
local module6 = require("@luauforge/bundled/iqC")
local module7 = require("@luauforge/bundled/iqE")
local module8 = require("@luauforge/bundled/iqK")
local module9 = require("@luauforge/bundled/iqN")

local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableTopSongsSort

local fFlagHomePagePromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagHomePagePromptsHandlerEnabled

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local function fn(p2)
	if p2 == omniFeedTypes.Carousel then
		return gameCarouselFeedItem
	end

	if fFlagEnableTopSongsSort and p2 == omniFeedTypes.SongCarousel then
		return songCarouselFeedItem
	end

	if p2 == omniFeedTypes.UserInfo then
		if (isSubjectToDesktopPolicies() or isVRAppBuild()) and not _G.__TESTEZ_RUNNING_TEST__ then
			return nil
		end

		return module2
	end

	if p2 == omniFeedTypes.JoinYourFriendsCarousel then
		return module4
	end

	if p2 == omniFeedTypes.FriendCarousel then
		return module3
	end

	if p2 == omniFeedTypes.AvatarCarousel then
		warn("AvatarCarousel is not currently supported on the client")
		return nil
	end

	if p2 == omniFeedTypes.ServerDrivenUi then
		return sduiOmniFeedItem
	end

	if p2 == omniFeedTypes.ServerDrivenUiV2 then
		return sduiV2OmniFeedItem
	end

	if p2 == omniFeedTypes.FriendRecommendationCarousel then
		return module5
	end

	if p2 == omniFeedTypes.HomeGameGrid then
		return homeGameGridFlexFeedItem
	end

	if p2 == omniFeedTypes.GenreExplorer then
		warn("GenreExplorer is not currently supported on the client")
		return nil
	end

	if p2 == omniFeedTypes.SearchGameGrid then
		return searchGameGridFeedItem
	end

	if p2 == omniFeedTypes.SearchText then
		return searchTextFeedItem
	end

	if p2 == omniFeedTypes.UpsellCard then
		return module7
	end

	if fFlagHomePagePromptsHandlerEnabled and p2 == omniFeedTypes.Prompts then
		return module9
	end

	if p2 == omniFeedTypes.UserSearchGrid then
		return module6
	end

	if p2 == omniFeedTypes.Pills then
		return gameFiltersFeedItem
	end

	if p2 == omniFeedTypes.SearchPillCarousel then
		return module8
	end

	warn("Unmapped omni feed item type: " .. tostring(p2))

	return nil
end

return {
	getComponent = fn,
	hasComponent = function(p2): boolean
		return fn(p2) ~= nil
	end
}
