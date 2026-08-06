local Parent = script:FindFirstAncestor("DataHydration").Parent
local Url = require(Parent.Http).Url
local HttpClient = require(Parent.HttpClient)
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local IXPServiceWrapper = require(Parent.IxpServiceWrapper).IXPServiceWrapper
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local GameIconConstants = require(script.Parent.GameIconConstants)
local sizeString = GameIconConstants.sizeString
local SharedFlags = require(Parent.SharedFlags)
local FFlagGetGameIconsFromThumbnailsDeliveryApiIxp = SharedFlags.FFlagGetGameIconsFromThumbnailsDeliveryApiIxp
local FFlagForceGetGameIconsFromThumbnailsDeliveryApi = SharedFlags.FFlagForceGetGameIconsFromThumbnailsDeliveryApi
local FIntGameIconSmallSizePx = GameIconConstants.FIntGameIconSmallSizePx

local function resolveThumbnailHost() -- line: 27
	-- upvalues: FFlagForceGetGameIconsFromThumbnailsDeliveryApi (copy), Url (copy), FFlagGetGameIconsFromThumbnailsDeliveryApiIxp (copy), IXPServiceWrapper (copy), AppUserLayers (copy)
	if FFlagForceGetGameIconsFromThumbnailsDeliveryApi then
		return Url.THUMBNAILSDELIVERY_URL
	end

	if FFlagGetGameIconsFromThumbnailsDeliveryApiIxp then
		local LayerData = IXPServiceWrapper:GetLayerData(AppUserLayers.ServeThumbnailsFromEdge)

		if LayerData and LayerData.get_gamesicons_from_edge then
			return Url.THUMBNAILSDELIVERY_URL
		end
	end

	return Url.THUMBNAILS_URL
end
local function fetchGameIcons(t1: {[any]: any}, s1: string?, t2: {[any]: any}?) -- line: 39
	-- upvalues: UrlBuilder (copy), FFlagForceGetGameIconsFromThumbnailsDeliveryApi (copy), Url (copy), FFlagGetGameIconsFromThumbnailsDeliveryApiIxp (copy), IXPServiceWrapper (copy), AppUserLayers (copy), sizeString (copy), FIntGameIconSmallSizePx (copy), fetch (copy), asPromise (copy)
	local v21 = t2 or {}
	local addQueryString = UrlBuilder.addQueryString
	local format = string.format
	local g25 = nil
	local LayerData = nil
	local THUMBNAILSDELIVERY_URL = nil

	if FFlagForceGetGameIconsFromThumbnailsDeliveryApi then
		THUMBNAILSDELIVERY_URL = Url.THUMBNAILSDELIVERY_URL
		g25 = true
	end

	repeat
		if g25 or (g25 or FFlagGetGameIconsFromThumbnailsDeliveryApiIxp) then
			if not g25 then
				if not g25 then
					LayerData = IXPServiceWrapper:GetLayerData(AppUserLayers.ServeThumbnailsFromEdge)
				end
			end

			if g25 or (g25 or LayerData and LayerData.get_gamesicons_from_edge) then
				if not g25 then
					if not g25 then
						THUMBNAILSDELIVERY_URL = Url.THUMBNAILSDELIVERY_URL
					end
				end

				g25 = false

				local v27 = addQueryString(format("%sv1/games/icons", THUMBNAILSDELIVERY_URL), {
					format = "png",
					universeIds = table.concat(t1, ","),
					size = s1 or sizeString(FIntGameIconSmallSizePx)
				})
				local v28 = fetch({
					method = "GET",
					analyticsKey = "games-icons.get",
					network = v21.network,
					url = v27,
					decode = function(p1) -- line: 56
						return p1.data or {}
					end
				})

				return asPromise(v28)
			end
		end

		THUMBNAILSDELIVERY_URL = Url.THUMBNAILS_URL
		g25 = true
	until not g25
end

return fetchGameIcons
