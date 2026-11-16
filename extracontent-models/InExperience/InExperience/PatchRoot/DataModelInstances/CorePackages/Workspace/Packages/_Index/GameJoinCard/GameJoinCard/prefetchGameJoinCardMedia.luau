local ContentProvider = game:GetService("ContentProvider")

local parent = script:FindFirstAncestor("GameJoinCard").Parent

local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local getGameMediaStore = DataHydration.Game.getGameMediaStore
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameMediaImageType = DiscoveryTypes.GameMediaImageType
local Signals = require(parent.Signals)

local Foundation = require(parent.Foundation)
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize

local BannerImageConstants = require(script.Parent.BannerImageConstants)
local FFlagMobileGameJoinCardThumbnail = require(script.Parent.Flags.FFlagMobileGameJoinCardThumbnail)

local function preloadFirstImage(items)
	if not items then
		return
	end

	for _, item in items do
		if item.assetTypeId == GameMediaImageType.Image and item.imageId then
			local v = string.format(
				"rbxthumb://type=Asset&id=%s&w=%d&h=%d",
				tostring(item.imageId),
				BannerImageConstants.DEFAULT_BANNER_WIDTH,
				BannerImageConstants.DEFAULT_BANNER_HEIGHT
			)

			task.spawn(function()
				pcall(function()
					ContentProvider:PreloadAsync({ v })
				end)
			end)
			break
		end
	end
end

local function prefetchUniverseMedia(universeId: string)
	local fetchGameMedia = getGameMediaStore(false).getAndFetchGameMedia(universeId)

	local status = fetchGameMedia.status(false)

	if status == DataStatus.NotReady then
		local v = nil
		v = Signals.createEffect(function(p)
			local status2 = fetchGameMedia.status(p)

			if status2 == DataStatus.NotReady then
				return
			end

			if v then
				v()
				v = nil
			end

			if status2 == DataStatus.Ready then
				preloadFirstImage(fetchGameMedia.data(false))
			end
		end)
	elseif status == DataStatus.Ready then
		preloadFirstImage(fetchGameMedia.data(false))
	end
end

local function preloadGameThumbnail(universeId: string, p) -- 1 equivalent call inferred from this helper
	local v = p or ContentProvider
	local rbxThumb = getRbxThumb(ThumbnailType.GameIcon, universeId, ThumbnailSize.Medium)
	task.spawn(function()
		pcall(function()
			v:PreloadAsync({ rbxThumb })
		end)
	end)
end

local function prefetchGameJoinCardMedia(items, p)
	if not items then
		return
	end

	for _, item in items do
		if not (item.universeId and item.universeId ~= "") then
			continue
		end

		if FFlagMobileGameJoinCardThumbnail then
			preloadGameThumbnail(tostring(item.universeId), p) -- inferred equivalent call
		end

		prefetchUniverseMedia(tostring(item.universeId))
	end
end

return prefetchGameJoinCardMedia
