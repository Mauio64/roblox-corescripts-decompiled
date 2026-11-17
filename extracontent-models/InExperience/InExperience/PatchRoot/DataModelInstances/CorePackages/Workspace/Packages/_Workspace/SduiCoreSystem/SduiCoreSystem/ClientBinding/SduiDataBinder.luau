local LocalizationService = game:GetService("LocalizationService")
local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.ServiceContractsProto)
local DataHydration = require(parent.DataHydration)
require(parent.Signals)
local Display = require(parent.Display)
local Responsive = require(parent.Responsive)
local SduiDataBindingFieldNames = require(SduiCoreSystem.ClientBinding.SduiDataBindingFieldNames)
local SduiDataBindingResponsiveFieldName = SduiDataBindingFieldNames.SduiDataBindingResponsiveFieldName

local tryGetPathFromData = require(SduiCoreSystem.ClientBinding.tryGetPathFromData)
local SduiDataBindingContentType = require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local SduiDataBinderTransformUtils = require(SduiCoreSystem.ClientBinding.SduiDataBinderTransformUtils)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local getZendeskUrl = DiscoveryUtils.getZendeskUrl
local getSduiPolicyStore = require(SduiCoreSystem.ClientBinding.getSduiPolicyStore)
local resolveSduiPolicyField = require(SduiCoreSystem.ClientBinding.resolveSduiPolicyField)
local getSduiServiceDependenciesStore = require(SduiCoreSystem.ClientBinding.getSduiServiceDependenciesStore)
local getSduiClientPageScope = require(SduiCoreSystem.ClientBinding.getSduiClientPageScope)
local SduiCapabilities = require(SduiCoreSystem.ClientBinding.SduiCapabilities)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
require(SduiCoreSystem.SduiBuilderTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagSduiCommunitySectionSupport = SharedFlags.FFlagSduiCommunitySectionSupport
local FFlagLuaAppEdpKeepFullPageOnPortraitRotation = SharedFlags.FFlagLuaAppEdpKeepFullPageOnPortraitRotation
local FFlagSduiMarketplaceCatalogCategorySupport = SharedFlags.FFlagSduiMarketplaceCatalogCategorySupport
local FFlagSduiMarketplaceCatalogSortSupport = SharedFlags.FFlagSduiMarketplaceCatalogSortSupport
local FFlagSduiAddMarketplaceEntityDataHydration = SharedFlags.FFlagSduiAddMarketplaceEntityDataHydration
local FFlagSduiAddCollectibleItemDataHydration = SharedFlags.FFlagSduiAddCollectibleItemDataHydration
local FFlagSduiLeaderboardComponent = SharedFlags.FFlagSduiLeaderboardComponent
local FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local FFlagSduiCapabilityBindings = SharedFlags.FFlagSduiCapabilityBindings
local FFlagSduiSupportRatingNoPercent = SharedFlags.FFlagSduiSupportRatingNoPercent
local FFlagSduiNotificationBadgeHydration = SharedFlags.FFlagSduiNotificationBadgeHydration

local FFlagSduiAddMarketplaceItemFavoriteHydration = require(SduiCoreSystem.FFlagSduiAddMarketplaceItemFavoriteHydration)
local FFlagSduiBuyRobuxHydration = SharedFlags.FFlagSduiBuyRobuxHydration

local DataStatus = DataHydration.DataHydrationTypes.DataStatus

local protobufTimestampToLocalTimeString = SduiDataBinderTransformUtils.protobufTimestampToLocalTimeString

local function updateBadgesInfoStore(badge) -- 1 equivalent call inferred from this helper
	DataHydration.Badges.getBadgeInfoStore(false).updateBadges(badge)
end

local function updateCreatorInfoStore(creator) -- 1 equivalent call inferred from this helper
	DataHydration.Creator.getCreatorInfoStore(false).updateCreatorInfos(creator)
end

local function updateGameInfos(universe) -- 1 equivalent call inferred from this helper
	DataHydration.Game.getGameInfoStore(false).updateGameInfos(universe, false)
end

local function updateAgeRecommendations(ageRecommendation) -- 1 equivalent call inferred from this helper
	DataHydration.Game.getAgeRecommendationStore(false).updateAgeRecommendations(ageRecommendation)
end

local function updateSocialLinkInfos(socialLink) -- 1 equivalent call inferred from this helper
	DataHydration.SocialLink.getSocialLinkInfoStore(false).updateSocialLinkInfos(socialLink)
end

local function updateMediaAssetStore(mediaAsset) -- 1 equivalent call inferred from this helper
	DataHydration.MediaAsset.getMediaAssetStore(false).updateMediaAssets(mediaAsset)
end

local function updateExperienceEventInfoStore(event) -- 1 equivalent call inferred from this helper
	DataHydration.ExperienceEvents.getExperienceEventInfoStore(false).updateExperienceEventInfos(event)
end

local function updateMarketplaceCatalogCategoryStore(marketplaceCatalogCategory) -- 1 equivalent call inferred from this helper
	DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).updateMarketplaceCatalogCategories(marketplaceCatalogCategory)
