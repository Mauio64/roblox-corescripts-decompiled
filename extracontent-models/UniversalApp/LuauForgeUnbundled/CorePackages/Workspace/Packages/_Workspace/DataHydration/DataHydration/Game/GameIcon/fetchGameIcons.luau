local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/IxpServiceWrapper").IXPServiceWrapper
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/ExperimentLayers").AppUserLayers
local GameIconConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/GameIconConstants")
local sizeString = GameIconConstants.sizeString

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local fFlagGetGameIconsFromThumbnailsDeliveryApiIxp = SharedFlags.FFlagGetGameIconsFromThumbnailsDeliveryApiIxp
local fFlagForceGetGameIconsFromThumbnailsDeliveryApi = SharedFlags.FFlagForceGetGameIconsFromThumbnailsDeliveryApi
local fIntGameIconSmallSizePx = GameIconConstants.FIntGameIconSmallSizePx

local function resolveThumbnailHost()
	if fFlagForceGetGameIconsFromThumbnailsDeliveryApi then
		return url.THUMBNAILSDELIVERY_URL
	end

	if fFlagGetGameIconsFromThumbnailsDeliveryApiIxp then
		local layerData = ixpServiceWrapper:GetLayerData(appUserLayers.ServeThumbnailsFromEdge)

		if layerData and layerData.get_gamesicons_from_edge then
			return url.THUMBNAILSDELIVERY_URL
		end
	end

	return url.THUMBNAILS_URL
end

local function fetchGameIcons(list, p2, options)
	local addQueryString = urlBuilder.addQueryString
	local format = string.format
	local v7

	if fFlagForceGetGameIconsFromThumbnailsDeliveryApi then
		v7 = url.THUMBNAILSDELIVERY_URL
	elseif fFlagGetGameIconsFromThumbnailsDeliveryApiIxp then
		local layerData = ixpServiceWrapper:GetLayerData(appUserLayers.ServeThumbnailsFromEdge)

		if layerData and layerData.get_gamesicons_from_edge then
			v7 = url.THUMBNAILSDELIVERY_URL
		else
			v7 = url.THUMBNAILS_URL
		end
	else
		v7 = url.THUMBNAILS_URL
	end

	local v8 = addQueryString(format("%sv1/games/icons", v7), {
		universeIds = table.concat(list, ","),
		format = "png",
		size = p2 or sizeString(fIntGameIconSmallSizePx)
	})
	return asPromise((fetch({
		network = (options or {}).network,
		method = "GET",
		url = v8,
		analyticsKey = "games-icons.get",
		decode = function(p3)
			return p3.data or {}
		end
	})))
end

return fetchGameIcons
