local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Display")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Responsive")
local sduiDataBindingResponsiveFieldName = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingFieldNames").SduiDataBindingResponsiveFieldName

local tryGetPathFromData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/tryGetPathFromData")
local SduiDataBindingContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")
local SduiDataBinderTransformUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBinderTransformUtils")
local getZendeskUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/DiscoveryUtils").getZendeskUrl
local getSduiPolicyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/getSduiPolicyStore")
local resolveSduiPolicyField = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/resolveSduiPolicyField")
local getSduiServiceDependenciesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/getSduiServiceDependenciesStore")
local getSduiClientPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/getSduiClientPageScope")
local SduiCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiCapabilities")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags")
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagSduiCommunitySectionSupport = SharedFlags.FFlagSduiCommunitySectionSupport
local fFlagLuaAppEdpKeepFullPageOnPortraitRotation = SharedFlags.FFlagLuaAppEdpKeepFullPageOnPortraitRotation
local fFlagSduiMarketplaceCatalogCategorySupport = SharedFlags.FFlagSduiMarketplaceCatalogCategorySupport
local fFlagSduiMarketplaceCatalogSortSupport = SharedFlags.FFlagSduiMarketplaceCatalogSortSupport
local fFlagSduiAddMarketplaceEntityDataHydration = SharedFlags.FFlagSduiAddMarketplaceEntityDataHydration
local fFlagSduiAddCollectibleItemDataHydration = SharedFlags.FFlagSduiAddCollectibleItemDataHydration
local fFlagSduiLeaderboardComponent = SharedFlags.FFlagSduiLeaderboardComponent
local fFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local fFlagSduiCapabilityBindings = SharedFlags.FFlagSduiCapabilityBindings
local fFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local fFlagSduiSupportRatingNoPercent = SharedFlags.FFlagSduiSupportRatingNoPercent
local fFlagSduiNotificationBadgeHydration = SharedFlags.FFlagSduiNotificationBadgeHydration

local FFlagSduiAddMarketplaceItemFavoriteHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/FFlagSduiAddMarketplaceItemFavoriteHydration")
local fFlagSduiBuyRobuxHydration = SharedFlags.FFlagSduiBuyRobuxHydration

local dataStatus = DataHydration.DataHydrationTypes.DataStatus

local protobufTimestampToLocalTimeString = SduiDataBinderTransformUtils.protobufTimestampToLocalTimeString

local function updateBadgesInfoStore(p2)
	DataHydration.Badges.getBadgeInfoStore(false).updateBadges(p2)
end

local function updateCreatorInfoStore(p2)
	DataHydration.Creator.getCreatorInfoStore(false).updateCreatorInfos(p2)
end

local function updateGameInfos(p2)
	if fFlagMigrateGameInfoToStore then
		DataHydration.Game.getGameInfoStore(false).updateGameInfos(p2, false)
	else
		DataHydration.Game.getGameInfoStore(false).updateGameInfos(p2)
	end
end

local function updateAgeRecommendations(p2)
	DataHydration.Game.getAgeRecommendationStore(false).updateAgeRecommendations(p2)
end

local function updateSocialLinkInfos(p2)
	DataHydration.SocialLink.getSocialLinkInfoStore(false).updateSocialLinkInfos(p2)
end

local function updateMediaAssetStore(p2)
	DataHydration.MediaAsset.getMediaAssetStore(false).updateMediaAssets(p2)
end

local function updateExperienceEventInfoStore(p2)
	DataHydration.ExperienceEvents.getExperienceEventInfoStore(false).updateExperienceEventInfos(p2)
end

local function updateMarketplaceCatalogCategoryStore(p2)
	DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).updateMarketplaceCatalogCategories(p2)
end

local function updateMarketplaceCatalogSortStore(p2)
	DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).updateMarketplaceCatalogSorts(p2)
end

local function updateMarketplaceAssetInfoStore(p2)
	DataHydration.MarketplaceAsset.getMarketplaceAssetStore(false).updateMarketplaceAssetInfos(p2)
end

local function updateMarketplaceBundleInfoStore(p2)
	DataHydration.MarketplaceBundle.getMarketplaceBundleStore(false).updateMarketplaceBundleInfos(p2)
end

local function updateMarketplaceLookInfoStore(p2)
	DataHydration.MarketplaceLook.getMarketplaceLookStore(false).updateMarketplaceLookInfos(p2)