end

local function updateMarketplaceCatalogSortStore(catalogSort) -- 1 equivalent call inferred from this helper
	DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).updateMarketplaceCatalogSorts(catalogSort)
end

local function updateMarketplaceAssetInfoStore(marketplaceAsset) -- 1 equivalent call inferred from this helper
	DataHydration.MarketplaceAsset.getMarketplaceAssetStore(false).updateMarketplaceAssetInfos(marketplaceAsset)
end

local function updateMarketplaceBundleInfoStore(marketplaceBundle) -- 1 equivalent call inferred from this helper
	DataHydration.MarketplaceBundle.getMarketplaceBundleStore(false).updateMarketplaceBundleInfos(marketplaceBundle)
end

local function updateMarketplaceLookInfoStore(marketplaceLook) -- 1 equivalent call inferred from this helper
	DataHydration.MarketplaceLook.getMarketplaceLookStore(false).updateMarketplaceLookInfos(marketplaceLook)
end

local function updateMarketplaceAssetFavoriteStore(marketplaceAssetUserFavorite) -- 1 equivalent call inferred from this helper
	DataHydration.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false).updateItems(marketplaceAssetUserFavorite)
end

local function updateMarketplaceBundleFavoriteStore(marketplaceBundleUserFavorite) -- 1 equivalent call inferred from this helper
	DataHydration.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false).updateItems(marketplaceBundleUserFavorite)
end

local function updateCollectibleItemInfoStore(collectibleItem) -- 1 equivalent call inferred from this helper
	DataHydration.CollectibleItem.getCollectibleItemStore(false).updateCollectibleItemInfos(collectibleItem)
end

local function updateLeaderboardStatsStore(leaderboardStats) -- 1 equivalent call inferred from this helper
	DataHydration.LeaderboardStats.getLeaderboardStatsStore(false).updateLeaderboardStatsBatch(leaderboardStats)
end

local function updateGamePassStore(gamePass) -- 1 equivalent call inferred from this helper
	DataHydration.Game.getGamePassStore(false).updateGamePassInfos(gamePass)
end

local function updatePlayabilityStore(playability) -- 1 equivalent call inferred from this helper
	DataHydration.Game.getPlayabilityStore(false).updatePlayabilities(playability)
end

local function updateGameDeveloperProductStore(gameDeveloperProduct) -- 1 equivalent call inferred from this helper
	DataHydration.Game.getGameDeveloperProductStore(false).updateGameDeveloperProductInfos(gameDeveloperProduct)
end

local function updateGameSubscriptionStore(gameSubscription) -- 1 equivalent call inferred from this helper
	DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfos(gameSubscription)
end

local function updateNotificationBadgeStore(notificationBadge) -- 1 equivalent call inferred from this helper
	DataHydration.NotificationBadge.getNotificationBadgeStore(false).updateNotificationBadges(notificationBadge)
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

local function updateFavoritesStore(universeUserFavorite) -- 1 equivalent call inferred from this helper
	DataHydration.Game.getFavoritesStore(false).updateItems(universeUserFavorite)
end

local function updateUserVoteStore(universeUserVote) -- 1 equivalent call inferred from this helper
	DataHydration.Game.getVotesStore(false).updateUserVoteItems(universeUserVote)
end

local function updateVoteCountsFromUniverses(universe)
	local v = {}
	local flag = false

	for k, item in universe do
		local totalUpVotes = tonumber(item.totalUpVotes)
		local totalDownVotes = tonumber(item.totalDownVotes)

		if not (totalUpVotes and totalDownVotes) then
			continue
		end

		v[k] = { upVotes = totalUpVotes, downVotes = totalDownVotes }
		flag = true
	end

	if flag then
		DataHydration.Game.getVotesStore(false).updateVoteItems(v)
	end
end

local function updateCommunityInfoStore(community) -- 1 equivalent call inferred from this helper
	DataHydration.Community.getCommunityInfoStore(false).updateCommunityInfos(community)
end

