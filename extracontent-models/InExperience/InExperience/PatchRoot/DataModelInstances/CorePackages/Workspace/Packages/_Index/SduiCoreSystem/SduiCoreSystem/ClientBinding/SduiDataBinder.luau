local LocalizationService = game:GetService("LocalizationService")
local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.ServiceContractsProto)

local DataHydration = require(SduiCoreSystemParent.DataHydration)

require(SduiCoreSystemParent.Signals)

local Display = require(SduiCoreSystemParent.Display)
local Responsive = require(SduiCoreSystemParent.Responsive)
local SduiDataBindingResponsiveFieldName = require(SduiCoreSystem.ClientBinding.SduiDataBindingFieldNames).SduiDataBindingResponsiveFieldName
local tryGetPathFromData = require(SduiCoreSystem.ClientBinding.tryGetPathFromData)
local SduiDataBindingContentType = require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local SduiDataBinderTransformUtils = require(SduiCoreSystem.ClientBinding.SduiDataBinderTransformUtils)
local getZendeskUrl = require(SduiCoreSystemParent.DiscoveryUtils).getZendeskUrl
local getSduiPolicyStore = require(SduiCoreSystem.ClientBinding.getSduiPolicyStore)
local resolveSduiPolicyField = require(SduiCoreSystem.ClientBinding.resolveSduiPolicyField)
local getSduiServiceDependenciesStore = require(SduiCoreSystem.ClientBinding.getSduiServiceDependenciesStore)
local getSduiClientPageScope = require(SduiCoreSystem.ClientBinding.getSduiClientPageScope)
local SduiCapabilities = require(SduiCoreSystem.ClientBinding.SduiCapabilities)

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
require(SduiCoreSystem.SduiBuilderTypes)

local SharedFlags = require(SduiCoreSystemParent.SharedFlags)
local FFlagSduiAppPolicyBindings = SharedFlags.FFlagSduiAppPolicyBindings
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagLuaAppEdpKeepFullPageOnPortraitRotation = SharedFlags.FFlagLuaAppEdpKeepFullPageOnPortraitRotation
local FFlagSduiEventDetailsSupport = SharedFlags.FFlagSduiEventDetailsSupport
local FFlagSduiMarketplaceCatalogCategorySupport = SharedFlags.FFlagSduiMarketplaceCatalogCategorySupport
local FFlagSduiMarketplaceCatalogSortSupport = SharedFlags.FFlagSduiMarketplaceCatalogSortSupport
local FFlagSduiAddMarketplaceEntityDataHydration = SharedFlags.FFlagSduiAddMarketplaceEntityDataHydration
local FFlagSduiHydrationFetchIfMissing = SharedFlags.FFlagSduiHydrationFetchIfMissing
local FFlagSduiGameIconSupport = SharedFlags.FFlagSduiGameIconSupport
local FFlagLuaAppVoteOptimisticUpdateRaceFix = SharedFlags.FFlagLuaAppVoteOptimisticUpdateRaceFix
local FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local FFlagSduiClientPageScope = SharedFlags.FFlagSduiClientPageScope
local FFlagSduiCapabilityBindings = SharedFlags.FFlagSduiCapabilityBindings
local protobufTimestampToLocalTimeString = SduiDataBinderTransformUtils.protobufTimestampToLocalTimeString

local function updateBadgesInfoStore(t1: {[any]: any}) -- line: 67
	-- upvalues: DataHydration (copy)
	DataHydration.Badges.getBadgeInfoStore(false).updateBadges(t1)
end
local function updateCreatorInfoStore(t2: {[any]: any}) -- line: 71
	-- upvalues: DataHydration (copy)
	DataHydration.Creator.getCreatorInfoStore(false).updateCreatorInfos(t2)
end
local function updateGameInfos(t3: {[any]: any}) -- line: 75
	-- upvalues: DataHydration (copy)
	DataHydration.Game.getGameInfoStore(false).updateGameInfos(t3)
end
local function updateAgeRecommendations(t4: {[any]: any}) -- line: 79
	-- upvalues: DataHydration (copy)
	DataHydration.Game.getAgeRecommendationStore(false).updateAgeRecommendations(t4)
end
local function updateSocialLinkInfos(t5: {[any]: any}) -- line: 83
	-- upvalues: DataHydration (copy)
	DataHydration.SocialLink.getSocialLinkInfoStore(false).updateSocialLinkInfos(t5)