end

local function updateMarketplaceAssetFavoriteStore(p2)
	DataHydration.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false).updateItems(p2)
end

local function updateMarketplaceBundleFavoriteStore(p2)
	DataHydration.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false).updateItems(p2)
end

local function updateCollectibleItemInfoStore(p2)
	DataHydration.CollectibleItem.getCollectibleItemStore(false).updateCollectibleItemInfos(p2)
end

local function updateLeaderboardStatsStore(p2)
	DataHydration.LeaderboardStats.getLeaderboardStatsStore(false).updateLeaderboardStatsBatch(p2)
end

local function updateGamePassStore(p2)
	DataHydration.Game.getGamePassStore(false).updateGamePassInfos(p2)
end

local function updatePlayabilityStore(p2)
	DataHydration.Game.getPlayabilityStore(false).updatePlayabilities(p2)
end

local function updateGameDeveloperProductStore(p2)
	DataHydration.Game.getGameDeveloperProductStore(false).updateGameDeveloperProductInfos(p2)
end

local function updateGameSubscriptionStore(p2)
	DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfos(p2)
end

local function updateNotificationBadgeStore(p2)
	DataHydration.NotificationBadge.getNotificationBadgeStore(false).updateNotificationBadges(p2)
end

local function updateBuyRobuxStores(data)
	local buyRobux = DataHydration.BuyRobux

	if data.buyRobuxOneTimeProduct then
		buyRobux.getOneTimeProductStore(false).updateInfos(data.buyRobuxOneTimeProduct)
	end

	if data.buyRobuxSubscriptionProduct then
		buyRobux.getSubscriptionProductStore(false).updateInfos(data.buyRobuxSubscriptionProduct)
	end

	if data.buyRobuxPendingTransfer then
		buyRobux.getPendingTransferStore(false).updateInfos(data.buyRobuxPendingTransfer)
	end

	if data.buyRobuxBonusItem then
		buyRobux.getBonusItemStore(false).updateInfos(data.buyRobuxBonusItem)
	end
end

local function updateFavoritesStore(p2)
	DataHydration.Game.getFavoritesStore(false).updateItems(p2)
end

local function updateUserVoteStore(p2)
	DataHydration.Game.getVotesStore(false).updateUserVoteItems(p2)
end

local function updateVoteCountsFromUniverses(universe)
	local v5 = {}
	local flag = false

	for k, item in universe do
		local totalUpVotes = tonumber(item.totalUpVotes)
		local totalDownVotes = tonumber(item.totalDownVotes)

		if not (totalUpVotes and totalDownVotes) then
			continue
		end

		v5[k] = { upVotes = totalUpVotes, downVotes = totalDownVotes }
		flag = true
	end

	if flag then
		DataHydration.Game.getVotesStore(false).updateVoteItems(v5)
	end
end

local function updateCommunityInfoStore(p2)
	DataHydration.Community.getCommunityInfoStore(false).updateCommunityInfos(p2)
end

local function updateCommunityUserMembershipStore(p2)
	DataHydration.CommunityUserMembership.getCommunityUserMembershipStore(false).updateMemberships(p2)
end

local function calculateBadgeDerivedField(p2, data, p3)
	if p2 == "created_time_formatted" then
		local created_time = data and (data.created_time or data.createdTime)
		return created_time and protobufTimestampToLocalTimeString(created_time)
	elseif p2 == "updated_time_formatted" then
		local updated_time = data and (data.updated_time or data.updatedTime)
		return updated_time and protobufTimestampToLocalTimeString(updated_time)
	end

	if p2 ~= "awarded_time_formatted" then
		return nil
	end

	local awarded_time = data and (data.awarded_time or data.awardedTime)
	return awarded_time and protobufTimestampToLocalTimeString(awarded_time)
end