local function updateCommunityUserMembershipStore(communityUserMembership) -- 1 equivalent call inferred from this helper
	DataHydration.CommunityUserMembership.getCommunityUserMembershipStore(false).updateMemberships(communityUserMembership)
end

local function calculateBadgeDerivedField(p: string, data, _)
	if p == "created_time_formatted" then
		local created_time = data and (data.created_time or data.createdTime)
		return created_time and protobufTimestampToLocalTimeString(created_time)
	elseif p == "updated_time_formatted" then
		local updated_time = data and (data.updated_time or data.updatedTime)
		return updated_time and protobufTimestampToLocalTimeString(updated_time)
	end

	if p ~= "awarded_time_formatted" then
		return nil
	end

	local awarded_time = data and (data.awarded_time or data.awardedTime)
	return awarded_time and protobufTimestampToLocalTimeString(awarded_time)
end

local function calculateUniverseDerivedField(p: string, data, _)
	if p == "rating_text_formatted_brief" then
		local totalUpVotes = tonumber(data.totalUpVotes) or 0
		local totalDownVotes = tonumber(data.totalDownVotes) or 0
		local v = {
			upVotes = totalUpVotes,
			downVotes = totalDownVotes,
			rating = DataHydration.Game.VotesUtils.calculateRating(totalUpVotes, totalDownVotes)
		}

		return DataHydration.Game.VotesUtils.getRatingDisplayText(v)
	elseif FFlagSduiSupportRatingNoPercent and p == "rating_text_no_percent" then
		local totalUpVotes = tonumber(data.totalUpVotes) or 0
		local totalDownVotes = tonumber(data.totalDownVotes) or 0
		local v = {
			upVotes = totalUpVotes,
			downVotes = totalDownVotes,
			rating = DataHydration.Game.VotesUtils.calculateRating(totalUpVotes, totalDownVotes)
		}

		return DataHydration.Game.VotesUtils.getRatingDisplayText(v, true)
	else
		if p ~= "refund_policy_learn_more_url" then
			return nil
		end

		return getZendeskUrl(nil, LocalizationService.RobloxLocaleId, data and data.refund_article_id)
	end
end

local function calculateAgeRecommendationDerivedField(p: string, p2, _)
	if p == "content_rating_image" then
		local igrsRating = p2 and p2.igrsRating
		return igrsRating and DataHydration.Game.AgeRecommendationUtils.getIgrsImage(igrsRating)
	end

	if p == "filtered_descriptors" then
		local result = {}

		if p2 and p2.descriptors then
			for _, descriptor in p2.descriptors do
				if descriptor.contains == true and descriptor.displayName and descriptor.displayName ~= "" then
					table.insert(result, { displayName = descriptor.displayName })
				end
			end
		end

		return result
	end

	if p ~= "contains_strong_language" then
		return nil
	end

	if p2 and p2.descriptors then
		for _, descriptor in p2.descriptors do
			if descriptor.contains == true and descriptor.name == "strong-language" then
				return true
			end
		end
	end

	return false
end

