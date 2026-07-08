local Parent = script:FindFirstAncestor("GameIconRodux").Parent
local IXPServiceWrapper = require(Parent.IxpServiceWrapper).IXPServiceWrapper
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local FFlagGetGameIconsFromThumbnailsDeliveryApiIxp = require(Parent.SharedFlags).FFlagGetGameIconsFromThumbnailsDeliveryApiIxp
local FFlagForceGetGameIconsFromThumbnailsDeliveryApi = require(Parent.SharedFlags).FFlagForceGetGameIconsFromThumbnailsDeliveryApi
local Url = require(Parent.Http).Url

return function(p1, p2, p3) -- line: 25
	-- upvalues: Url (copy), FFlagForceGetGameIconsFromThumbnailsDeliveryApi (copy), FFlagGetGameIconsFromThumbnailsDeliveryApiIxp (copy), IXPServiceWrapper (copy), AppUserLayers (copy)
	local v10 = Url:makeQueryString({
		format = "png",
		universeIds = table.concat(p2, ","),
		size = p3
	})
	local THUMBNAILS_URL = Url.THUMBNAILS_URL

	if FFlagForceGetGameIconsFromThumbnailsDeliveryApi then
		THUMBNAILS_URL = Url.THUMBNAILSDELIVERY_URL
	elseif FFlagGetGameIconsFromThumbnailsDeliveryApiIxp then
		local LayerData = IXPServiceWrapper:GetLayerData(AppUserLayers.ServeThumbnailsFromEdge)

		if LayerData and LayerData.get_gamesicons_from_edge then
			THUMBNAILS_URL = Url.THUMBNAILSDELIVERY_URL
		end
	end

	return p1(string.format("%sv1/games/icons?%s", THUMBNAILS_URL, v10), "GET")
end
