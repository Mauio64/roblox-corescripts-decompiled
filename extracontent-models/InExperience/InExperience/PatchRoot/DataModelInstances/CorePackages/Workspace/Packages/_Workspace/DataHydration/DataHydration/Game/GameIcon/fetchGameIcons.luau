local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local Url = Http.Url
local HttpClient = require(parent.HttpClient)
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local GameIconConstants = require(script.Parent.GameIconConstants)
local sizeString = GameIconConstants.sizeString

local SharedFlags = require(parent.SharedFlags)
local FFlagGetGameIconsFromThumbnailsDeliveryApiIxp = SharedFlags.FFlagGetGameIconsFromThumbnailsDeliveryApiIxp
local FFlagForceGetGameIconsFromThumbnailsDeliveryApi = SharedFlags.FFlagForceGetGameIconsFromThumbnailsDeliveryApi
local FIntGameIconSmallSizePx = GameIconConstants.FIntGameIconSmallSizePx

local function resolveThumbnailHost() -- 1 equivalent call inferred from this helper
	if FFlagForceGetGameIconsFromThumbnailsDeliveryApi then
		return Url.THUMBNAILSDELIVERY_URL
	end

	if FFlagGetGameIconsFromThumbnailsDeliveryApiIxp then
		local layerData = IXPServiceWrapper:GetLayerData(AppUserLayers.ServeThumbnailsFromEdge)

		if layerData and layerData.get_gamesicons_from_edge then
			return Url.THUMBNAILSDELIVERY_URL
		end
	end

	return Url.THUMBNAILS_URL
end

local function fetchGameIcons(list, p: string?, options)
	local url = urlBuilder.addQueryString(string.format("%sv1/games/icons", resolveThumbnailHost()), { -- inferred equivalent call
		universeIds = table.concat(list, ","),
		format = "png",
		size = p or sizeString(FIntGameIconSmallSizePx)
	})
	return asPromise((fetch({
		network = (options or {}).network,
		method = "GET",
		url = url,
		analyticsKey = "games-icons.get",
		decode = function(p2)
			return p2.data or {}
		end
	})))
end

return fetchGameIcons