local function calculateUniverseDerivedField(p2, data, p3)
	if p2 == "rating_text_formatted_brief" then
		local totalUpVotes = tonumber(data.totalUpVotes) or 0
		local totalDownVotes = tonumber(data.totalDownVotes) or 0
		local v5 = {
			upVotes = totalUpVotes,
			downVotes = totalDownVotes,
			rating = DataHydration.Game.VotesUtils.calculateRating(totalUpVotes, totalDownVotes)
		}

		return DataHydration.Game.VotesUtils.getRatingDisplayText(v5)
	elseif fFlagSduiSupportRatingNoPercent and p2 == "rating_text_no_percent" then
		local totalUpVotes = tonumber(data.totalUpVotes) or 0
		local totalDownVotes = tonumber(data.totalDownVotes) or 0
		local v5 = {
			upVotes = totalUpVotes,
			downVotes = totalDownVotes,
			rating = DataHydration.Game.VotesUtils.calculateRating(totalUpVotes, totalDownVotes)
		}

		return DataHydration.Game.VotesUtils.getRatingDisplayText(v5, true)
	else
		if p2 ~= "refund_policy_learn_more_url" then
			return nil
		end

		return getZendeskUrl(nil, LocalizationService.RobloxLocaleId, data and data.refund_article_id)
	end
end

local function calculateAgeRecommendationDerivedField(p2, p3, p4)
	if p2 == "content_rating_image" then
		local igrsRating = p3 and p3.igrsRating
		return igrsRating and DataHydration.Game.AgeRecommendationUtils.getIgrsImage(igrsRating)
	end

	if p2 == "filtered_descriptors" then
		local result = {}

		if p3 and p3.descriptors then
			for k, descriptor in p3.descriptors do
				if
					descriptor.contains == true
					and descriptor.displayName
					and descriptor.displayName ~= ""
				then
					table.insert(result, { displayName = descriptor.displayName })
				end
			end
		end

		return result
	end

	if p2 ~= "contains_strong_language" then
		return nil
	end

	if p3 and p3.descriptors then
		for k, descriptor in p3.descriptors do
			if descriptor.contains == true and descriptor.name == "strong-language" then
				return true
			end
		end
	end

	return false
end

