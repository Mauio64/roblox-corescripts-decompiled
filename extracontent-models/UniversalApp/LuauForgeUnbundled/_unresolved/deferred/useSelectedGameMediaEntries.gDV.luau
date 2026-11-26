local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dzP")

local fetchGamePlayabilityAndProductInfo = require("@luauforge/bundled/dBl").FetchGamePlayabilityAndProductInfo
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local gameMediaImageType = require("@luauforge/bundled/cBc").GameMediaImageType
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local url = require("@game/CorePackages/Workspace/Packages/Http").Url
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local useIsVideoEligible = require("@luauforge/bundled/gDC").useIsVideoEligible
local useCanDevicePlayVideoPreview = require("@luauforge/bundled/gDL").useCanDevicePlayVideoPreview
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module3 = require("@luauforge/deferred/gBI")

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp

local edpVideoBlockingConfig = require("@luauforge/bundled/gDL").EdpVideoBlockingConfig

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

	local v7 = GameHydrationReact.useGameInfo(p2)
	local rootPlaceId = v7 and v7.rootPlaceId
	local v8

	if not fFlagLuaAppEdpMediaGalleryVideoPreview then
		v8 = useSelector(function(p7)
			local v9 = p7.GameDetailsV2[p2]
			return v9 and v9.rootPlaceId
		end)
	end

	local v9 = v8 or rootPlaceId

	local v10 = useSelector(function(p7)
		return module3.GetFetchingStatus(p7, p2)
	end)

	local v11 = useSelector(function(p7)
		return p7.GameMedia[p2]
	end)
	local v12, v13

	if fFlagLuaAppEdpMediaGalleryVideoPreview then
		v12 = useSelector(function(p7)
			return fetchGamePlayabilityAndProductInfo.GetFetchingStatus(p7, p2)
		end)

		v13 = useIsVideoEligible(p2)
	else
		v12 = nil
		v13 = nil
	end

	local v14 = useCanDevicePlayVideoPreview(edpVideoBlockingConfig, p2, appPage.ExperienceDetail)

	local useMemo = React.useMemo
	local function fn()
		if v11 then
			local v15 = {}

			if fFlagLuaAppEdpMediaGalleryVideoPreview and v5 then
				local v16 = nil

				for i, v18 in ipairs(v11) do
					if
						v18.assetTypeId == gameMediaImageType.Video
						or v18.assetTypeId == gameMediaImageType.GamePreviewVideo
					then
						v16 = true
						break
					end
				end

				local v18 = nil

				for i, v19 in ipairs(v11) do
					local v20 = processedMediaEntry(v19, v6, true)

					if not v20 then
						continue
					end

					if
						v20.mediaType == gameMediaImageType.Video
						or v20.mediaType == gameMediaImageType.GamePreviewVideo
					then
						module.assert(v16)

						if v12 == retrievalStatus.Done and v13 and v14() then
							module.assert(not v18)

							table.insert(v15, 1, v20)
							v18 = true
						end
					elseif v20.mediaType == gameMediaImageType.YouTubeVideo then
						if not v16 or v12 == retrievalStatus.Done and not v13 then
							if p4 then
								table.insert(v15, 1, v20)
							else
								table.insert(v15, v20)
							end
						end
					elseif v20.mediaType == gameMediaImageType.Image then
						table.insert(v15, v20)
					else
						warn("Unknown media type: " .. tostring(v20.mediaType))
					end
				end
			else
				for i, v16 in ipairs(v11) do
					local v17 = processedMediaEntry(v16, v6)

					if not v17 then
						continue
					end

					if v17.mediaType == gameMediaImageType.YouTubeVideo then
						if p4 then
							table.insert(v15, 1, v17)
						else
							table.insert(v15, v17)
						end
					elseif v17.mediaType == gameMediaImageType.Image then
						table.insert(v15, v17)
					else
						warn("Unknown media type: " .. tostring(v17.mediaType))
					end
				end
			end

			return { unpack(v15, 1, 10) }
		else
			if v10 ~= retrievalStatus.Done then
				return {}
			end

			local v16 = if fFlagLuaAppEdpMediaGalleryVideoPreview then p3 else v9
			return {
				{
					mediaType = gameMediaImageType.Image,
					imageId = url:getPlaceDefaultThumbnailUrl(v16, 640, 360)
				}
			}
		end
	end

	if not fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then
		p5 = nil
	end

	local v16 = if fFlagLuaAppEdpMediaGalleryVideoPreview then v5 else nil
	local v17 = if fFlagLuaAppEdpMediaGalleryVideoPreview then p3 else v9
	local v18 = if fFlagLuaAppEdpMediaGalleryVideoPreview then v12 else nil
	return (useMemo(fn, {
		v6,
		p4,
		p5,
		v16,
		p2,
		v17,
		v10,
		v11,
		v18,
		if fFlagLuaAppEdpMediaGalleryVideoPreview then v13 else nil,
		v14
	}))
end

return useSelectedGameMediaEntries
