local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local url = require("@game/CorePackages/Workspace/Packages/Http").Url
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local apiFetchGameDetails = require("@luauforge/bundled/dyi").GameDetails.ApiFetchGameDetails
local useGameProductInfoSelector = require("@luauforge/bundled/cyL").useGameProductInfoSelector
local gameMediaImageType = require("@luauforge/bundled/cyO").GameMediaImageType
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = RobloxAppEnums.UiMode
local useGameInfosSelector = require("@luauforge/bundled/dzK").useGameInfosSelector
local toLegacyGameInfoModel = require("@luauforge/bundled/dzK").toLegacyGameInfoModel
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local apiFetchGameMedia = require("@luauforge/bundled/dpZ").Modules.LuaApp.Thunks.Games.ApiFetchGameMedia

local module4 = require("@luauforge/deferred/fWL")
local module5 = require("@luauforge/deferred/gau")
local module6 = require("@luauforge/deferred/fYN")
local module7 = require("@luauforge/deferred/fYO")

local fFlagLuaAppEdpFixDefaultBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpFixDefaultBanner

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore

local fFlagLuaAppAllowNilHookDepsCleanup = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAllowNilHookDepsCleanup

local function generateDefaultEntry(p2)
	return {
		mediaType = gameMediaImageType.Image,
		imageId = url:getPlaceDefaultThumbnailUrl(p2, 768, 432)
	}
end

local v5 = memoize(function(items, p2, p3)
	local v6 = nil

	if items then
		for k, item in pairs(items) do
			if item.assetTypeId == gameMediaImageType.Image then
				v6 = item
				break
			end
		end
	end

	if fFlagLuaAppEdpFixDefaultBanner or v6 ~= nil then
		return v6
	end

	if p3 == retrievalStatus.Done then
		return {
			mediaType = gameMediaImageType.Image,
			imageId = url:getPlaceDefaultThumbnailUrl(p2, 768, 432)
		}
	end

	return nil
end)

