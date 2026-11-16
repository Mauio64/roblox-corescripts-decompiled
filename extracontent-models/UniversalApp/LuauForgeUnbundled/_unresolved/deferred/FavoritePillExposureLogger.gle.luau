local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/React")
local appUserLayers = require("@luauforge/deferred/glf").AppUserLayers
local ixpServiceWrapper = require("@luauforge/deferred/glg").IXPServiceWrapper

local function FavoritePillExposureLogger(): nil
	React.useEffect(function()
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.AvatarMarketplaceItemDetailsPage)
	end, {})

	return nil
end

return FavoritePillExposureLogger
