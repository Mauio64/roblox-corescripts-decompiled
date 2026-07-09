local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers

local function logItemDetailsIxpLayerExposure(_: {[any]: any}) -- line: 5
	-- upvalues: IXPService (copy), AppUserLayers (copy)
	IXPService:LogUserLayerExposure(AppUserLayers.AvatarMarketplaceItemDetailsPage)
end

return logItemDetailsIxpLayerExposure