local function getDataObjectSignal(p, _, p2: string, flag: boolean?)
	if p == "badge" then
		return DataHydration.Badges.getBadgeInfoStore(false).getBadgeInfo((tostring(p2)))
	elseif p == "creator" then
		return DataHydration.Creator.getCreatorInfoStore(false).getCreatorInfo(p2)
	end

	if p == "universe" then
		if flag then
			return DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(p2)
		end

		return DataHydration.Game.getGameInfoStore(false).getGameInfo(p2)
	elseif p == "ageRecommendation" then
		if flag then
			return DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(p2)
		end

		return DataHydration.Game.getAgeRecommendationStore(false).getAgeRecommendation(p2)
	else
		if p == "socialLink" then
			return DataHydration.SocialLink.getSocialLinkInfoStore(false).getSocialLinkInfo(p2)
		elseif p == "mediaAsset" then
			return DataHydration.MediaAsset.getMediaAssetStore(false).getMediaAsset(p2)
		end

		if p == "playability" then
			if flag then
				return DataHydration.Game.getPlayabilityStore(false).getAndFetchPlayability((tostring(p2)))
			end

			return DataHydration.Game.getPlayabilityStore(false).getPlayability((tostring(p2)))
		end

		if p == SduiDataBindingContentType.universeUserVote then
			return DataHydration.Game.getVotesStore(false).getUserVote(p2)
		end

		if p == SduiDataBindingContentType.universeUserFavorite then
			if flag then
				return DataHydration.Game.getFavoritesStore(false).getAndFetchFavorite(p2)
			end

			return DataHydration.Game.getFavoritesStore(false).getFavorite(p2)
		elseif p == SduiDataBindingContentType.universeUserFollow then
			if flag then
				return DataHydration.Game.getFollowingsStore(false).getAndFetchFollowing(p2)
			end

			return DataHydration.Game.getFollowingsStore(false).getFollowing(p2)
		elseif p == SduiDataBindingContentType.universeUserVoteFeedbackMetadata then
			if flag then
				return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata((tostring(p2)))
			end

			return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).getUserVoteFeedbackMetadata((tostring(p2)))
		else
			if FFlagSduiCommunitySectionSupport then
				if p == SduiDataBindingContentType.community then
					return DataHydration.Community.getCommunityInfoStore(false).getCommunityInfo(p2)
				end

				if p == SduiDataBindingContentType.communityUserMembership then
					return DataHydration.CommunityUserMembership.getCommunityUserMembershipStore(false).getMembership(p2)
				end
			end

			if p == "gamePass" then
				return DataHydration.Game.getGamePassStore(false).getGamePassInfo((tostring(p2)))
			elseif p == "event" then
				return DataHydration.ExperienceEvents.getExperienceEventInfoStore(false).getExperienceEventInfo(p2)
			end

			if FFlagSduiMarketplaceCatalogCategorySupport and p == "marketplaceCatalogCategory" then
				return DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getMarketplaceCatalogCategory(p2)
			end

			if FFlagSduiMarketplaceCatalogSortSupport and p == "marketplaceCatalogSort" then
				return DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getMarketplaceCatalogSort(p2)
			end

			if p == "song" then
				return DataHydration.Song.getSongInfoStore(false).getSongInfo((tostring(p2)))
			end

			if FFlagSduiAddMarketplaceEntityDataHydration then
				if p == "marketplaceAsset" then
					return DataHydration.MarketplaceAsset.getMarketplaceAssetStore(false).getMarketplaceAssetInfo(p2)
				elseif p == "marketplaceBundle" then
					return DataHydration.MarketplaceBundle.getMarketplaceBundleStore(false).getMarketplaceBundleInfo(p2)
				elseif p == "marketplaceLook" then
					return DataHydration.MarketplaceLook.getMarketplaceLookStore(false).getMarketplaceLookInfo(p2)
				end
			end

			if FFlagSduiAddMarketplaceItemFavoriteHydration then
				if p == SduiDataBindingContentType.marketplaceAssetUserFavorite then
					local marketplaceAssetFavoriteStore = DataHydration.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false)

					if flag then
						return (marketplaceAssetFavoriteStore.getAndFetchFavorite((tostring(p2))))
					end

					return (marketplaceAssetFavoriteStore.getFavorite((tostring(p2))))
				elseif p == SduiDataBindingContentType.marketplaceBundleUserFavorite then
					local marketplaceBundleFavoriteStore = DataHydration.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false)

					if flag then
						return (marketplaceBundleFavoriteStore.getAndFetchFavorite((tostring(p2))))
					end

					return (marketplaceBundleFavoriteStore.getFavorite((tostring(p2))))
				end
			end

			if FFlagSduiAddCollectibleItemDataHydration and p == "collectibleItem" then
				return DataHydration.CollectibleItem.getCollectibleItemStore(false).getCollectibleItemInfo(p2)
			end

			if FFlagSduiLeaderboardComponent and p == "leaderboardStats" then
				return DataHydration.LeaderboardStats.getLeaderboardStatsStore(false).getLeaderboardStats((tostring(p2)))
			end

			if FFlagSduiDevStoreSeeAllSupport then
				if p == "gameDeveloperProduct" then
					return DataHydration.Game.getGameDeveloperProductStore(false).getGameDeveloperProductInfo((tostring(p2)))
				elseif p == "gameSubscription" then
					return DataHydration.Game.getGameSubscriptionStore(false).getGameSubscriptionInfo((tostring(p2)))
				end
			end

			if FFlagSduiNotificationBadgeHydration and p == "notificationBadge" then
				return DataHydration.NotificationBadge.getNotificationBadgeStore(false).getNotificationBadge((tostring(p2)))
			end

			if not FFlagSduiBuyRobuxHydration then
				return nil
			end

			if p == "buyRobuxOneTimeProduct" then
				return DataHydration.BuyRobux.getOneTimeProductStore(false).getInfo((tostring(p2)))
			elseif p == "buyRobuxSubscriptionProduct" then
				return DataHydration.BuyRobux.getSubscriptionProductStore(false).getInfo((tostring(p2)))
			elseif p == "buyRobuxPendingTransfer" then
				return DataHydration.BuyRobux.getPendingTransferStore(false).getInfo((tostring(p2)))
			elseif p == "buyRobuxBonusItem" then
				return DataHydration.BuyRobux.getBonusItemStore(false).getInfo((tostring(p2)))
			end

			return nil
		end
	end
