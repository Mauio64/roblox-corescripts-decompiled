local CorePackages = game:GetService("CorePackages")
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Actions.SetCentralOverlay

return function() -- line: 5
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p1) -- line: 6
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
		p1:dispatch(SetCentralOverlay(CentralOverlayType.ReportLogsOverlay, {}))
	end
end
