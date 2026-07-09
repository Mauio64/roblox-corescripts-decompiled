local CorePackages = game:GetService("CorePackages")
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Url = require(CorePackages.Workspace.Packages.Http).Url
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local ApiFetchGameDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.ApiFetchGameDetails
local useGameProductInfoSelector = require(CorePackages.Workspace.Packages.GameProductInfoRodux).useGameProductInfoSelector
local GameMediaImageType = require(CorePackages.Workspace.Packages.DiscoveryTypes).GameMediaImageType
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = RobloxAppEnums.UiMode
local GameIconRodux = require(CorePackages.Workspace.Packages.GameIconRodux)
local GameIconReducer = GameIconRodux.GameIcons.GameIconReducer
local useGameIconSelector = GameIconRodux.GameIcons.useGameIconSelector
local BigGameIconReducer = GameIconRodux.BigGameIcons.BigGameIconReducer
local useGameInfosSelector = require(CorePackages.Workspace.Packages.GameInfosRodux).useGameInfosSelector
local ApiFetchGameMedia = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Thunks.Games.ApiFetchGameMedia
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local GetFFlagRemoveVerifiedBadgeReducer = require(Modules.LuaApp.Flags.GetFFlagRemoveVerifiedBadgeReducer)
local GetFFlagLuaAppLaunchConnectorFix = require(Modules.LuaApp.Flags.GetFFlagLuaAppLaunchConnectorFix)
local GetFFlagEnableBigGameIconInDetailsPage = require(Modules.LuaApp.Flags.GetFFlagEnableBigGameIconInDetailsPage)
local FFlagLuaAppEdpFixDefaultBanner = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpFixDefaultBanner
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local function generateDefaultEntry(p1) -- line: 39
	-- upvalues: GameMediaImageType (copy), Url (copy)
	return {
		mediaType = GameMediaImageType.Image,
		imageId = Url:getPlaceDefaultThumbnailUrl(p1, 768, 432)
	}
end

local v28 = memoize(function(p2, p3, p4) -- line: 46
	-- upvalues: GameMediaImageType (copy), FFlagLuaAppEdpFixDefaultBanner (copy), RetrievalStatus (copy), Url (copy)
	local v34 = nil

	if p2 then
		for _, v in pairs(p2) do
			if v.assetTypeId == GameMediaImageType.Image then
				v34 = v

				break
			end
		end
	end

	if not FFlagLuaAppEdpFixDefaultBanner and v34 == nil then
		if p4 == RetrievalStatus.Done then
			return {
				mediaType = GameMediaImageType.Image,
				imageId = Url:getPlaceDefaultThumbnailUrl(p3, 768, 432)
			}
		end

		return nil
	end

	return v34
end)

