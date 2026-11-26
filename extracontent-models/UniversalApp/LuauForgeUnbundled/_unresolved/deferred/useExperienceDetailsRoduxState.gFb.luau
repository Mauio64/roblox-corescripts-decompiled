local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local url = require("@game/CorePackages/Workspace/Packages/Http").Url
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local useGameProductInfoSelector = require("@luauforge/bundled/cAZ").useGameProductInfoSelector
local gameMediaImageType = require("@luauforge/bundled/cBc").GameMediaImageType
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = RobloxAppEnums.UiMode
local toLegacyGameInfoModel = require("@luauforge/bundled/dCP").toLegacyGameInfoModel
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local module4 = require("@luauforge/deferred/gBI")
local module5 = require("@luauforge/deferred/gFc")
local module6 = require("@luauforge/deferred/gFd")
local module7 = require("@luauforge/deferred/gFe")

local fFlagLuaAppEdpFixDefaultBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpFixDefaultBanner

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

				if v12 == nil then
					return {
						url = string.format("rbxthumb://type=GameIcon&id=%s&w=512&h=512", p2.universeId),
						imageSize = "512x512"
					}
				end

				return v12
			else
				local v12 = v7

				if v12 == nil then
					return {
						url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", p2.universeId),
						imageSize = "150x150"
					}
				end

				return v12
			end
		end)
	else
		local v9 = v7
		v8 = v9 == nil
			and {
				url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", p2.universeId),
				imageSize = "150x150"
			}
			or v9
	end

	local v9

	if fFlagLuaAppEdpFixDefaultBanner then
		v9 = nil
	else
		v9 = useSelector(function(p4)
			local fetchingStatus = module4.GetFetchingStatus(p4, p2.universeId)

			local v10 = v5(p4.GameMedia[p2.universeId], p2.placeId, fetchingStatus)

			if v10 then
				return v10.imageId
			end

			return nil
		end)
	end

	local v10 = GameHydrationReact.useGameInfo(p2.universeId)

	local function fn()
		if v10 == nil or v10.rootPlaceId == nil then
			return nil
		end

		return (toLegacyGameInfoModel(v10))
	end

	local v13 = React.useMemo(fn, { if fFlagLuaAppAllowNilHookDepsCleanup then v10 else v10 or false })

	local v14 = useSelector(function(p4)
		return p4.GameDetailsV2[p2.universeId]
	end)

	local v15 = useSelector(function(p4)
		return p4.GameDetailErrors[p2.universeId]
	end)
	local v16

	if fFlagLuaAppEdpFixDefaultBanner then
		v9 = useSelector(function(p4)
			local v17 = v5(p4.GameMedia[p2.universeId])

			if v17 then
				return v17.imageId
			end

			return nil
		end)

		v16 = useSelector(function(p4)
			local rootPlaceId = v14 and v14.rootPlaceId or v13 and v13.placeId or nil
			local fetchingStatus = module4.GetFetchingStatus(p4, p2.universeId)

			if v9 ~= nil or not rootPlaceId then
				return nil
			end

			if fetchingStatus == retrievalStatus.Done then
				return url:getPlaceDefaultThumbnailUrl(rootPlaceId, 768, 432)
			end

			return nil
		end)
	end

	local v17 = useSelector(function(p4)
		if module5() then
			return nil
		end

		return (VerifiedBadges.isCreatorOfGameVerified(p4, {
			universeId = p2.universeId,
			shouldUseV2GameDetails = true
		}))
	end)

	local v18 = useSelector(function(p4)
		return module4.GetFetchingStatus(p4, p2.universeId)
	end)

	local v19 = useGameProductInfoSelector(p2.universeId)

	local v20 = useSelector(function(p4)
		local gameSocialLink = p4.GameSocialLinks[p2.universeId]

		if gameSocialLink then
			return gameSocialLink.externalLinks
		end

		return nil
	end)

	local v21 = useSelector(function(p4)
		return p4.AgeRecommendations[p2.universeId]
	end)

	local v22 = useSelector(function(p4)
		return p4.CommunityLinks.ExperienceCommunityLinks[p2.universeId] or nil
	end)

	local v23 = useSelector(function(p4)
		return p4.GameFollowings[p2.universeId]
	end)

	local v24 = useSelector(function(p4)
		return p4.ExperienceNotificationsEnabled
	end)

	local v25 = {
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
		v16 = nil
	end

	v25.defaultBannerUrl = v16
	v25.gameInfo = v13
	v25.gameDetail = v14
	v25.gameDetailError = v15
	v25.creatorVerified = v17
	v25.gameDetailsPageDataStatus = v18
	v25.gameProductInfo = v19
	v25.socialLinks = v20
	v25.ageRecommendations = v21
	v25.communityLink = v22
	v25.gameFollowings = v23
	v25.notificationsEnabled = v24
	return v25
end

return useExperienceDetailsRoduxState
