local DataHydrationTypes = require(script.DataHydrationTypes)
local Badges = require(script.Badges)
local Game = require(script.Game)
local TrustedConnections = require(script.TrustedConnections)
local Profile = require(script.Profile)
local Presence = require(script.Presence)
local Friends = require(script.Friends)
local Creator = require(script.Creator)
local SocialLink = require(script.SocialLink)
local ExperienceEvents = require(script.ExperienceEvents)
local MediaAsset = require(script.MediaAsset)
local MarketplaceCatalogCategory = require(script.MarketplaceCatalogCategory)
local MarketplaceCatalogSort = require(script.MarketplaceCatalogSort)
local MarketplaceAsset = require(script.MarketplaceAsset)
local MarketplaceBundle = require(script.MarketplaceBundle)
local MarketplaceLook = require(script.MarketplaceLook)
local MarketplaceItemFavorite = require(script.MarketplaceItemFavorite)
local CollectibleItem = require(script.CollectibleItem)
local Song = require(script.Song)
local UserSettings = require(script.UserSettings)

local DataHydrationUtils = require(script.DataHydrationUtils)

local SharedFlags = require(script.Parent.SharedFlags)
local FFlagSduiNotificationBadgeHydration = SharedFlags.FFlagSduiNotificationBadgeHydration
local FFlagSduiLeaderboardComponent = SharedFlags.FFlagSduiLeaderboardComponent
local FFlagSduiBuyRobuxHydration = SharedFlags.FFlagSduiBuyRobuxHydration

local UserProfile = require(script.UserProfile)
local Community = require(script.Community)
local CommunityUserMembership = require(script.CommunityUserMembership)
local NotificationBadge = require(script.NotificationBadge)
local LeaderboardStats = require(script.LeaderboardStats)
local BuyRobux = require(script.BuyRobux)

local DataHydration = {
	["jest.config"] = script["jest.config"],
	createDataResolver = require(script.createDataResolver),
	createDataCache = require(script.createDataCache),
	createMutationLayer = require(script.createMutationLayer),
	DataHydrationTypes = DataHydrationTypes,
	DataHydrationUtils = DataHydrationUtils,
	DataStatus = DataHydrationTypes.DataStatus,
	Badges = Badges,
	Game = Game,
	Creator = Creator,
	MediaAsset = MediaAsset,
	MarketplaceCatalogCategory = MarketplaceCatalogCategory,
	MarketplaceCatalogSort = MarketplaceCatalogSort,
	SocialLink = SocialLink,
	ExperienceEvents = ExperienceEvents,
	TrustedConnections = TrustedConnections,
	Profile = Profile,
	Presence = Presence,
	Friends = Friends,
	MarketplaceAsset = MarketplaceAsset,
	MarketplaceBundle = MarketplaceBundle,
	MarketplaceLook = MarketplaceLook,
	MarketplaceItemFavorite = MarketplaceItemFavorite,
	CollectibleItem = CollectibleItem,
	Song = Song,
	UserSettings = UserSettings,
	UserProfile = UserProfile,
	Community = Community,
	CommunityUserMembership = CommunityUserMembership
}

if not FFlagSduiNotificationBadgeHydration then
	NotificationBadge = nil
end

DataHydration.NotificationBadge = NotificationBadge

if not FFlagSduiLeaderboardComponent then
	LeaderboardStats = nil
end

DataHydration.LeaderboardStats = LeaderboardStats

if not FFlagSduiBuyRobuxHydration then
	BuyRobux = nil
end

DataHydration.BuyRobux = BuyRobux
return DataHydration