local function useExperienceDetailsRoduxState(p2, p3)
	local v6 = GameHydrationReact.useGameIcon(p2.universeId)
	local v7 = v6 and { url = v6, imageSize = "150x150" } or nil
	local v8

	if module7() and module6() then
		local v9 = useUiModeInfo()

		local v10 = GameHydrationReact.useLargeGameIcon(p2.universeId)
		local v11 = v10 and { url = v10, imageSize = "512x512" } or nil
		v8 = useSelector(function(p4)
			if v9 and v9.uiMode == uiMode.TenFoot then
				local v12 = v11

				if
					fFlagLuaAppEdpBackendV2HydrateLegacyDefault
					or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3
				then
					if v12 == nil then
						return {
							url = string.format("rbxthumb://type=GameIcon&id=%s&w=512&h=512", p2.universeId),
							imageSize = "512x512"
						}
					end

					return v12
				end

				return v12 or v7
			else
				local v12 = v7

				if
					(fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3)
					and v12 == nil
				then
					return {
						url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", p2.universeId),
						imageSize = "150x150"
					}
				end

				return v12
			end
		end)
	elseif fFlagLuaAppEdpBackendV2HydrateLegacyIxp or fFlagLuaAppEdpBackendV2HydrateLegacyDefault then
		v8 = (fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3)
			and v7 == nil
			and {
				url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", p2.universeId),
				imageSize = "150x150"
			}
			or v7
	else
		v8 = v7
	end

	local v9

	if fFlagLuaAppEdpFixDefaultBanner then
		v9 = nil
	else
		v9 = useSelector(function(p4)
			local v10

			if
				fFlagLuaAppEdpBackendV2HydrateLegacyDefault
				or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3
			then
				v10 = module4.GetFetchingStatus(p4, p2.universeId)
			else
				v10 = apiFetchGameMedia.GetFetchingStatus(p4, p2.universeId)
			end

			local v11 = v5(p4.GameMedia[p2.universeId], p2.placeId, v10)

			if v11 then
				return v11.imageId
			end

			return nil
		end)
	end

	local v10

	if fFlagMigrateGameInfoToStore then
		local v11 = GameHydrationReact.useGameInfo(p2.universeId)

		local function fn()
			if v11 == nil or v11.rootPlaceId == nil then
				return nil
			end

			return (toLegacyGameInfoModel(v11))
		end

		v10 = React.useMemo(fn, { if fFlagLuaAppAllowNilHookDepsCleanup then v11 else v11 or false })
	else
		v10 = useGameInfosSelector(p2.universeId)
	end

	local v11 = useSelector(function(p4)
		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3
		then
			return p4.GameDetailsV2[p2.universeId]
		end

		return p4.GameDetails[p2.universeId]
	end)

	local v12 = useSelector(function(p4)
		return p4.GameDetailErrors[p2.universeId]
	end)
	local v13

	if fFlagLuaAppEdpFixDefaultBanner then
		v9 = useSelector(function(p4)
			local v14 = v5(p4.GameMedia[p2.universeId])

			if v14 then
				return v14.imageId
			end

			return nil
		end)

		v13 = useSelector(function(p4)
			local rootPlaceId = v11 and v11.rootPlaceId or v10 and v10.placeId or nil
			local v14

			if
				fFlagLuaAppEdpBackendV2HydrateLegacyDefault
				or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3
			then
				v14 = module4.GetFetchingStatus(p4, p2.universeId)
			else
				v14 = apiFetchGameMedia.GetFetchingStatus(p4, p2.universeId)
			end

			if v9 ~= nil or not rootPlaceId then
				return nil
			end

			if v14 == retrievalStatus.Done then
				return url:getPlaceDefaultThumbnailUrl(rootPlaceId, 768, 432)
			end

			return nil
		end)
	end

	local v14 = useSelector(function(p4)
		if module5() then
			return nil
		end

		local isCreatorOfGameVerified = VerifiedBadges.isCreatorOfGameVerified
		local v15

		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3
		then
			v15 = { universeId = p2.universeId, shouldUseV2GameDetails = true }
		else
			v15 = p2
		end

		return (isCreatorOfGameVerified(p4, v15))
	end)

	local v15 = useSelector(function(p4)
		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p3
		then
			return module4.GetFetchingStatus(p4, p2.universeId)
		end

		return apiFetchGameDetails.GetFetchingStatus(p4, p2.universeId)
	end)

	local v16 = useGameProductInfoSelector(p2.universeId)

	local v17 = useSelector(function(p4)
		local gameSocialLink = p4.GameSocialLinks[p2.universeId]

		if gameSocialLink then
			return gameSocialLink.externalLinks
		end

		return nil
	end)

	local v18 = useSelector(function(p4)
		return p4.AgeRecommendations[p2.universeId]
	end)

	local v19 = useSelector(function(p4)
		return p4.CommunityLinks.ExperienceCommunityLinks[p2.universeId] or nil
	end)

	local v20 = useSelector(function(p4)
		return p4.GameFollowings[p2.universeId]
	end)

	local v21 = useSelector(function(p4)
		return p4.ExperienceNotificationsEnabled
	end)

	local v22 = {
		thumbnail = v8,
		bannerImageId = v9,
		defaultBannerUrl = nil,
		gameInfo = nil,
		gameDetail = nil,
		gameDetailError = nil,
		creatorVerified = nil,
		gameDetailsPageDataStatus = nil,
		gameProductInfo = nil,
		socialLinks = nil,
		ageRecommendations = nil,
		communityLink = nil,
		gameFollowings = nil,
		notificationsEnabled = nil
	}

	if not fFlagLuaAppEdpFixDefaultBanner then
		v13 = nil
	end

	v22.defaultBannerUrl = v13
	v22.gameInfo = v10
	v22.gameDetail = v11
	v22.gameDetailError = v12
	v22.creatorVerified = v14
	v22.gameDetailsPageDataStatus = v15
	v22.gameProductInfo = v16
	v22.socialLinks = v17
	v22.ageRecommendations = v18
	v22.communityLink = v19
	v22.gameFollowings = v20
	v22.notificationsEnabled = v21
	return v22
end

return useExperienceDetailsRoduxState
