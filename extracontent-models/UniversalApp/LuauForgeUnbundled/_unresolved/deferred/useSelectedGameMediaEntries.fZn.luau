local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local apiFetchGameMedia = require("@luauforge/bundled/dpZ").Modules.LuaApp.Thunks.Games.ApiFetchGameMedia
local module = require("@luauforge/bundled/dwM")

local fetchGamePlayabilityAndProductInfo = require("@luauforge/bundled/dyi").FetchGamePlayabilityAndProductInfo
local gameInfosReducer = require("@luauforge/bundled/dzK").GameInfosReducer
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local gameMediaImageType = require("@luauforge/bundled/cyO").GameMediaImageType
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local url = require("@game/CorePackages/Workspace/Packages/Http").Url
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local useIsVideoEligible = require("@luauforge/bundled/fYU").useIsVideoEligible
local useCanDevicePlayVideoPreview = require("@luauforge/bundled/fZd").useCanDevicePlayVideoPreview
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module3 = require("@luauforge/deferred/fWL")

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMigrateGameInfoToStore

local edpVideoBlockingConfig = require("@luauforge/bundled/fZd").EdpVideoBlockingConfig

local function getDefaultMediaEntry(p2)
	return {
		mediaType = gameMediaImageType.Image,
		imageId = url:getPlaceDefaultThumbnailUrl(p2, 640, 360)
	}
end

local function processedMediaEntry(data, p2, p3)
	local assetTypeId = data.assetTypeId
	local v5

	if assetTypeId == gameMediaImageType.YouTubeVideo then
		if not p2 then
			return nil
		end

		v5 = string.format("https://img.youtube.com/vi/%s/hqdefault.jpg", data.youTubeVideoHash)
	else
		v5 = "http://www.roblox.com/asset/?id=" .. tostring(data.imageId)
	end

	local v6

	if
		fFlagLuaAppEdpMediaGalleryVideoPreview
		and p3
		and (assetTypeId == gameMediaImageType.Video or assetTypeId == gameMediaImageType.GamePreviewVideo)
		and data.videoId
	then
		v6 = `rbxassetid://{data.videoId}`
	end

	local v7 = {
		mediaType = data.assetTypeId,
		imageId = v5,
		youTubeVideoHash = data.youTubeVideoHash,
		youTubeVideoTitle = data.youTubeVideoTitle,
		videoId = 0
	}

	if not (fFlagLuaAppEdpMediaGalleryVideoPreview and p3) then
		v6 = nil
	end

	v7.videoId = v6
	return v7
end

local function useSelectedGameMediaEntries(p2, p3, p4, p5, p6)
	local v5

	if fFlagLuaAppEdpMediaGalleryVideoPreview then
		v5 = not fFlagLuaAppEdpMediaGalleryVideoPreviewIxp or p5
	else
		v5 = nil
	end

	local v6 = useAppPolicy(function(p7)
		return p7.getShowVideoThumbnails()
	end)
	local rootPlaceId

	if fFlagMigrateGameInfoToStore then
		local v7 = GameHydrationReact.useGameInfo(p2)
		rootPlaceId = v7 and v7.rootPlaceId
	end

	local v7

	if fFlagLuaAppEdpMediaGalleryVideoPreview then
		v7 = nil
	else
		v7 = useSelector(function(data)
			local v8

			if
				fFlagLuaAppEdpBackendV2HydrateLegacyDefault
				or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p6
			then
				v8 = data.GameDetailsV2[p2]
			else
				v8 = data.GameDetails[p2]
			end

			if fFlagMigrateGameInfoToStore then
				return v8 and v8.rootPlaceId
			end

			local v9 = data.Personalization[gameInfosReducer.key][p2]

			return v8 and v8.rootPlaceId or v9 and v9.placeId
		end)
	end

	if fFlagMigrateGameInfoToStore then
		v7 = v7 or rootPlaceId
	end

	local v8 = useSelector(function(p7)
		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p6
		then
			return module3.GetFetchingStatus(p7, p2)
		end

		return apiFetchGameMedia.GetFetchingStatus(p7, p2)
	end)

	local v9 = useSelector(function(p7)
		return p7.GameMedia[p2]
	end)
	local v10, v11

	if fFlagLuaAppEdpMediaGalleryVideoPreview then
		v10 = useSelector(function(p7)
			return fetchGamePlayabilityAndProductInfo.GetFetchingStatus(p7, p2)
		end)

		v11 = useIsVideoEligible(p2)
	else
		v10 = nil
		v11 = nil
	end

	local v12 = useCanDevicePlayVideoPreview(edpVideoBlockingConfig, p2, appPage.ExperienceDetail)

	local useMemo = React.useMemo
	local function fn()
		if v9 then
			local v13 = {}

			if fFlagLuaAppEdpMediaGalleryVideoPreview and v5 then
				local v14 = nil

				for i, v16 in ipairs(v9) do
					if
						v16.assetTypeId == gameMediaImageType.Video
						or v16.assetTypeId == gameMediaImageType.GamePreviewVideo
					then
						v14 = true
						break
					end
				end

				local v16 = nil

				for i, v17 in ipairs(v9) do
					local v18 = processedMediaEntry(v17, v6, true)

					if not v18 then
						continue
					end

					if
						v18.mediaType == gameMediaImageType.Video
						or v18.mediaType == gameMediaImageType.GamePreviewVideo
					then
						module.assert(v14)

						if v10 == retrievalStatus.Done and v11 and v12() then
							module.assert(not v16)

							table.insert(v13, 1, v18)
							v16 = true
						end
					elseif v18.mediaType == gameMediaImageType.YouTubeVideo then
						if not v14 or v10 == retrievalStatus.Done and not v11 then
							if p4 then
								table.insert(v13, 1, v18)
							else
								table.insert(v13, v18)
							end
						end
					elseif v18.mediaType == gameMediaImageType.Image then
						table.insert(v13, v18)
					else
						warn("Unknown media type: " .. tostring(v18.mediaType))
					end
				end
			else
				for i, v14 in ipairs(v9) do
					local v15 = processedMediaEntry(v14, v6)

					if not v15 then
						continue
					end

					if v15.mediaType == gameMediaImageType.YouTubeVideo then
						if p4 then
							table.insert(v13, 1, v15)
						else
							table.insert(v13, v15)
						end
					elseif v15.mediaType == gameMediaImageType.Image then
						table.insert(v13, v15)
					else
						warn("Unknown media type: " .. tostring(v15.mediaType))
					end
				end
			end

			return { unpack(v13, 1, 10) }
		else
			if v8 ~= retrievalStatus.Done then
				return {}
			end

			local v14 = if fFlagLuaAppEdpMediaGalleryVideoPreview then p3 else v7
			return {
				{
					mediaType = gameMediaImageType.Image,
					imageId = url:getPlaceDefaultThumbnailUrl(v14, 640, 360)
				}
			}
		end
	end

	if not fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
		p5 = nil
	end

	local v14 = if fFlagLuaAppEdpMediaGalleryVideoPreview then v5 else nil
	local v15 = if fFlagLuaAppEdpMediaGalleryVideoPreview then p3 else v7
	local v16 = if fFlagLuaAppEdpMediaGalleryVideoPreview then v10 else nil
	return (useMemo(fn, {
		v6,
		p4,
		p5,
		v14,
		p2,
		v15,
		v8,
		v9,
		v16,
		if fFlagLuaAppEdpMediaGalleryVideoPreview then v11 else nil,
		v12
	}))
end

return useSelectedGameMediaEntries
