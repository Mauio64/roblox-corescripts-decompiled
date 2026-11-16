local IXPService = game:GetService("IXPService")
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers

local function logItemDetailsIxpLayerExposure(p2)
	IXPService:LogUserLayerExposure(appUserLayers.AvatarMarketplaceItemDetailsPage)
end

return logItemDetailsIxpLayerExposure