local function getDataObjectSignal(p2, list, p3, p4)
	if p2 == "badge" then
		return DataHydration.Badges.getBadgeInfoStore(false).getBadgeInfo((tostring(p3)))
	elseif p2 == "creator" then
		return DataHydration.Creator.getCreatorInfoStore(false).getCreatorInfo(p3)
	end

	if p2 == "universe" then
		if p4 then
			return DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(p3)
		end

		return DataHydration.Game.getGameInfoStore(false).getGameInfo(p3)
	elseif p2 == "ageRecommendation" then
		if p4 then
			return DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(p3)
		end

		return DataHydration.Game.getAgeRecommendationStore(false).getAgeRecommendation(p3)
	else
		if p2 == "socialLink" then
			return DataHydration.SocialLink.getSocialLinkInfoStore(false).getSocialLinkInfo(p3)
		elseif p2 == "mediaAsset" then
			return DataHydration.MediaAsset.getMediaAssetStore(false).getMediaAsset(p3)
		end

		if p2 == "playability" then
			if p4 then
				return DataHydration.Game.getPlayabilityStore(false).getAndFetchPlayability((tostring(p3)))
			end

			return DataHydration.Game.getPlayabilityStore(false).getPlayability((tostring(p3)))
		end

		if p2 == SduiDataBindingContentType.universeUserVote then
			return DataHydration.Game.getVotesStore(false).getUserVote(p3)
		end

		if p2 == SduiDataBindingContentType.universeUserFavorite then
			if p4 then
				return DataHydration.Game.getFavoritesStore(false).getAndFetchFavorite(p3)
			end

			return DataHydration.Game.getFavoritesStore(false).getFavorite(p3)
		elseif p2 == SduiDataBindingContentType.universeUserFollow then
			if p4 then
				return DataHydration.Game.getFollowingsStore(false).getAndFetchFollowing(p3)
			end

			return DataHydration.Game.getFollowingsStore(false).getFollowing(p3)
		elseif p2 == SduiDataBindingContentType.universeUserVoteFeedbackMetadata then
			if p4 then
				return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata((tostring(p3)))
			end

			return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).getUserVoteFeedbackMetadata((tostring(p3)))
		else
			if fFlagSduiCommunitySectionSupport then
				if p2 == SduiDataBindingContentType.community then
					return DataHydration.Community.getCommunityInfoStore(false).getCommunityInfo(p3)
				end

				if p2 == SduiDataBindingContentType.communityUserMembership then
					return DataHydration.CommunityUserMembership.getCommunityUserMembershipStore(false).getMembership(p3)
				end
			end

			if p2 == "gamePass" then
				return DataHydration.Game.getGamePassStore(false).getGamePassInfo((tostring(p3)))
			elseif p2 == "event" then
				return DataHydration.ExperienceEvents.getExperienceEventInfoStore(false).getExperienceEventInfo(p3)
			end

			if fFlagSduiMarketplaceCatalogCategorySupport and p2 == "marketplaceCatalogCategory" then
				return DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getMarketplaceCatalogCategory(p3)
			end

			if fFlagSduiMarketplaceCatalogSortSupport and p2 == "marketplaceCatalogSort" then
				return DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getMarketplaceCatalogSort(p3)
			end

			if p2 == "song" then
				return DataHydration.Song.getSongInfoStore(false).getSongInfo((tostring(p3)))
			end

			if fFlagSduiAddMarketplaceEntityDataHydration then
				if p2 == "marketplaceAsset" then
					return DataHydration.MarketplaceAsset.getMarketplaceAssetStore(false).getMarketplaceAssetInfo(p3)
				elseif p2 == "marketplaceBundle" then
					return DataHydration.MarketplaceBundle.getMarketplaceBundleStore(false).getMarketplaceBundleInfo(p3)
				elseif p2 == "marketplaceLook" then
					return DataHydration.MarketplaceLook.getMarketplaceLookStore(false).getMarketplaceLookInfo(p3)
				end
			end

			if FFlagSduiAddMarketplaceItemFavoriteHydration then
				if p2 == SduiDataBindingContentType.marketplaceAssetUserFavorite then
					local marketplaceAssetFavoriteStore = DataHydration.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false)

					if p4 then
						return (marketplaceAssetFavoriteStore.getAndFetchFavorite((tostring(p3))))
					end

					return (marketplaceAssetFavoriteStore.getFavorite((tostring(p3))))
				elseif p2 == SduiDataBindingContentType.marketplaceBundleUserFavorite then
					local marketplaceBundleFavoriteStore = DataHydration.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false)

					if p4 then
						return (marketplaceBundleFavoriteStore.getAndFetchFavorite((tostring(p3))))
					end

					return (marketplaceBundleFavoriteStore.getFavorite((tostring(p3))))
				end
			end

			if fFlagSduiAddCollectibleItemDataHydration and p2 == "collectibleItem" then
				return DataHydration.CollectibleItem.getCollectibleItemStore(false).getCollectibleItemInfo(p3)
			end

			if fFlagSduiLeaderboardComponent and p2 == "leaderboardStats" then
				return DataHydration.LeaderboardStats.getLeaderboardStatsStore(false).getLeaderboardStats((tostring(p3)))
			end

			if fFlagSduiDevStoreSeeAllSupport then
				if p2 == "gameDeveloperProduct" then
					return DataHydration.Game.getGameDeveloperProductStore(false).getGameDeveloperProductInfo((tostring(p3)))
				elseif p2 == "gameSubscription" then
					return DataHydration.Game.getGameSubscriptionStore(false).getGameSubscriptionInfo((tostring(p3)))
				end
			end

			if fFlagSduiNotificationBadgeHydration and p2 == "notificationBadge" then
				return DataHydration.NotificationBadge.getNotificationBadgeStore(false).getNotificationBadge((tostring(p3)))
			end

			if not fFlagSduiBuyRobuxHydration then
				return nil
			end

			if p2 == "buyRobuxOneTimeProduct" then
				return DataHydration.BuyRobux.getOneTimeProductStore(false).getInfo((tostring(p3)))
			elseif p2 == "buyRobuxSubscriptionProduct" then
				return DataHydration.BuyRobux.getSubscriptionProductStore(false).getInfo((tostring(p3)))
			elseif p2 == "buyRobuxPendingTransfer" then
				return DataHydration.BuyRobux.getPendingTransferStore(false).getInfo((tostring(p3)))
			elseif p2 == "buyRobuxBonusItem" then
				return DataHydration.BuyRobux.getBonusItemStore(false).getInfo((tostring(p3)))
			end

			return nil
		end
	end
end

local v5 = {
	responsive = true,
	policy = true,
	clientPageScope = true,
	capability = fFlagSduiCapabilityBindings and true or nil
}