end
local function updateMediaAssetStore(t6: {[any]: any}) -- line: 87
	-- upvalues: DataHydration (copy)
	DataHydration.MediaAsset.getMediaAssetStore(false).updateMediaAssets(t6)
end
local function updateExperienceEventInfoStore(t7: {[any]: any}) -- line: 91
	-- upvalues: DataHydration (copy)
	DataHydration.ExperienceEvents.getExperienceEventInfoStore(false).updateExperienceEventInfos(t7)
end
local function updateMarketplaceCatalogCategoryStore(t8: {[any]: any}) -- line: 95
	-- upvalues: DataHydration (copy)
	DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).updateMarketplaceCatalogCategories(t8)
end
local function updateMarketplaceCatalogSortStore(t9: {[any]: any}) -- line: 101
	-- upvalues: DataHydration (copy)
	DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).updateMarketplaceCatalogSorts(t9)
end
local function updateMarketplaceAssetInfoStore(t10: {[any]: any}) -- line: 105
	-- upvalues: DataHydration (copy)
	DataHydration.MarketplaceAsset.getMarketplaceAssetStore(false).updateMarketplaceAssetInfos(t10)
end
local function updateMarketplaceBundleInfoStore(t11: {[any]: any}) -- line: 109
	-- upvalues: DataHydration (copy)
	DataHydration.MarketplaceBundle.getMarketplaceBundleStore(false).updateMarketplaceBundleInfos(t11)
end
local function updateMarketplaceLookInfoStore(t12: {[any]: any}) -- line: 113
	-- upvalues: DataHydration (copy)
	DataHydration.MarketplaceLook.getMarketplaceLookStore(false).updateMarketplaceLookInfos(t12)
end
local function updateGamePassStore(t13: {[any]: any}) -- line: 117
	-- upvalues: DataHydration (copy)
	DataHydration.Game.getGamePassStore(false).updateGamePassInfos(t13)
end
local function updatePlayabilityStore(t14: {[any]: any}) -- line: 121
	-- upvalues: DataHydration (copy)
	DataHydration.Game.getPlayabilityStore(false).updatePlayabilities(t14)
end
local function updateGameDeveloperProductStore(t15: {[any]: any}) -- line: 125
	-- upvalues: DataHydration (copy)
	DataHydration.Game.getGameDeveloperProductStore(false).updateGameDeveloperProductInfos(t15)
end
local function updateGameSubscriptionStore(t16: {[any]: any}) -- line: 129
	-- upvalues: DataHydration (copy)
	DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfos(t16)
end
local function updateFavoritesStore(t17: {[any]: any}) -- line: 133
	-- upvalues: DataHydration (copy)
	DataHydration.Game.getFavoritesStore(false).updateItems(t17)
end
local function updateUserVoteStore(t18: {[any]: any}) -- line: 137
	-- upvalues: DataHydration (copy)
	DataHydration.Game.getVotesStore(false).updateUserVoteItems(t18)
end
local function calculateBadgeDerivedField(s1: string, p1, _) -- line: 149
	-- upvalues: protobufTimestampToLocalTimeString (copy)
	if s1 == "created_time_formatted" then
		local v80 = p1 and (p1.created_time or p1.createdTime)

		return v80 and protobufTimestampToLocalTimeString(v80)
	end

	if s1 == "updated_time_formatted" then
		local v81 = p1 and (p1.updated_time or p1.updatedTime)

		return v81 and protobufTimestampToLocalTimeString(v81)
	end

	if s1 == "awarded_time_formatted" then
		local v82 = p1 and (p1.awarded_time or p1.awardedTime)

		return v82 and protobufTimestampToLocalTimeString(v82)
	end

	return nil
end
local function calculateUniverseDerivedField(s2: string, p3, _) -- line: 172
	-- upvalues: DataHydration (copy), FFlagSduiExperienceDetailsSupport (copy), LocalizationService (copy), getZendeskUrl (copy)
	if s2 == "rating_text_formatted_brief" then
		local v86 = tonumber(p3.totalUpVotes) or 0
		local v87 = tonumber(p3.totalDownVotes) or 0
		local v88 = DataHydration.Game.VotesUtils.calculateRating(v86, v87)
		local t19 = {
			upVotes = v86,
			downVotes = v87,
			rating = v88
		}

		return DataHydration.Game.VotesUtils.getRatingDisplayText(t19)
	end

	if FFlagSduiExperienceDetailsSupport and s2 == "refund_policy_learn_more_url" then
		local RobloxLocaleId = LocalizationService.RobloxLocaleId

		return getZendeskUrl(nil, RobloxLocaleId, p3 and p3.refund_article_id)
	end

	return nil