end

local v = {
	responsive = true,
	policy = true,
	clientPageScope = true,
	capability = FFlagSduiCapabilityBindings and true or nil
}

local function calculateDerivedFieldValue(p, p2: string, p3, p4)
	if p == "badge" then
		return calculateBadgeDerivedField(p2, p3, p4)
	elseif p == "universe" then
		return calculateUniverseDerivedField(p2, p3, p4)
	elseif p == "ageRecommendation" then
		return calculateAgeRecommendationDerivedField(p2, p3, p4)
	end

	if p == SduiDataBindingContentType.universeUserVoteFeedbackMetadata then
		return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).calculateDerivedField(p2, p3, p4)
	end

	if p ~= "event" then
		return nil
	end

	local experienceEventInfoStore = DataHydration.ExperienceEvents.getExperienceEventInfoStore(false)
	local localization = getSduiServiceDependenciesStore().getDependencies("SduiDataBinder").localization
	return experienceEventInfoStore.calculateDerivedField(p2, p3, p4, localization)
end

local function getUniverseIcon(p: string, p2, p3)
	local fetchGameIcon = DataHydration.Game.getGameIconStore(false).getAndFetchGameIcon(tostring(p), p3)
	local data = fetchGameIcon.data(p2)
	local status = fetchGameIcon.status(p2)

	if data and data.url then
		return data.url, status
	end

	return nil, status
end

local function getUniverseVoteRatingText(p: string, p2, flag: boolean?)
	local vote = DataHydration.Game.getVotesStore(false).getVote(p)
	local data = vote.data(p2)
	local status = vote.status(p2)
	local upVotes = not data and 0 or data.upVotes
	local downVotes = not data and 0 or data.downVotes

	return
		DataHydration.Game.VotesUtils.getRatingDisplayText(
			{
				upVotes = upVotes,
				downVotes = downVotes,
				rating = DataHydration.Game.VotesUtils.calculateRating(upVotes, downVotes)
			},
			flag
		),
		status
end

local function resolveFieldFromData(p, list, p2, p3)
	if p2 == nil then
		return false, nil
	end

	local v2, v3 = tryGetPathFromData(p2, list, 2)

	if v2 then
		return true, v3
	end

	if #list ~= 2 then
		return false, nil
	end

	local v4 = calculateDerivedFieldValue(p, list[2], p2, p3)
	return v4 ~= nil, v4
end

local function getDataHydrationField(p, list, p2: string, p3, flag: boolean?)
	if #list < 2 then
		return nil, nil
	end

	local dataObjectSignal = getDataObjectSignal(p, list, p2, flag)

	if not dataObjectSignal then
		local joined = table.concat(list, ".")
		error(`No available data object for {p} {joined} for id: {p2}`)
	end

	local data = dataObjectSignal.data(p3)
	local status = dataObjectSignal.status(p3)

	if not data then
		return nil, status
	end

	local v2, v3 = tryGetPathFromData(data, list, 2)

	if v2 then
		return v3, status
	end

	if #list ~= 2 then
		return nil, status
	end

	return calculateDerivedFieldValue(p, list[2], data, p3), status
end

local function resolveUniverseField(p, list, p2: string, p3, flag: boolean?)
	if #list == 2 then
		if list[2] == "icon" then
			return getUniverseIcon(p2, p3)
		end

		if list[2] == "largeIcon" then
			return getUniverseIcon(p2, p3, DataHydration.Game.GameIconSize.Large)
		end

		if list[2] == "rating_text_formatted_brief" then
			return getUniverseVoteRatingText(p2, p3)
		end

		if FFlagSduiSupportRatingNoPercent and list[2] == "rating_text_no_percent" then
			return getUniverseVoteRatingText(p2, p3, true)
		end
	end

	if not flag then
		return getDataHydrationField(p, list, p2, p3, flag)
	end

	local gameInfoStore = DataHydration.Game.getGameInfoStore(false)
	local gameInfo, v2 = gameInfoStore.getGameInfo(p2)
	local data = gameInfo.data(p3)
	local status = gameInfo.status(p3)
	local v3, v4

	if data == nil then
		v3 = false
	else
		local v5
		v5, v4 = tryGetPathFromData(data, list, 2)

		if v5 then
			v3 = true
		elseif #list == 2 then
			v4 = calculateDerivedFieldValue(p, list[2], data, p3)
			v3 = v4 ~= nil
		else
			v3 = false
			v4 = nil
		end
	end

	if v3 then
		return v4, status
	end

	if not v2 then
		return nil, status
	end

	gameInfoStore.getAndFetchGameInfo(p2)
	return nil, DataStatus.NotReady