local function calculateDerivedFieldValue(p2, p3, p4, p5)
	if p2 == "badge" then
		return calculateBadgeDerivedField(p3, p4, p5)
	elseif p2 == "universe" then
		return calculateUniverseDerivedField(p3, p4, p5)
	elseif p2 == "ageRecommendation" then
		return calculateAgeRecommendationDerivedField(p3, p4, p5)
	end

	if p2 == SduiDataBindingContentType.universeUserVoteFeedbackMetadata then
		return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).calculateDerivedField(p3, p4, p5)
	end

	if p2 ~= "event" then
		return nil
	end

	local experienceEventInfoStore = DataHydration.ExperienceEvents.getExperienceEventInfoStore(false)
	local localization = getSduiServiceDependenciesStore().getDependencies("SduiDataBinder").localization
	return experienceEventInfoStore.calculateDerivedField(p3, p4, p5, localization)
end

local function getUniverseIcon(p2, p3, p4)
	local fetchGameIcon = DataHydration.Game.getGameIconStore(false).getAndFetchGameIcon(tostring(p2), p4)
	local data = fetchGameIcon.data(p3)
	local status = fetchGameIcon.status(p3)

	if data and data.url then
		return data.url, status
	end

	return nil, status
end

local function getUniverseVoteRatingText(p2, p3, p4)
	local vote = DataHydration.Game.getVotesStore(false).getVote(p2)
	local data = vote.data(p3)
	local status = vote.status(p3)
	local v6 = not data and 0 or data.upVotes
	local v7 = not data and 0 or data.downVotes

	return
		DataHydration.Game.VotesUtils.getRatingDisplayText(
			{
				upVotes = v6,
				downVotes = v7,
				rating = DataHydration.Game.VotesUtils.calculateRating(v6, v7)
			},
			p4
		),
		status
end

local function resolveFieldFromData(p2, list, p3, p4)
	if p3 == nil then
		return false, nil
	end

	local v6, v7 = tryGetPathFromData(p3, list, 2)

	if v6 then
		return true, v7
	end

	if #list ~= 2 then
		return false, nil
	end

	local v8 = calculateDerivedFieldValue(p2, list[2], p3, p4)
	return v8 ~= nil, v8
end

local function getDataHydrationField(p2, list, p3, p4, p5)
	if #list < 2 then
		return nil, nil
	end

	if not fFlagMigrateGameInfoToStore and p2 == "universe" and #list == 2 then
		if list[2] == "icon" then
			return getUniverseIcon(p3, p4)
		end

		if list[2] == "largeIcon" then
			return getUniverseIcon(p3, p4, DataHydration.Game.GameIconSize.Large)
		end
	end

	local dataObjectSignal = getDataObjectSignal(p2, list, p3, p5)

	if not dataObjectSignal then
		local joined = table.concat(list, ".")
		error(`No available data object for {p2} {joined} for id: {p3}`)
	end

	local data = dataObjectSignal.data(p4)
	local status = dataObjectSignal.status(p4)

	if not data then
		return nil, status
	end

	local v6, v7 = tryGetPathFromData(data, list, 2)

	if v6 then
		return v7, status
	end

	if #list ~= 2 then
		return nil, status
	end

	return calculateDerivedFieldValue(p2, list[2], data, p4), status
end

local function resolveUniverseField(p2, list, p3, p4, p5)
	if #list == 2 then
		if list[2] == "icon" then
			return getUniverseIcon(p3, p4)
		end

		if list[2] == "largeIcon" then
			return getUniverseIcon(p3, p4, DataHydration.Game.GameIconSize.Large)
		end

		if list[2] == "rating_text_formatted_brief" then
			return getUniverseVoteRatingText(p3, p4)
		end

		if fFlagSduiSupportRatingNoPercent and list[2] == "rating_text_no_percent" then
			return getUniverseVoteRatingText(p3, p4, true)
		end
	end

	if not p5 then
		return getDataHydrationField(p2, list, p3, p4, p5)
	end

	local gameInfoStore = DataHydration.Game.getGameInfoStore(false)
	local gameInfo, v6 = gameInfoStore.getGameInfo(p3)
	local data = gameInfo.data(p4)
	local status = gameInfo.status(p4)
	local v7, v8

	if data == nil then
		v7 = false
	else
		local v9
		v9, v8 = tryGetPathFromData(data, list, 2)

		if v9 then
			v7 = true
		elseif #list == 2 then
			v8 = calculateDerivedFieldValue(p2, list[2], data, p4)
			v7 = v8 ~= nil
		else
			v7 = false
			v8 = nil
		end
	end

	if v7 then
		return v8, status
	end

	if not v6 then
		return nil, status
	end

	gameInfoStore.getAndFetchGameInfo(p3)
	return nil, dataStatus.NotReady
