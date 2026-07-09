local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ApiFetchGameMedia = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Thunks.Games.ApiFetchGameMedia
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local FetchGamePlayabilityAndProductInfo = require(CorePackages.Workspace.Packages.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local GameMediaImageType = require(CorePackages.Workspace.Packages.DiscoveryTypes).GameMediaImageType
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local Url = require(CorePackages.Workspace.Packages.Http).Url
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local useIsVideoEligible = require(CorePackages.Workspace.Packages.GameTile).useIsVideoEligible
local useCanDevicePlayVideoPreview = require(CorePackages.Workspace.Packages.VideoUtils).useCanDevicePlayVideoPreview
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppShareEdpVideoBlockingConfig = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppShareEdpVideoBlockingConfig
local v22 = nil
local v23 = nil
local v24 = nil
local v25 = nil
local v26 = nil
local v27 = nil
local v28 = nil
local v29 = nil

if not FFlagLuaAppShareEdpVideoBlockingConfig then
	v22 = game:DefineFastFlag("LuaAppEdpVideoManufacturerDeny2", false)
	v23 = game:DefineFastFlag("LuaAppEdpVideoDeviceDeny", false)
	v24 = game:DefineFastFlag("LuaAppEdpVideoMaxMemoryDeny", false)
	v25 = game:DefineFastInt("LuaAppEdpVideoMaxMemoryThresholdMb", -1)
	v26 = game:DefineFastFlag("LuaAppEdpVideoAvailableRamDeny", false)
	v27 = game:DefineFastInt("LuaAppEdpVideoAvailableRamThresholdMb", -1)
	v28 = game:DefineFastString("LuaAppEdpVideoDevicePipeDenyList", "")
	v29 = game:DefineFastString("LuaAppEdpVideoManufacturerPipeDenyList", "")
end

local u30 = if not FFlagLuaAppShareEdpVideoBlockingConfig then {
	enableManufacturerDeny = v22,
	enableDeviceDeny = v23,
	enableMaxMemoryDeny = v24,
	enableAvailableRamDeny = v26,
	manufacturerDenyList = v29,
	deviceDenyList = v28,
	maxMemoryThresholdMb = v25,
	availableRamThresholdMb = v27
} else require(CorePackages.Workspace.Packages.VideoUtils).EdpVideoBlockingConfig

local function getDefaultMediaEntry(p1) -- line: 75
	-- upvalues: GameMediaImageType (copy), Url (copy)
	return {
		mediaType = GameMediaImageType.Image,
		imageId = Url:getPlaceDefaultThumbnailUrl(p1, 640, 360)
	}
end
local function processedMediaEntry(p2, p3, b1: boolean?) -- line: 82
	-- upvalues: GameMediaImageType (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy)
	local assetTypeId = p2.assetTypeId
	local v39

	if assetTypeId == GameMediaImageType.YouTubeVideo then
		if not p3 then
			return nil
		end

		v39 = string.format("https://img.youtube.com/vi/%s/hqdefault.jpg", p2.youTubeVideoHash)
	else
		v39 = "http://www.roblox.com/asset/?id=" .. tostring(p2.imageId)
	end

	local v40 = if not FFlagLuaAppEdpMediaGalleryVideoPreview or (not b1 or (assetTypeId ~= GameMediaImageType.Video and assetTypeId ~= GameMediaImageType.GamePreviewVideo or not p2.videoId)) then nil else `rbxassetid://{ p2.videoId }`

	return {
		mediaType = p2.assetTypeId,
		imageId = v39,
		youTubeVideoHash = p2.youTubeVideoHash,
		youTubeVideoTitle = p2.youTubeVideoTitle,
		videoId = if not FFlagLuaAppEdpMediaGalleryVideoPreview or not b1 then nil else v40
	}
end
local function useSelectedGameMediaEntries(p4, p5, p6, b2: boolean?, b3: boolean?) -- line: 112
	-- upvalues: FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), useAppPolicy (copy), useSelector (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameInfosReducer (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchGameMedia (copy), FetchGamePlayabilityAndProductInfo (copy), useIsVideoEligible (copy), useCanDevicePlayVideoPreview (copy), u30 (ref), AppPage (copy), React (copy), RetrievalStatus (copy), GameMediaImageType (copy), Url (copy), processedMediaEntry (copy), ArgCheck (copy)
	local v46 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp or b2
	local v47 = useAppPolicy(function(p7) -- line: 123
		return p7.getShowVideoThumbnails()
	end)
	local v48 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then useSelector(function(p8) -- line: 129
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b3 (copy), p4 (copy), GameInfosReducer (copy)
		local v56 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not b3) then p8.GameDetails[p4] else p8.GameDetailsV2[p4]
		local v57 = p8.Personalization[GameInfosReducer.key][p4]

		return v56 and v56.rootPlaceId or v57 and v57.placeId
	end) else nil
	local v49 = useSelector(function(p9) -- line: 139
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b3 (copy), ApiFetchExperienceDetailsPage (copy), p4 (copy), ApiFetchGameMedia (copy)
		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and b3 then
			return ApiFetchExperienceDetailsPage.GetFetchingStatus(p9, p4)
		end

		return ApiFetchGameMedia.GetFetchingStatus(p9, p4)
	end)
	local v50 = useSelector(function(p10) -- line: 150
		-- upvalues: p4 (copy)
		return p10.GameMedia[p4]
	end)
	local u51 = nil
	local u52 = nil

	if FFlagLuaAppEdpMediaGalleryVideoPreview then
		u51 = useSelector(function(p11) -- line: 158
			-- upvalues: FetchGamePlayabilityAndProductInfo (copy), p4 (copy)
			return FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p11, p4)
		end)
		u52 = useIsVideoEligible(p4)
	end

	local v53 = useCanDevicePlayVideoPreview(u30, p4, AppPage.ExperienceDetail)

	return (React.useMemo(function() -- line: 169
		-- upvalues: v50 (copy), v49 (copy), RetrievalStatus (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), p5 (copy), v48 (copy), GameMediaImageType (copy), Url (copy), v46 (copy), processedMediaEntry (copy), v47 (copy), ArgCheck (copy), u51 (ref), u52 (ref), v53 (copy), p6 (copy)
		if not v50 then
			if v49 == RetrievalStatus.Done then
				local t1 = {}
				local v62 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then v48 else p5

				t1[1] = {
					mediaType = GameMediaImageType.Image,
					imageId = Url:getPlaceDefaultThumbnailUrl(v62, 640, 360)
				}

				return t1
			end

			return {}
		end

		local t2 = {}

		if FFlagLuaAppEdpMediaGalleryVideoPreview and v46 then
			local v64 = nil

			for _, v in ipairs(v50) do
				if v.assetTypeId == GameMediaImageType.Video or v.assetTypeId == GameMediaImageType.GamePreviewVideo then
					v64 = true

					break
				end
			end

			local v67 = nil

			for _, v in ipairs(v50) do
				local v70 = processedMediaEntry(v, v47, true)

				if v70 then
					if v70.mediaType == GameMediaImageType.Video or v70.mediaType == GameMediaImageType.GamePreviewVideo then
						ArgCheck.assert(v64)

						if u51 == RetrievalStatus.Done and u52 and v53() then
							ArgCheck.assert(not v67)
							table.insert(t2, 1, v70)
							v67 = true
						end
					elseif v70.mediaType == GameMediaImageType.YouTubeVideo then
						if not v64 or u51 == RetrievalStatus.Done and not u52 then
							if p6 then
								table.insert(t2, 1, v70)
							else
								table.insert(t2, v70)
							end
						end
					elseif v70.mediaType == GameMediaImageType.Image then
						table.insert(t2, v70)
					else
						warn("Unknown media type: " .. tostring(v70.mediaType))
					end
				end
			end
		else
			for _, v in ipairs(v50) do
				local v73 = processedMediaEntry(v, v47)

				if v73 then
					if v73.mediaType == GameMediaImageType.YouTubeVideo then
						if p6 then
							table.insert(t2, 1, v73)
						else
							table.insert(t2, v73)
						end
					elseif v73.mediaType == GameMediaImageType.Image then
						table.insert(t2, v73)
					else
						warn("Unknown media type: " .. tostring(v73.mediaType))
					end
				end
			end
		end

		return { unpack(t2, 1, 10) }
	end, {
		v47,
		p6,
		if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else b2,
		if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else v46,
		p4,
		if not FFlagLuaAppEdpMediaGalleryVideoPreview then v48 else p5,
		v49,
		v50,
		if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else u51,
		if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else u52,
		v53
	}))
end

return useSelectedGameMediaEntries