end

local v2 = {}
v2.badge = getDataHydrationField
v2.creator = getDataHydrationField
v2.universe = resolveUniverseField
v2.ageRecommendation = getDataHydrationField
v2.mediaAsset = getDataHydrationField
v2.socialLink = getDataHydrationField
v2.event = getDataHydrationField
local marketplaceCatalogCategory

if FFlagSduiMarketplaceCatalogCategorySupport then
	marketplaceCatalogCategory = getDataHydrationField
end

v2.marketplaceCatalogCategory = marketplaceCatalogCategory
local marketplaceCatalogSort

if FFlagSduiMarketplaceCatalogSortSupport then
	marketplaceCatalogSort = getDataHydrationField
end

v2.marketplaceCatalogSort = marketplaceCatalogSort
local marketplaceAsset

if FFlagSduiAddMarketplaceEntityDataHydration then
	marketplaceAsset = getDataHydrationField
end

v2.marketplaceAsset = marketplaceAsset
local marketplaceBundle

if FFlagSduiAddMarketplaceEntityDataHydration then
	marketplaceBundle = getDataHydrationField
end

v2.marketplaceBundle = marketplaceBundle
local marketplaceLook

if FFlagSduiAddMarketplaceEntityDataHydration then
	marketplaceLook = getDataHydrationField
end

v2.marketplaceLook = marketplaceLook
local marketplaceAssetUserFavorite

if FFlagSduiAddMarketplaceItemFavoriteHydration then
	marketplaceAssetUserFavorite = getDataHydrationField
end

v2.marketplaceAssetUserFavorite = marketplaceAssetUserFavorite
local marketplaceBundleUserFavorite

if FFlagSduiAddMarketplaceItemFavoriteHydration then
	marketplaceBundleUserFavorite = getDataHydrationField
end

v2.marketplaceBundleUserFavorite = marketplaceBundleUserFavorite
local collectibleItem

if FFlagSduiAddCollectibleItemDataHydration then
	collectibleItem = getDataHydrationField
end

v2.collectibleItem = collectibleItem
local leaderboardStats

if FFlagSduiLeaderboardComponent then
	leaderboardStats = getDataHydrationField
end

v2.leaderboardStats = leaderboardStats
v2.song = getDataHydrationField
v2.gamePass = getDataHydrationField
local gameDeveloperProduct

if FFlagSduiDevStoreSeeAllSupport then
	gameDeveloperProduct = getDataHydrationField
end

v2.gameDeveloperProduct = gameDeveloperProduct
local gameSubscription

if FFlagSduiDevStoreSeeAllSupport then
	gameSubscription = getDataHydrationField
end

v2.gameSubscription = gameSubscription
v2.playability = getDataHydrationField
v2.universeUserVote = getDataHydrationField
v2.universeUserFavorite = getDataHydrationField
v2.universeUserFollow = getDataHydrationField
v2.universeUserVoteFeedbackMetadata = getDataHydrationField
v2.userProfile = DataHydration.UserProfile and DataHydration.UserProfile.resolveField
local community

if FFlagSduiCommunitySectionSupport then
	community = getDataHydrationField
end

v2.community = community
local communityUserMembership

if FFlagSduiCommunitySectionSupport then
	communityUserMembership = getDataHydrationField
end

v2.communityUserMembership = communityUserMembership
local notificationBadge

if FFlagSduiNotificationBadgeHydration then
	notificationBadge = getDataHydrationField
end

v2.notificationBadge = notificationBadge
local buyRobuxOneTimeProduct

if FFlagSduiBuyRobuxHydration then
	buyRobuxOneTimeProduct = getDataHydrationField
end

v2.buyRobuxOneTimeProduct = buyRobuxOneTimeProduct
local buyRobuxSubscriptionProduct

if FFlagSduiBuyRobuxHydration then
	buyRobuxSubscriptionProduct = getDataHydrationField
end

v2.buyRobuxSubscriptionProduct = buyRobuxSubscriptionProduct
local buyRobuxPendingTransfer

