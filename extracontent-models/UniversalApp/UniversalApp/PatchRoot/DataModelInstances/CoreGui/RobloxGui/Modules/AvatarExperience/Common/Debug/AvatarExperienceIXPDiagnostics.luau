local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local useEventConnection = require(CorePackages.Packages.ReactUtils).useEventConnection
local v4 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.init")
local AvatarExperienceFeatureLayer = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers.AvatarExperienceFeatureLayer

local function AvatarExperienceIXPDiagnostics() -- line: 11
	-- upvalues: useEventConnection (copy), IXPService (copy), v4 (copy), AvatarExperienceFeatureLayer (copy)
	useEventConnection(IXPService.OnUserLayerLoadingStatusChanged, function(p1) -- line: 12
		-- upvalues: v4 (copy), IXPService (copy), AvatarExperienceFeatureLayer (copy)
		v4:info("IXPLayerLoadingStatusChanged: {}", p1)

		local UserLayerLoadingStatus = IXPService:GetUserLayerLoadingStatus()
		local UserStatusForLayer = IXPService:GetUserStatusForLayer(AvatarExperienceFeatureLayer)

		if UserLayerLoadingStatus ~= p1 then
			v4:info("IXPLayerLoadingStatusChanged -- latest status differs: {}", UserLayerLoadingStatus)
		end

		if UserStatusForLayer ~= p1 then
			v4:info("IXPLayerLoadingStatusChanged -- status for layer {} differs: {}", AvatarExperienceFeatureLayer, UserStatusForLayer)
		end
	end)

	return nil
end

return AvatarExperienceIXPDiagnostics
