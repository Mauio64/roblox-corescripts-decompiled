local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Badges")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Creator")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/SocialLink")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceEvents")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MediaAsset")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceCatalogCategory")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceCatalogSort")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceAsset")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceBundle")
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceLook")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite")
local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CollectibleItem")
local module19 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Song")
local module20 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UserSettings")

local module21 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local fFlagSduiNotificationBadgeHydration = SharedFlags.FFlagSduiNotificationBadgeHydration
local fFlagSduiLeaderboardComponent = SharedFlags.FFlagSduiLeaderboardComponent
local fFlagSduiBuyRobuxHydration = SharedFlags.FFlagSduiBuyRobuxHydration

local module23 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UserProfile")
local module24 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Community")
local module25 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CommunityUserMembership")
local module26 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/NotificationBadge")
local module27 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/LeaderboardStats")
local module28 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/BuyRobux")

local v5 = {
	createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver"),
	createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache"),
	createMutationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createMutationLayer"),
	DataHydrationTypes = module,
	DataHydrationUtils = module21,
	DataStatus = module.DataStatus,
	Badges = module2,
	Game = module3,
	Creator = module8,
	MediaAsset = module11,
	MarketplaceCatalogCategory = module12,
	MarketplaceCatalogSort = module13,
	SocialLink = module9,
	ExperienceEvents = module10,
	TrustedConnections = module4,
	Profile = module5,
	Presence = module6,
	Friends = module7,
	MarketplaceAsset = module14,
	MarketplaceBundle = module15,
	MarketplaceLook = module16,
	MarketplaceItemFavorite = module17,
	CollectibleItem = module18,
	Song = module19,
	UserSettings = module20,
	UserProfile = module23,
	Community = module24,
	CommunityUserMembership = module25,
	NotificationBadge = 0,
	LeaderboardStats = 0,
	BuyRobux = 0
}

if not fFlagSduiNotificationBadgeHydration then
	module26 = nil
end

v5.NotificationBadge = module26

if not fFlagSduiLeaderboardComponent then
	module27 = nil
end

v5.LeaderboardStats = module27

if not fFlagSduiBuyRobuxHydration then
	module28 = nil
end

v5.BuyRobux = module28
return v5
