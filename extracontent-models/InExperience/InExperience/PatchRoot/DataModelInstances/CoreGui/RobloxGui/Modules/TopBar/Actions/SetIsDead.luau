local CorePackages = game:GetService("CorePackages")

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

if FFlagTopBarSignalizeHealthBar then
	return nil
end

return (makeActionCreator(script.Name, function(isDead)
	return { isDead = isDead }
end))