if FFlagSduiBuyRobuxHydration then
	buyRobuxPendingTransfer = getDataHydrationField
end

v2.buyRobuxPendingTransfer = buyRobuxPendingTransfer
local buyRobuxBonusItem

if FFlagSduiBuyRobuxHydration then
	buyRobuxBonusItem = getDataHydrationField
end

v2.buyRobuxBonusItem = buyRobuxBonusItem
local SduiDataBinder = {}

function SduiDataBinder.updateDataStores(data)
	if data.badge then
		updateBadgesInfoStore(data.badge) -- inferred equivalent call
	end

	if data.creator then
		updateCreatorInfoStore(data.creator) -- inferred equivalent call
	end

	if data.universe then
		updateGameInfos(data.universe) -- inferred equivalent call
		updateVoteCountsFromUniverses(data.universe)
	end

	if data.ageRecommendation then
		updateAgeRecommendations(data.ageRecommendation) -- inferred equivalent call
	end

	if data.socialLink then
		updateSocialLinkInfos(data.socialLink) -- inferred equivalent call
	end

	if data.mediaAsset then
		updateMediaAssetStore(data.mediaAsset) -- inferred equivalent call
	end

	if data.playability then
		updatePlayabilityStore(data.playability) -- inferred equivalent call
	end

	if data.universeUserFavorite then
		updateFavoritesStore(data.universeUserFavorite) -- inferred equivalent call
	end

	if data.universeUserVote then
		updateUserVoteStore(data.universeUserVote) -- inferred equivalent call
	end

	if data.userProfile then
		DataHydration.UserProfile.updateFromHydration(data.userProfile)
	end

	if FFlagSduiCommunitySectionSupport then
		if data.community then
			updateCommunityInfoStore(data.community) -- inferred equivalent call
		end

		if data.communityUserMembership then
			updateCommunityUserMembershipStore(data.communityUserMembership) -- inferred equivalent call
		end
	end

	if data.gamePass then
		updateGamePassStore(data.gamePass) -- inferred equivalent call
	end

	if data.event then
		updateExperienceEventInfoStore(data.event) -- inferred equivalent call
	end

	if FFlagSduiMarketplaceCatalogCategorySupport and data.marketplaceCatalogCategory then
		updateMarketplaceCatalogCategoryStore(data.marketplaceCatalogCategory) -- inferred equivalent call
	end

	if FFlagSduiMarketplaceCatalogSortSupport and data.catalogSort then
		updateMarketplaceCatalogSortStore(data.catalogSort) -- inferred equivalent call
	end

	if data.song then
		DataHydration.Song.getSongInfoStore(false).updateSongs(data.song)
	end

	if FFlagSduiAddMarketplaceEntityDataHydration then
		if data.marketplaceAsset then
			updateMarketplaceAssetInfoStore(data.marketplaceAsset) -- inferred equivalent call
		end

		if data.marketplaceBundle then
			updateMarketplaceBundleInfoStore(data.marketplaceBundle) -- inferred equivalent call
		end

		if data.marketplaceLook then
			updateMarketplaceLookInfoStore(data.marketplaceLook) -- inferred equivalent call
		end
	end

	if FFlagSduiAddMarketplaceItemFavoriteHydration then
		if data.marketplaceAssetUserFavorite then
			updateMarketplaceAssetFavoriteStore(data.marketplaceAssetUserFavorite) -- inferred equivalent call
		end

		if data.marketplaceBundleUserFavorite then
			updateMarketplaceBundleFavoriteStore(data.marketplaceBundleUserFavorite) -- inferred equivalent call
		end
	end

	if FFlagSduiAddCollectibleItemDataHydration and data.collectibleItem then
		updateCollectibleItemInfoStore(data.collectibleItem) -- inferred equivalent call
	end

	if FFlagSduiLeaderboardComponent and data.leaderboardStats then
		updateLeaderboardStatsStore(data.leaderboardStats) -- inferred equivalent call
	end

	if FFlagSduiDevStoreSeeAllSupport then
		if data.gameDeveloperProduct then
			updateGameDeveloperProductStore(data.gameDeveloperProduct) -- inferred equivalent call
		end

		if data.gameSubscription then
			updateGameSubscriptionStore(data.gameSubscription) -- inferred equivalent call
		end
	end

	if FFlagSduiNotificationBadgeHydration and data.notificationBadge then
		updateNotificationBadgeStore(data.notificationBadge) -- inferred equivalent call
	end

	if FFlagSduiBuyRobuxHydration then
		updateBuyRobuxStores(data)
	end
