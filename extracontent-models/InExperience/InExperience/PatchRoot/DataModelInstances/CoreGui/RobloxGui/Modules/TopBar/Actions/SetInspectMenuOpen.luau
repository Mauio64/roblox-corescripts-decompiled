local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)

if CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen then
	return nil
end

return (makeActionCreator(script.Name, function(inspectMenuOpen)
	return { inspectMenuOpen = inspectMenuOpen }
end))
