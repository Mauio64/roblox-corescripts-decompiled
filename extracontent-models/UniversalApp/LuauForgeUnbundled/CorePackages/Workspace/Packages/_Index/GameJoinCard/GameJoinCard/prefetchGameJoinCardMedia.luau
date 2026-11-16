local ContentProvider = game:GetService("ContentProvider")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration")
local dataStatus = DataHydration.DataStatus
local getGameMediaStore = DataHydration.Game.getGameMediaStore
local gameMediaImageType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DiscoveryTypes").GameMediaImageType
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Signals")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailType = Foundation.Enums.ThumbnailType
local thumbnailSize = Foundation.Enums.ThumbnailSize

local BannerImageConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/BannerImageConstants")
local FFlagMobileGameJoinCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagMobileGameJoinCardThumbnail")

local function preloadFirstImage(items)
	if not items then
		return
	end

	for k, item in items do
		if item.assetTypeId == gameMediaImageType.Image and item.imageId then
			local v5 = string.format(
				"rbxthumb://type=Asset&id=%s&w=%d&h=%d",
				tostring(item.imageId),
				BannerImageConstants.DEFAULT_BANNER_WIDTH,
				BannerImageConstants.DEFAULT_BANNER_HEIGHT
			)

			task.spawn(function()
				pcall(function()
					ContentProvider:PreloadAsync({ v5 })
				end)
			end)
			break
		end
	end
end

local function prefetchUniverseMedia(universeId)
	local fetchGameMedia = getGameMediaStore(false).getAndFetchGameMedia(universeId)

	local status = fetchGameMedia.status(false)

	if status == dataStatus.NotReady then
		local v5 = nil
		v5 = Signals.createEffect(function(p2)
			local status2 = fetchGameMedia.status(p2)

			if status2 == dataStatus.NotReady then
				return
			end

			if v5 then
				v5()
				v5 = nil
			end

			if status2 == dataStatus.Ready then
				preloadFirstImage(fetchGameMedia.data(false))
			end
		end)
	elseif status == dataStatus.Ready then
		preloadFirstImage(fetchGameMedia.data(false))
	end
end

local function preloadGameThumbnail(p2, p3)
	local v5 = p3 or ContentProvider
	local rbxThumb = getRbxThumb(thumbnailType.GameIcon, p2, thumbnailSize.Medium)
	task.spawn(function()
		pcall(function()
			v5:PreloadAsync({ rbxThumb })
		end)
	end)
end

local function prefetchGameJoinCardMedia(items, p2)
	if not items then
		return
	end

	for k, item in items do
		if not (item.universeId and item.universeId ~= "") then
			continue
		end

		if FFlagMobileGameJoinCardThumbnail then
			local universeId = tostring(item.universeId)
			local v5 = p2 or ContentProvider
			local rbxThumb = getRbxThumb(thumbnailType.GameIcon, universeId, thumbnailSize.Medium)
			task.spawn(function()
				pcall(function()
					v5:PreloadAsync({ rbxThumb })
				end)
			end)
		end

		prefetchUniverseMedia(tostring(item.universeId))
	end
end

return prefetchGameJoinCardMedia