end
local function calculateAgeRecommendationDerivedField(s3: string, p5, _) -- line: 202
	-- upvalues: DataHydration (copy)
	if s3 == "content_rating_image" then
		local v94 = p5 and p5.igrsRating

		return v94 and DataHydration.Game.AgeRecommendationUtils.getIgrsImage(v94)
	end

	if s3 == "filtered_descriptors" then
		local t20 = {}

		if p5 and p5.descriptors then
			for _, v97 in p5.descriptors do
				if v97.contains == true and v97.displayName and v97.displayName ~= "" then
					table.insert(t20, {
						displayName = v97.displayName
					})
				end
			end
		end

		return t20
	end

	if s3 == "contains_strong_language" then
		if p5 and p5.descriptors then
			for _, v99 in p5.descriptors do
				if v99.contains == true and v99.name == "strong-language" then
					return true
				end
			end
		end

		return false
	end

	return nil
end
local function getDataObjectSignal(p7, _: {[any]: any}, s4: string, b1: boolean?) -- line: 238
	-- upvalues: DataHydration (copy), FFlagSduiHydrationFetchIfMissing (copy), FFlagSduiExperienceDetailsSupport (copy), SduiDataBindingContentType (copy), FFlagLuaAppVoteOptimisticUpdateRaceFix (copy), FFlagSduiDevStoreSeeAllSupport (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiMarketplaceCatalogCategorySupport (copy), FFlagSduiMarketplaceCatalogSortSupport (copy), FFlagSduiAddMarketplaceEntityDataHydration (copy)
	if p7 == "badge" then
		return DataHydration.Badges.getBadgeInfoStore(false).getBadgeInfo((tostring(s4)))
	end

	if p7 == "creator" then
		return DataHydration.Creator.getCreatorInfoStore(false).getCreatorInfo(s4)
	end

	if p7 == "universe" then
		if FFlagSduiHydrationFetchIfMissing and b1 then
			return DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(s4)
		end

		return DataHydration.Game.getGameInfoStore(false).getGameInfo(s4)
	end

	if FFlagSduiExperienceDetailsSupport then
		if p7 == "ageRecommendation" then
			if FFlagSduiHydrationFetchIfMissing and b1 then
				return DataHydration.Game.getAgeRecommendationStore(false).getAndFetchAgeRecommendation(s4)
			end

			return DataHydration.Game.getAgeRecommendationStore(false).getAgeRecommendation(s4)
		end

		if p7 == "socialLink" then
			return DataHydration.SocialLink.getSocialLinkInfoStore(false).getSocialLinkInfo(s4)
		end

		if p7 == "mediaAsset" then
			return DataHydration.MediaAsset.getMediaAssetStore(false).getMediaAsset(s4)
		end

		if p7 == "playability" then
			if FFlagSduiHydrationFetchIfMissing and b1 then
				return DataHydration.Game.getPlayabilityStore(false).getAndFetchPlayability((tostring(s4)))
			end

			return DataHydration.Game.getPlayabilityStore(false).getPlayability((tostring(s4)))
		end

		if p7 == SduiDataBindingContentType.universeUserVote then
			if b1 and not FFlagLuaAppVoteOptimisticUpdateRaceFix then
				return DataHydration.Game.getVotesStore(false).getAndFetchUserVote(s4)
			end

			return DataHydration.Game.getVotesStore(false).getUserVote(s4)
		end

		if p7 == SduiDataBindingContentType.universeUserFavorite then
			if b1 then
				return DataHydration.Game.getFavoritesStore(false).getAndFetchFavorite(s4)
			end

			return DataHydration.Game.getFavoritesStore(false).getFavorite(s4)
		end

		if p7 == SduiDataBindingContentType.universeUserFollow then
			if b1 then
				return DataHydration.Game.getFollowingsStore(false).getAndFetchFollowing(s4)
			end

			return DataHydration.Game.getFollowingsStore(false).getFollowing(s4)
		end

		if p7 == SduiDataBindingContentType.universeUserVoteFeedbackMetadata then
			if b1 then
				return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata((tostring(s4)))
			end

			return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).getUserVoteFeedbackMetadata((tostring(s4)))
		end
	end

	if (FFlagSduiExperienceDetailsSupport or FFlagSduiDevStoreSeeAllSupport) and p7 == "gamePass" then
		return DataHydration.Game.getGamePassStore(false).getGamePassInfo((tostring(s4)))
	end

	if (FFlagSduiEventDetailsSupport or FFlagSduiExperienceDetailsSupport) and p7 == "event" then
		return DataHydration.ExperienceEvents.getExperienceEventInfoStore(false).getExperienceEventInfo(s4)
	end

	if FFlagSduiMarketplaceCatalogCategorySupport and p7 == "marketplaceCatalogCategory" then
		return DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).getMarketplaceCatalogCategory(s4)
	end

	if FFlagSduiMarketplaceCatalogSortSupport and p7 == "marketplaceCatalogSort" then
		return DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).getMarketplaceCatalogSort(s4)
	end

	if p7 == "song" then
		return DataHydration.Song.getSongInfoStore(false).getSongInfo((tostring(s4)))
	end

	if FFlagSduiAddMarketplaceEntityDataHydration then
		if p7 == "marketplaceAsset" then
			return DataHydration.MarketplaceAsset.getMarketplaceAssetStore(false).getMarketplaceAssetInfo(s4)
		end

		if p7 == "marketplaceBundle" then
			return DataHydration.MarketplaceBundle.getMarketplaceBundleStore(false).getMarketplaceBundleInfo(s4)
		end

		if p7 == "marketplaceLook" then
			return DataHydration.MarketplaceLook.getMarketplaceLookStore(false).getMarketplaceLookInfo(s4)
		end
	end

	if FFlagSduiDevStoreSeeAllSupport then
		if p7 == "gameDeveloperProduct" then
			return DataHydration.Game.getGameDeveloperProductStore(false).getGameDeveloperProductInfo((tostring(s4)))
		end

		if p7 == "gameSubscription" then
			return DataHydration.Game.getGameSubscriptionStore(false).getGameSubscriptionInfo((tostring(s4)))
		end
	end

	return nil
