local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)

if CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize then
	return nil
end

return (makeActionCreator(script.Name, function(screenSize)
	return { screenSize = screenSize }
end))