end

local v6 = {}
v6.badge = getDataHydrationField
v6.creator = getDataHydrationField

if not fFlagMigrateGameInfoToStore then
	resolveUniverseField = getDataHydrationField
end

v6.universe = resolveUniverseField
v6.ageRecommendation = getDataHydrationField
v6.mediaAsset = getDataHydrationField
v6.socialLink = getDataHydrationField
v6.event = getDataHydrationField
v6.marketplaceCatalogCategory = if fFlagSduiMarketplaceCatalogCategorySupport then getDataHydrationField else nil

v6.marketplaceCatalogSort = if fFlagSduiMarketplaceCatalogSortSupport then getDataHydrationField else nil
v6.marketplaceAsset = if fFlagSduiAddMarketplaceEntityDataHydration then getDataHydrationField else nil
v6.marketplaceBundle = if fFlagSduiAddMarketplaceEntityDataHydration then getDataHydrationField else nil
v6.marketplaceLook = if fFlagSduiAddMarketplaceEntityDataHydration then getDataHydrationField else nil
v6.marketplaceAssetUserFavorite = if FFlagSduiAddMarketplaceItemFavoriteHydration then getDataHydrationField else nil

v6.marketplaceBundleUserFavorite = if FFlagSduiAddMarketplaceItemFavoriteHydration then getDataHydrationField else nil