end

local t22 = {
	responsive = true,
	policy = not not FFlagSduiAppPolicyBindings or nil,
	clientPageScope = not not FFlagSduiClientPageScope or nil,
	capability = not not FFlagSduiCapabilityBindings or nil
}

local function calculateDerivedFieldValue(p8, s5: string, p9, p10) -- line: 449
	-- upvalues: calculateBadgeDerivedField (copy), FFlagSduiExperienceDetailsSupport (copy), calculateUniverseDerivedField (copy), calculateAgeRecommendationDerivedField (copy), SduiDataBindingContentType (copy), DataHydration (copy), FFlagSduiEventDetailsSupport (copy), getSduiServiceDependenciesStore (copy)
	if p8 == "badge" then
		return (calculateBadgeDerivedField(s5, p9, p10))
	end

	if FFlagSduiExperienceDetailsSupport then
		if p8 == "universe" then
			return calculateUniverseDerivedField(s5, p9, p10)
		end

		if p8 == "ageRecommendation" then
			return (calculateAgeRecommendationDerivedField(s5, p9, p10))
		end

		if p8 == SduiDataBindingContentType.universeUserVoteFeedbackMetadata then
			return DataHydration.Game.getUserVoteFeedbackMetadataStore(false).calculateDerivedField(s5, p9, p10)
		end
	end

	if (FFlagSduiExperienceDetailsSupport or FFlagSduiEventDetailsSupport) and p8 == "event" then
		local v133 = DataHydration.ExperienceEvents.getExperienceEventInfoStore(false)
		local localization = getSduiServiceDependenciesStore().getDependencies("SduiDataBinder").localization

		return v133.calculateDerivedField(s5, p9, p10, localization)
	end

	return nil
end
local function getUniverseIcon(s6: string, p11, p12) -- line: 500
	-- upvalues: DataHydration (copy)
	local v138 = DataHydration.Game.getGameIconStore(false).getAndFetchGameIcon(tostring(s6), p12)
	local v139 = v138.data(p11)
	local v140 = v138.status(p11)

	if v139 and v139.url then
		return v139.url, v140
	end

	return nil, v140
