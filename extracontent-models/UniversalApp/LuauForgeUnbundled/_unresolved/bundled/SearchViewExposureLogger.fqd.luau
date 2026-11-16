local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local appUserLayers = require("@luauforge/bundled/fqe").AppUserLayers
local ixpServiceWrapper = require("@luauforge/bundled/fqf").IXPServiceWrapper

local fFlagBasedExposureLoggingCatalogPage = require("@luauforge/bundled/fpS").FFlagBasedExposureLoggingCatalogPage

local function SearchViewExposureLogger(): nil
	React.useEffect(function()
		if fFlagBasedExposureLoggingCatalogPage then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.AvatarExperienceUASearchView)
		end
	end, {})

	return nil
end

return SearchViewExposureLogger
