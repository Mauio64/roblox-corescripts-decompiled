local CorePackages = game:GetService("CorePackages")
local FFlagTopBarSignalizeHealthBar = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeHealthBar
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if FFlagTopBarSignalizeHealthBar then
	return nil
end

return (makeActionCreator(script.Name, function(p1) -- line: 9
	return {
		isDead = p1
	}
end))