end
local function getDataHydrationField(p13, t23: {[any]: any}, s7: string, p14, b2: boolean?) -- line: 515
	-- upvalues: FFlagSduiGameIconSupport (copy), getUniverseIcon (copy), DataHydration (copy), getDataObjectSignal (copy), tryGetPathFromData (copy), calculateDerivedFieldValue (copy)
	if #t23 < 2 then
		return nil, nil
	end

	if FFlagSduiGameIconSupport and p13 == "universe" and #t23 == 2 then
		if t23[2] == "icon" then
			return getUniverseIcon(s7, p14)
		end

		if t23[2] == "largeIcon" then
			return getUniverseIcon(s7, p14, DataHydration.Game.GameIconSize.Large)
		end
	end

	local v146 = getDataObjectSignal(p13, t23, s7, b2)

	if not v146 then
		local v147 = table.concat(t23, ".")

		error(`No available data object for { p13 } { v147 } for id: { s7 }`)
	end

	local v148 = v146.data(p14)
	local v149 = v146.status(p14)

	if not v148 then
		return nil, v149
	end

	local v150, v151 = tryGetPathFromData(v148, t23, 2)

	if v150 then
		return v151, v149
	end

	if #t23 == 2 then
		local v152 = t23[2]

		return calculateDerivedFieldValue(p13, v152, v148, p14), v149
	end

	return nil, v149
end

local t24 = {
	badge = getDataHydrationField,
	creator = getDataHydrationField,
	universe = getDataHydrationField,
	ageRecommendation = if not FFlagSduiExperienceDetailsSupport then nil else getDataHydrationField,
	mediaAsset = if not FFlagSduiExperienceDetailsSupport then nil else getDataHydrationField,
	socialLink = if not FFlagSduiExperienceDetailsSupport then nil else getDataHydrationField,
	event = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else getDataHydrationField,
	marketplaceCatalogCategory = if not FFlagSduiMarketplaceCatalogCategorySupport then nil else getDataHydrationField,
	marketplaceCatalogSort = if not FFlagSduiMarketplaceCatalogSortSupport then nil else getDataHydrationField,
	marketplaceAsset = if not FFlagSduiAddMarketplaceEntityDataHydration then nil else getDataHydrationField,
	marketplaceBundle = if not FFlagSduiAddMarketplaceEntityDataHydration then nil else getDataHydrationField,
	marketplaceLook = if not FFlagSduiAddMarketplaceEntityDataHydration then nil else getDataHydrationField,
	song = getDataHydrationField,
	gamePass = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiDevStoreSeeAllSupport then nil else getDataHydrationField,
	gameDeveloperProduct = if not FFlagSduiDevStoreSeeAllSupport then nil else getDataHydrationField,
	gameSubscription = if not FFlagSduiDevStoreSeeAllSupport then nil else getDataHydrationField,
	playability = if not FFlagSduiExperienceDetailsSupport then nil else getDataHydrationField,
	universeUserVote = if not FFlagSduiExperienceDetailsSupport then nil else getDataHydrationField,
	universeUserFavorite = if not FFlagSduiExperienceDetailsSupport then nil else getDataHydrationField,
	universeUserFollow = if not FFlagSduiExperienceDetailsSupport then nil else getDataHydrationField,
	universeUserVoteFeedbackMetadata = if not FFlagSduiExperienceDetailsSupport then nil else getDataHydrationField,
	userProfile = if not FFlagSduiExperienceDetailsSupport then nil else DataHydration.UserProfile and DataHydration.UserProfile.resolveField
}