end

SduiDataBinder.getDataObjectSignal = getDataObjectSignal

function SduiDataBinder.getFieldValue(p, list, p2: string, p3, flag: boolean?)
	if #list < 2 then
		return nil, nil
	end

	local v3 = v2[p]

	if v3 == nil then
		return nil, nil
	end

	return v3(p, list, p2, p3, flag)
end

SduiDataBinder.calculateBadgeDerivedField = calculateBadgeDerivedField
SduiDataBinder.calculateUniverseDerivedField = calculateUniverseDerivedField

function SduiDataBinder.isClientContentType(p)
	return v[p] or false
end

function SduiDataBinder.getFieldValueForClientContentType(p, list, p2, p3)
	if p == SduiDataBindingContentType.clientPageScope then
		local configKey

		if p3 then
			configKey = p3.configKey
		end

		if not configKey or #list < 2 then
			return nil
		end

		local item = list[2]
		return getSduiClientPageScope(configKey).getSignal(item)(p2), nil
	end

	if p == SduiDataBindingContentType.responsive then
		if #list ~= 2 then
			return nil
		end

		local item = list[2]

		if item == SduiDataBindingResponsiveFieldName.screenWidth then
			return Display.GetDisplayStore(p2).getViewportSize(p2).X
		end

		if item == SduiDataBindingResponsiveFieldName.screenHeight then
			return Display.GetDisplayStore(p2).getViewportSize(p2).Y
		end

		if item == SduiDataBindingResponsiveFieldName.isPortrait then
			local viewportSize = Display.GetDisplayStore(p2).getViewportSize(p2)
			return viewportSize.X < viewportSize.Y
		end

		if item == SduiDataBindingResponsiveFieldName.isSpatial then
			return Display.GetDisplayStore(p2).getIsSpatial(p2)
		end

		if item == SduiDataBindingResponsiveFieldName.lastInput then
			return Responsive.GetInputModeStore(p2).getLastInputType(p2)
		end

		if item == SduiDataBindingResponsiveFieldName.preferredInput then
			return Responsive.GetInputModeStore(p2).getPreferredInputType(p2)
		end

		if item == SduiDataBindingResponsiveFieldName.isCompactTouch then
			if FFlagLuaAppEdpKeepFullPageOnPortraitRotation then
				local viewportSize = Display.GetDisplayStore(p2).getViewportSize(p2)
				local preferredInputType = Responsive.GetInputModeStore(p2).getPreferredInputType(p2)
				return Responsive.getIsCompactTouch(viewportSize, preferredInputType)
			else
				local viewportSize = Display.GetDisplayStore(p2).getViewportSize(p2)
				local preferredInputType = Responsive.GetInputModeStore(p2).getPreferredInputType(p2)
				local maxWidth = Responsive.BreakpointConfig.sizes[Responsive.Keys.Small].maxWidth
				local v2 = viewportSize.X < viewportSize.Y
				return viewportSize.X <= maxWidth and v2 and preferredInputType == Responsive.Input.Touch
			end
		elseif FFlagLuaAppMediaGalleryGamepadSupport and item == SduiDataBindingResponsiveFieldName.isDirectional then
			return Responsive.GetInputModeStore(p2).getLastInputType(p2) == Responsive.Input.Directional
		end
	end

	if FFlagSduiCapabilityBindings and p == SduiDataBindingContentType.capability then
		if #list < 2 then
			return nil
		end

		return SduiCapabilities.isEnabled(list[2])
	else
		if p ~= SduiDataBindingContentType.policy or #list < 2 then
			return nil
		end

		local appPolicy = getSduiPolicyStore().getAppPolicy(p2)

		if appPolicy == nil then
			local joined = table.concat(list, ".")
			error(`Failed to find policy table when binding value {joined}`)
		end

		local sduiPolicyField, v2 = resolveSduiPolicyField(appPolicy, list[2])

		if sduiPolicyField then
			return v2
		end

		local rawPolicy = appPolicy.getRawPolicy()

		if rawPolicy then
			local v3, v4 = tryGetPathFromData(rawPolicy, list, 2)

			if v3 then
				return v4
			end

			local joined = table.concat(list, ".")
			error(`Failed to find policy value for '{joined}'`)
		else
			local joined = table.concat(list, ".")
			error(`Failed to find rawPolicy table when binding value {joined}`)
		end

		return nil
	end
end

SduiDataBinder.calculateAgeRecommendationDerivedField = calculateAgeRecommendationDerivedField
return SduiDataBinder
