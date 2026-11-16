local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiDataBinderTransformUtils = require(SduiCoreSystem.ClientBinding.SduiDataBinderTransformUtils)

local snakeToCamel = SduiDataBinderTransformUtils.snakeToCamel
local protobufTimestampToLocalTimeString = SduiDataBinderTransformUtils.protobufTimestampToLocalTimeString

local v = {
	DataStatus = { Ready = "Ready", NotReady = "NotReady", Failed = "Failed" }
}
local CreateDataHydrationMock = {}

function CreateDataHydrationMock.createDataHydrationMock(data)
	local extraFields = {
		Badges = data and data.Badges or {
			getBadgeInfoStore = function()
				return {
					getBadgeInfo = function()
						return {
							data = function(): nil
								return nil
							end,
							status = function(): string
								return "NotReady"
							end
						}
					end,
					getBadgeInfos = function()
						return {}
					end,
					clear = function() end,
					dispose = function() end
				}
			end
		},
		Game = 0,
		SocialLink = 0,
		MarketplaceCatalogCategory = 0,
		MarketplaceCatalogSort = 0,
		Song = 0,
		MarketplaceAsset = 0,
		MarketplaceBundle = 0,
		MarketplaceLook = 0,
		MarketplaceItemFavorite = 0,
		CollectibleItem = 0,
		MediaAsset = 0,
		UserProfile = 0,
		Community = 0,
		CommunityUserMembership = 0,
		NotificationBadge = 0,
		LeaderboardStats = 0,
		BuyRobux = 0,
		DataHydrationTypes = 0
	}
	local Game

	if data then
		Game = data.Game or nil
	end

	extraFields.Game = Game
	local socialLink

	if data then
		socialLink = data.SocialLink or nil
	end

	extraFields.SocialLink = socialLink
	extraFields.MarketplaceCatalogCategory = data and data.MarketplaceCatalogCategory or {
		getMarketplaceCatalogCategoryStore = function()
			return {
				getMarketplaceCatalogCategory = function()
					return {
						data = function(): nil
							return nil
						end,
						status = function(): string
							return "NotReady"
						end
					}
				end,
				getMarketplaceCatalogCategories = function()
					return {}
				end,
				updateMarketplaceCatalogCategories = function() end,
				updateMarketplaceCatalogCategory = function() end,
				clear = function() end,
				dispose = function() end
			}
		end
	}

	extraFields.MarketplaceCatalogSort = data and data.MarketplaceCatalogSort or {
		getMarketplaceCatalogSortStore = function()
			return {
				getMarketplaceCatalogSort = function()
					return {
						data = function(): nil
							return nil
						end,
						status = function(): string
							return "NotReady"
						end
					}
				end,
				getMarketplaceCatalogSorts = function()
					return {}
				end,
				updateMarketplaceCatalogSorts = function() end,
				updateMarketplaceCatalogSort = function() end,
				clear = function() end,
				dispose = function() end
			}
		end
	}
	local song

	if data then
		song = data.Song or nil
	end

	extraFields.Song = song
	local marketplaceAsset

	if data then
		marketplaceAsset = data.MarketplaceAsset or nil
	end

	extraFields.MarketplaceAsset = marketplaceAsset
	local marketplaceBundle

	if data then
		marketplaceBundle = data.MarketplaceBundle or nil
	end

	extraFields.MarketplaceBundle = marketplaceBundle
	local marketplaceLook

	if data then
		marketplaceLook = data.MarketplaceLook or nil
	end

	extraFields.MarketplaceLook = marketplaceLook
	local marketplaceItemFavorite

	if data then
		marketplaceItemFavorite = data.MarketplaceItemFavorite or nil
	end

	extraFields.MarketplaceItemFavorite = marketplaceItemFavorite
	local collectibleItem

	if data then
		collectibleItem = data.CollectibleItem or nil
	end

	extraFields.CollectibleItem = collectibleItem
	local mediaAsset

	if data then
		mediaAsset = data.MediaAsset or nil
	end

	extraFields.MediaAsset = mediaAsset
	local userProfile

	if data then
		userProfile = data.UserProfile or nil
	end

	extraFields.UserProfile = userProfile
	local community

	if data then
		community = data.Community or nil
	end

	extraFields.Community = community
	local communityUserMembership

	if data then
		communityUserMembership = data.CommunityUserMembership or nil
	end

	extraFields.CommunityUserMembership = communityUserMembership
	local notificationBadge

	if data then
		notificationBadge = data.NotificationBadge or nil
	end

	extraFields.NotificationBadge = notificationBadge
	local leaderboardStats

	if data then
		leaderboardStats = data.LeaderboardStats or nil
	end

	extraFields.LeaderboardStats = leaderboardStats
	local buyRobux

	if data then
		buyRobux = data.BuyRobux or nil
	end

	extraFields.BuyRobux = buyRobux
	extraFields.DataHydrationTypes = v

	if data and data.extraFields then
		for k, extraField in data.extraFields do
			extraFields[k] = extraField
		end
	end

	return extraFields
end

function CreateDataHydrationMock.createSduiDataBinderTransformUtilsMock()
	return {
		snakeToCamel = snakeToCamel,
		protobufTimestampToLocalTimeString = protobufTimestampToLocalTimeString
	}
end

CreateDataHydrationMock.snakeToCamel = snakeToCamel
CreateDataHydrationMock.protobufTimestampToLocalTimeString = protobufTimestampToLocalTimeString
CreateDataHydrationMock.DataHydrationTypesMock = v
return CreateDataHydrationMock
