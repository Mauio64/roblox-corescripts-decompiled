local CorePackages = game:GetService("CorePackages")
local FFlagTopBarSignalizeHealthBar = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeHealthBar
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

if FFlagTopBarSignalizeHealthBar then
	return nil
end

return (makeActionCreator(script.Name, function(p1, p2) -- line: 9
	return {
		health = p1,
		maxHealth = p2
	}
end))