return {
	updateDataStores = function(t25: {[any]: any}) -- line: 627
		-- upvalues: DataHydration (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiDevStoreSeeAllSupport (copy), FFlagSduiEventDetailsSupport (copy), FFlagSduiMarketplaceCatalogCategorySupport (copy), FFlagSduiMarketplaceCatalogSortSupport (copy), FFlagSduiAddMarketplaceEntityDataHydration (copy)
		if t25.badge then
			local badge = t25.badge

			DataHydration.Badges.getBadgeInfoStore(false).updateBadges(badge)
		end

		if t25.creator then
			local creator = t25.creator

			DataHydration.Creator.getCreatorInfoStore(false).updateCreatorInfos(creator)
		end

		if t25.universe then
			local universe = t25.universe

			DataHydration.Game.getGameInfoStore(false).updateGameInfos(universe)
		end

		if FFlagSduiExperienceDetailsSupport then
			if t25.ageRecommendation then
				local ageRecommendation = t25.ageRecommendation

				DataHydration.Game.getAgeRecommendationStore(false).updateAgeRecommendations(ageRecommendation)
			end

			if t25.socialLink then
				local socialLink = t25.socialLink

				DataHydration.SocialLink.getSocialLinkInfoStore(false).updateSocialLinkInfos(socialLink)
			end

			if t25.mediaAsset then
				local mediaAsset = t25.mediaAsset

				DataHydration.MediaAsset.getMediaAssetStore(false).updateMediaAssets(mediaAsset)
			end

			if t25.playability then
				local playability = t25.playability

				DataHydration.Game.getPlayabilityStore(false).updatePlayabilities(playability)
			end

			if t25.universeUserFavorite then
				local universeUserFavorite = t25.universeUserFavorite

				DataHydration.Game.getFavoritesStore(false).updateItems(universeUserFavorite)
			end

			if t25.universeUserVote then
				local universeUserVote = t25.universeUserVote

				DataHydration.Game.getVotesStore(false).updateUserVoteItems(universeUserVote)
			end

			if t25.userProfile then
				DataHydration.UserProfile.updateFromHydration(t25.userProfile)
			end
		end

		if (FFlagSduiExperienceDetailsSupport or FFlagSduiDevStoreSeeAllSupport) and t25.gamePass then
			local gamePass = t25.gamePass

			DataHydration.Game.getGamePassStore(false).updateGamePassInfos(gamePass)
		end

		if (FFlagSduiExperienceDetailsSupport or FFlagSduiEventDetailsSupport) and t25.event then
			local event = t25.event

			DataHydration.ExperienceEvents.getExperienceEventInfoStore(false).updateExperienceEventInfos(event)
		end

		if FFlagSduiMarketplaceCatalogCategorySupport and t25.marketplaceCatalogCategory then
			local marketplaceCatalogCategory = t25.marketplaceCatalogCategory

			DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false).updateMarketplaceCatalogCategories(marketplaceCatalogCategory)
		end

		if FFlagSduiMarketplaceCatalogSortSupport and t25.catalogSort then
			local catalogSort = t25.catalogSort

			DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false).updateMarketplaceCatalogSorts(catalogSort)
		end

		if t25.song then
			DataHydration.Song.getSongInfoStore(false).updateSongs(t25.song)
		end

		if FFlagSduiAddMarketplaceEntityDataHydration then
			if t25.marketplaceAsset then
				local marketplaceAsset = t25.marketplaceAsset

				DataHydration.MarketplaceAsset.getMarketplaceAssetStore(false).updateMarketplaceAssetInfos(marketplaceAsset)
			end

			if t25.marketplaceBundle then
				local marketplaceBundle = t25.marketplaceBundle

				DataHydration.MarketplaceBundle.getMarketplaceBundleStore(false).updateMarketplaceBundleInfos(marketplaceBundle)
			end

			if t25.marketplaceLook then
				local marketplaceLook = t25.marketplaceLook

				DataHydration.MarketplaceLook.getMarketplaceLookStore(false).updateMarketplaceLookInfos(marketplaceLook)
			end
		end

		if FFlagSduiDevStoreSeeAllSupport then
			if t25.gameDeveloperProduct then
				local gameDeveloperProduct = t25.gameDeveloperProduct

				DataHydration.Game.getGameDeveloperProductStore(false).updateGameDeveloperProductInfos(gameDeveloperProduct)
			end

			if t25.gameSubscription then
				local gameSubscription = t25.gameSubscription

				DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfos(gameSubscription)
			end
		end
	end,
	getDataObjectSignal = getDataObjectSignal,
	getFieldValue = function(p15, t26: {[any]: any}, s8: string, p16, b3: boolean?) -- line: 604
		-- upvalues: t24 (copy)
		if #t26 < 2 then
			return nil, nil
		end

		local v158 = t24[p15]

		if v158 == nil then
			return nil, nil
		end

		return v158(p15, t26, s8, p16, b3)
	end,
	calculateBadgeDerivedField = calculateBadgeDerivedField,
	calculateUniverseDerivedField = calculateUniverseDerivedField,
	isClientContentType = function(p17) -- line: 350
		-- upvalues: t22 (copy)
		return t22[p17] or false
	end,
	getFieldValueForClientContentType = function(p18, t27: {[any]: any}, p19, p20) -- line: 354
		-- upvalues: FFlagSduiClientPageScope (copy), SduiDataBindingContentType (copy), getSduiClientPageScope (copy), SduiDataBindingResponsiveFieldName (copy), Display (copy), Responsive (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagLuaAppEdpKeepFullPageOnPortraitRotation (copy), FFlagSduiCapabilityBindings (copy), SduiCapabilities (copy), FFlagSduiAppPolicyBindings (copy), getSduiPolicyStore (copy), resolveSduiPolicyField (copy), tryGetPathFromData (copy)
		if FFlagSduiClientPageScope and p18 == SduiDataBindingContentType.clientPageScope then
			local v109 = if not p20 then nil else p20.configKey

			if not v109 or #t27 < 2 then
				return nil
			end

			local v110 = t27[2]

			return getSduiClientPageScope(v109).getSignal(v110)(p19), nil
		end

		if p18 == SduiDataBindingContentType.responsive then
			if #t27 ~= 2 then
				return nil
			end

			local v111 = t27[2]

			if v111 == SduiDataBindingResponsiveFieldName.screenWidth then
				return Display.GetDisplayStore(p19).getViewportSize(p19).X
			end

			if v111 == SduiDataBindingResponsiveFieldName.screenHeight then
				return Display.GetDisplayStore(p19).getViewportSize(p19).Y
			end

			if v111 == SduiDataBindingResponsiveFieldName.isPortrait then
				local v112 = Display.GetDisplayStore(p19).getViewportSize(p19)

				return v112.X < v112.Y
			end

			if v111 == SduiDataBindingResponsiveFieldName.isSpatial then
				return Display.GetDisplayStore(p19).getIsSpatial(p19)
			end

			if v111 == SduiDataBindingResponsiveFieldName.lastInput then
				return Responsive.GetInputModeStore(p19).getLastInputType(p19)
			end

			if v111 == SduiDataBindingResponsiveFieldName.preferredInput then
				return Responsive.GetInputModeStore(p19).getPreferredInputType(p19)
			end

			if FFlagSduiExperienceDetailsSupport and v111 == SduiDataBindingResponsiveFieldName.isCompactTouch then
				if FFlagLuaAppEdpKeepFullPageOnPortraitRotation then
					local v113 = Display.GetDisplayStore(p19).getViewportSize(p19)
					local v114 = Responsive.GetInputModeStore(p19).getPreferredInputType(p19)

					return Responsive.getIsCompactTouch(v113, v114)
				end

				local v115 = Display.GetDisplayStore(p19).getViewportSize(p19)
				local v116 = Responsive.GetInputModeStore(p19).getPreferredInputType(p19)
				local maxWidth = Responsive.BreakpointConfig.sizes[Responsive.Keys.Small].maxWidth
				local v118 = v115.X < v115.Y

				return maxWidth >= v115.X and (v118 and v116 == Responsive.Input.Touch)
			end
		end

		if FFlagSduiCapabilityBindings and p18 == SduiDataBindingContentType.capability then
			if #t27 < 2 then
				return nil
			end

			return SduiCapabilities.isEnabled(t27[2])
		end

		if FFlagSduiAppPolicyBindings and p18 == SduiDataBindingContentType.policy then
			if #t27 < 2 then
				return nil
			end

			local v119 = getSduiPolicyStore().getAppPolicy(p19)

			if v119 == nil then
				local v120 = table.concat(t27, ".")

				error(`Failed to find policy table when binding value { v120 }`)
			end

			local v121 = t27[2]
			local v122, v123 = resolveSduiPolicyField(v119, v121)

			if v122 then
				return v123
			end

			local v124 = v119.getRawPolicy()

			if v124 then
				local v125, v126 = tryGetPathFromData(v124, t27, 2)

				if v125 then
					return v126
				end

				local v127 = table.concat(t27, ".")

				error(`Failed to find policy value for '{ v127 }'`)
			else
				local v128 = table.concat(t27, ".")

				error(`Failed to find rawPolicy table when binding value { v128 }`)
			end
		end

		return nil
	end,
	calculateAgeRecommendationDerivedField = calculateAgeRecommendationDerivedField
}