local function useExperienceDetailsRoduxState(p5, b1: boolean?) -- line: 72
	-- upvalues: GetFFlagEnableBigGameIconInDetailsPage (copy), GetFFlagLuaAppLaunchConnectorFix (copy), useUiModeInfo (copy), useSelector (copy), UiMode (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), BigGameIconReducer (copy), GameIconReducer (copy), useGameIconSelector (copy), FFlagLuaAppEdpFixDefaultBanner (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameMedia (copy), v28 (copy), useGameInfosSelector (copy), RetrievalStatus (copy), Url (copy), GetFFlagRemoveVerifiedBadgeReducer (copy), VerifiedBadges (copy), ApiFetchGameDetails (copy), useGameProductInfoSelector (copy)
	local v40

	if GetFFlagEnableBigGameIconInDetailsPage() and GetFFlagLuaAppLaunchConnectorFix() then
		local v39 = useUiModeInfo()

		v40 = useSelector(function(p6) -- line: 76
			-- upvalues: v39 (copy), UiMode (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), BigGameIconReducer (copy), p5 (copy), GameIconReducer (copy)
			if v39 and v39.uiMode == UiMode.TenFoot then
				if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and b1 then
					local v56 = p6[BigGameIconReducer.key][p5.universeId]

					if v56 == nil then
						return {
							imageSize = "512x512",
							url = string.format("rbxthumb://type=GameIcon&id=%s&w=512&h=512", p5.universeId)
						}
					end

					return v56
				end

				return p6[BigGameIconReducer.key][p5.universeId] or p6[GameIconReducer.key][p5.universeId]
			end

			if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and b1 then
				local v57 = p6[GameIconReducer.key][p5.universeId]

				if v57 == nil then
					return {
						imageSize = "150x150",
						url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", p5.universeId)
					}
				end

				return v57
			end

			return p6[GameIconReducer.key][p5.universeId]
		end)
	elseif FFlagLuaAppEdpBackendV2HydrateLegacyIxp or FFlagLuaAppEdpBackendV2HydrateLegacyDefault then
		local v41 = useGameIconSelector(p5.universeId)

		v40 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not b1) then v41 else if v41 ~= nil then v41 else {
			imageSize = "150x150",
			url = string.format("rbxthumb://type=GameIcon&id=%s&w=150&h=150", p5.universeId)
		}
	else
		v40 = useGameIconSelector(p5.universeId)
	end

	local u42 = nil

	if not FFlagLuaAppEdpFixDefaultBanner then
		u42 = useSelector(function(p7) -- line: 140
			-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), ApiFetchExperienceDetailsPage (copy), p5 (copy), ApiFetchGameMedia (copy), v28 (copy)
			local v59 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not b1) then ApiFetchGameMedia.GetFetchingStatus(p7, p5.universeId) else ApiFetchExperienceDetailsPage.GetFetchingStatus(p7, p5.universeId)
			local v60 = v28(p7.GameMedia[p5.universeId], p5.placeId, v59)

			if v60 then
				return v60.imageId
			end

			return nil
		end)
	end

	local v43 = useGameInfosSelector(p5.universeId)
	local v44 = useSelector(function(p8) -- line: 153
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), p5 (copy)
		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and b1 then
			return p8.GameDetailsV2[p5.universeId]
		end

		return p8.GameDetails[p5.universeId]
	end)
	local v45 = useSelector(function(p9) -- line: 164
		-- upvalues: p5 (copy)
		return p9.GameDetailErrors[p5.universeId]
	end)
	local v46 = nil

	if FFlagLuaAppEdpFixDefaultBanner then
		u42 = useSelector(function(p10) -- line: 170
			-- upvalues: v28 (copy), p5 (copy)
			local v64 = v28(p10.GameMedia[p5.universeId])

			if v64 then
				return v64.imageId
			end

			return nil
		end)
		v46 = useSelector(function(p11) -- line: 175
			-- upvalues: v44 (copy), v43 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), ApiFetchExperienceDetailsPage (copy), p5 (copy), ApiFetchGameMedia (copy), u42 (ref), RetrievalStatus (copy), Url (copy)
			local v66 = v44 and v44.rootPlaceId or (v43 and v43.placeId or nil)
			local v67 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not b1) then ApiFetchGameMedia.GetFetchingStatus(p11, p5.universeId) else ApiFetchExperienceDetailsPage.GetFetchingStatus(p11, p5.universeId)

			if u42 == nil and v66 then
				if v67 == RetrievalStatus.Done then
					return Url:getPlaceDefaultThumbnailUrl(v66, 768, 432)
				end

				return nil
			end

			return nil
		end)
	end

	local v47 = useSelector(function(p12) -- line: 196
		-- upvalues: GetFFlagRemoveVerifiedBadgeReducer (copy), VerifiedBadges (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), p5 (copy)
		if GetFFlagRemoveVerifiedBadgeReducer() then
			return nil
		end

		return (VerifiedBadges.isCreatorOfGameVerified(p12, if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not b1) then p5 else {
			shouldUseV2GameDetails = true,
			universeId = p5.universeId
		}))
	end)
	local v48 = useSelector(function(p13) -- line: 212
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), ApiFetchExperienceDetailsPage (copy), p5 (copy), ApiFetchGameDetails (copy)
		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and b1 then
			return ApiFetchExperienceDetailsPage.GetFetchingStatus(p13, p5.universeId)
		end

		return ApiFetchGameDetails.GetFetchingStatus(p13, p5.universeId)
	end)
	local v49 = useGameProductInfoSelector(p5.universeId)
	local v50 = useSelector(function(p14) -- line: 225
		-- upvalues: p5 (copy)
		local v71 = p14.GameSocialLinks[p5.universeId]

		if v71 then
			return v71.externalLinks
		end

		return nil
	end)
	local v51 = useSelector(function(p15) -- line: 230
		-- upvalues: p5 (copy)
		return p15.AgeRecommendations[p5.universeId]
	end)
	local v52 = useSelector(function(p16) -- line: 234
		-- upvalues: p5 (copy)
		return p16.CommunityLinks.ExperienceCommunityLinks[p5.universeId] or nil
	end)
	local v53 = useSelector(function(p17) -- line: 239
		-- upvalues: p5 (copy)
		return p17.GameFollowings[p5.universeId]
	end)
	local v54 = useSelector(function(p18) -- line: 243
		return p18.ExperienceNotificationsEnabled
	end)

	return {
		thumbnail = v40,
		bannerImageId = u42,
		defaultBannerUrl = if not FFlagLuaAppEdpFixDefaultBanner then nil else v46,
		gameInfo = v43,
		gameDetail = v44,
		gameDetailError = v45,
		creatorVerified = v47,
		gameDetailsPageDataStatus = v48,
		gameProductInfo = v49,
		socialLinks = v50,
		ageRecommendations = v51,
		communityLink = v52,
		gameFollowings = v53,
		notificationsEnabled = v54
	}
end

return useExperienceDetailsRoduxState