v6.collectibleItem = if fFlagSduiAddCollectibleItemDataHydration then getDataHydrationField else nil
v6.leaderboardStats = if fFlagSduiLeaderboardComponent then getDataHydrationField else nil
v6.song = getDataHydrationField
v6.gamePass = getDataHydrationField
v6.gameDeveloperProduct = if fFlagSduiDevStoreSeeAllSupport then getDataHydrationField else nil
v6.gameSubscription = if fFlagSduiDevStoreSeeAllSupport then getDataHydrationField else nil
v6.playability = getDataHydrationField
v6.universeUserVote = getDataHydrationField
v6.universeUserFavorite = getDataHydrationField
v6.universeUserFollow = getDataHydrationField
v6.universeUserVoteFeedbackMetadata = getDataHydrationField
v6.userProfile = DataHydration.UserProfile and DataHydration.UserProfile.resolveField
v6.community = if fFlagSduiCommunitySectionSupport then getDataHydrationField else nil
v6.communityUserMembership = if fFlagSduiCommunitySectionSupport then getDataHydrationField else nil
v6.notificationBadge = if fFlagSduiNotificationBadgeHydration then getDataHydrationField else nil
v6.buyRobuxOneTimeProduct = if fFlagSduiBuyRobuxHydration then getDataHydrationField else nil
v6.buyRobuxSubscriptionProduct = if fFlagSduiBuyRobuxHydration then getDataHydrationField else nil
v6.buyRobuxPendingTransfer = if fFlagSduiBuyRobuxHydration then getDataHydrationField else nil
v6.buyRobuxBonusItem = if fFlagSduiBuyRobuxHydration then getDataHydrationField else nil
return {
	updateDataStores = function(data)
		if data.badge then
			local badge = data.badge
			DataHydration.Badges.getBadgeInfoStore(false).updateBadges(badge)
		end

		if data.creator then
			local creator = data.creator
			DataHydration.Creator.getCreatorInfoStore(false).updateCreatorInfos(creator)
		end

		if data.universe then
			local universe = data.universe

			if fFlagMigrateGameInfoToStore then
				DataHydration.Game.getGameInfoStore(false).updateGameInfos(universe, false)
			else
				DataHydration.Game.getGameInfoStore(false).updateGameInfos(universe)
			end

			if fFlagMigrateGameInfoToStore then
				updateVoteCountsFromUniverses(data.universe)
			end
		end

		if data.ageRecommendation then
			local ageRecommendation = data.ageRecommendation
			DataHydration.Game.getAgeRecommendationStore(false).updateAgeRecommendations(ageRecommendation)
		end

		if data.socialLink then
			local socialLink = data.socialLink
			DataHydration.SocialLink.getSocialLinkInfoStore(false).updateSocialLinkInfos(socialLink)
		end

		if data.mediaAsset then
			local mediaAsset = data.mediaAsset
			DataHydration.MediaAsset.getMediaAssetStore(false).updateMediaAssets(mediaAsset)
		end

		if data.playability then
			local playability = data.playability
			DataHydration.Game.getPlayabilityStore(false).updatePlayabilities(playability)
		end

		if data.universeUserFavorite then
			local universeUserFavorite = data.universeUserFavorite
			DataHydration.Game.getFavoritesStore(false).updateItems(universeUserFavorite)
		end

		if data.universeUserVote then
			local universeUserVote = data.universeUserVote
			DataHydration.Game.getVotesStore(false).updateUserVoteItems(universeUserVote)
		end

		if data.userProfile then
			DataHydration.UserProfile.updateFromHydration(data.userProfile)
		end

		if fFlagSduiCommunitySectionSupport then
			if data.community then
				local community = data.community
				DataHydration.Community.getCommunityInfoStore(false).updateCommunityInfos(community)
			end

			if data.communityUserMembership then
				local communityUserMembership = data.communityUserMembership
				DataHydration.CommunityUserMembership.getCommunityUserMembershipStore(false).updateMemberships(communityUserMembership)
			end
		end

		if data.gamePass then
			local gamePass = data.gamePass
			DataHydration.Game.getGamePassStore(false).updateGamePassInfos(gamePass)
		end

		if data.event then
			local event = data.event
			DataHydration.ExperienceEvents.getExperienceEventInfoStore(false).updateExperienceEventInfos(event)
		end

		if fFlagSduiMarketplaceCatalogCategorySupport and data.marketplaceCatalogCategory then
			local marketplaceCatalogCategory = data.marketplaceCatalogCategory
			DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).updateMarketplaceCatalogCategories(marketplaceCatalogCategory)
		end

		if fFlagSduiMarketplaceCatalogSortSupport and data.catalogSort then
			local catalogSort = data.catalogSort
			DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).updateMarketplaceCatalogSorts(catalogSort)
		end

		if data.song then
			DataHydration.Song.getSongInfoStore(false).updateSongs(data.song)
		end

		if fFlagSduiAddMarketplaceEntityDataHydration then
			if data.marketplaceAsset then
				local marketplaceAsset = data.marketplaceAsset
				DataHydration.MarketplaceAsset.getMarketplaceAssetStore(false).updateMarketplaceAssetInfos(marketplaceAsset)
			end

			if data.marketplaceBundle then
				local marketplaceBundle = data.marketplaceBundle
				DataHydration.MarketplaceBundle.getMarketplaceBundleStore(false).updateMarketplaceBundleInfos(marketplaceBundle)
			end

			if data.marketplaceLook then
				local marketplaceLook = data.marketplaceLook
				DataHydration.MarketplaceLook.getMarketplaceLookStore(false).updateMarketplaceLookInfos(marketplaceLook)
			end
		end

		if FFlagSduiAddMarketplaceItemFavoriteHydration then
			if data.marketplaceAssetUserFavorite then
				local marketplaceAssetUserFavorite = data.marketplaceAssetUserFavorite
				DataHydration.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false).updateItems(marketplaceAssetUserFavorite)
			end

			if data.marketplaceBundleUserFavorite then
				local marketplaceBundleUserFavorite = data.marketplaceBundleUserFavorite
				DataHydration.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false).updateItems(marketplaceBundleUserFavorite)
			end
		end

		if fFlagSduiAddCollectibleItemDataHydration and data.collectibleItem then
			local collectibleItem = data.collectibleItem
			DataHydration.CollectibleItem.getCollectibleItemStore(false).updateCollectibleItemInfos(collectibleItem)
		end

		if fFlagSduiLeaderboardComponent and data.leaderboardStats then
			local leaderboardStats = data.leaderboardStats
			DataHydration.LeaderboardStats.getLeaderboardStatsStore(false).updateLeaderboardStatsBatch(leaderboardStats)
		end

		if fFlagSduiDevStoreSeeAllSupport then
			if data.gameDeveloperProduct then
				local gameDeveloperProduct = data.gameDeveloperProduct
				DataHydration.Game.getGameDeveloperProductStore(false).updateGameDeveloperProductInfos(gameDeveloperProduct)
			end

			if data.gameSubscription then
				local gameSubscription = data.gameSubscription
				DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfos(gameSubscription)
			end
		end

		if fFlagSduiNotificationBadgeHydration and data.notificationBadge then
			local notificationBadge = data.notificationBadge
			DataHydration.NotificationBadge.getNotificationBadgeStore(false).updateNotificationBadges(notificationBadge)
		end

		if fFlagSduiBuyRobuxHydration then
			updateBuyRobuxStores(data)
		end
	end,
	getDataObjectSignal = getDataObjectSignal,
	getFieldValue = function(p2, list, p3, p4, p5)
		if #list < 2 then
			return nil, nil
		end

		local v25 = v6[p2]

		if v25 == nil then
			return nil, nil
		end

		return v25(p2, list, p3, p4, p5)
	end,
	calculateBadgeDerivedField = calculateBadgeDerivedField,
	calculateUniverseDerivedField = calculateUniverseDerivedField,
	isClientContentType = function(p2)
		return v5[p2] or false
	end,
	getFieldValueForClientContentType = function(p2, list, p3, p4)
		if p2 == SduiDataBindingContentType.clientPageScope then
			local configKey = if p4 then p4.configKey else nil

			if not configKey or #list < 2 then
				return nil
			end

			local item = list[2]
			return getSduiClientPageScope(configKey).getSignal(item)(p3), nil
		end

		if p2 == SduiDataBindingContentType.responsive then
			if #list ~= 2 then
				return nil
			end

			local item = list[2]

			if item == sduiDataBindingResponsiveFieldName.screenWidth then
				return Display.GetDisplayStore(p3).getViewportSize(p3).X
			end

			if item == sduiDataBindingResponsiveFieldName.screenHeight then
				return Display.GetDisplayStore(p3).getViewportSize(p3).Y
			end

			if item == sduiDataBindingResponsiveFieldName.isPortrait then
				local viewportSize = Display.GetDisplayStore(p3).getViewportSize(p3)
				return viewportSize.X < viewportSize.Y
			end

			if item == sduiDataBindingResponsiveFieldName.isSpatial then
				return Display.GetDisplayStore(p3).getIsSpatial(p3)
			end

			if item == sduiDataBindingResponsiveFieldName.lastInput then
				return Responsive.GetInputModeStore(p3).getLastInputType(p3)
			end

			if item == sduiDataBindingResponsiveFieldName.preferredInput then
				return Responsive.GetInputModeStore(p3).getPreferredInputType(p3)
			end

			if item == sduiDataBindingResponsiveFieldName.isCompactTouch then
				if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then
					local viewportSize = Display.GetDisplayStore(p3).getViewportSize(p3)
					local preferredInputType = Responsive.GetInputModeStore(p3).getPreferredInputType(p3)
					return Responsive.getIsCompactTouch(viewportSize, preferredInputType)
				else
					local viewportSize = Display.GetDisplayStore(p3).getViewportSize(p3)
					local preferredInputType = Responsive.GetInputModeStore(p3).getPreferredInputType(p3)
					local maxWidth = Responsive.BreakpointConfig.sizes[Responsive.Keys.Small].maxWidth
					local v6 = viewportSize.X < viewportSize.Y
					return viewportSize.X <= maxWidth and v6 and preferredInputType == Responsive.Input.Touch
				end
			elseif
				fFlagLuaAppMediaGalleryGamepadSupport
				and item == sduiDataBindingResponsiveFieldName.isDirectional
			then
				return Responsive.GetInputModeStore(p3).getLastInputType(p3) == Responsive.Input.Directional
			end
		end

		if fFlagSduiCapabilityBindings and p2 == SduiDataBindingContentType.capability then
			if #list < 2 then
				return nil
			end

			return SduiCapabilities.isEnabled(list[2])
		else
			if p2 ~= SduiDataBindingContentType.policy or #list < 2 then
				return nil
			end

			local appPolicy = getSduiPolicyStore().getAppPolicy(p3)

			if appPolicy == nil then
				local joined = table.concat(list, ".")
				error(`Failed to find policy table when binding value {joined}`)
			end

			local v6, v7 = resolveSduiPolicyField(appPolicy, list[2])

			if v6 then
				return v7
			end

			local rawPolicy = appPolicy.getRawPolicy()

			if rawPolicy then
				local v8, v9 = tryGetPathFromData(rawPolicy, list, 2)

				if v8 then
					return v9
				end

				local joined = table.concat(list, ".")
				error(`Failed to find policy value for '{joined}'`)
			else
				local joined = table.concat(list, ".")
				error(`Failed to find rawPolicy table when binding value {joined}`)
			end

			return nil
		end
	end,
	calculateAgeRecommendationDerivedField = calculateAgeRecommendationDerivedField
}
