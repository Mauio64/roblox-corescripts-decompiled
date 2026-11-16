local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local ReactUtils = require(CorePackages.Packages.ReactUtils)

local useEventConnection = ReactUtils.useEventConnection
local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.init")
local avatarExperienceFeatureLayer = require("@luauforge/bundled/dMA").AppUserLayers.AvatarExperienceFeatureLayer

local function AvatarExperienceIXPDiagnostics(): nil
	useEventConnection(IXPService.OnUserLayerLoadingStatusChanged, function(p2)
		logger:info("IXPLayerLoadingStatusChanged: {}", p2)

		local userLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
		local userStatusForLayer = IXPService:GetUserStatusForLayer(avatarExperienceFeatureLayer)

		if userLayerLoadingStatus ~= p2 then
			logger:info("IXPLayerLoadingStatusChanged -- latest status differs: {}", userLayerLoadingStatus)
		end

		if userStatusForLayer ~= p2 then
			logger:info(
				"IXPLayerLoadingStatusChanged -- status for layer {} differs: {}",
				avatarExperienceFeatureLayer,
				userStatusForLayer
			)
		end
	end)

	return nil
end

return AvatarExperienceIXPDiagnostics
