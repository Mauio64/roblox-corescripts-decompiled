local CorePackages = game:GetService("CorePackages")
local v2 = require(CorePackages.Workspace.Packages.RobloxTranslator):FormatByKey("Feature.SettingsHub.Prompt.RestartOnMicAccessChange")

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: v2 (copy)
	if t1:GetPlatform() == Enum.Platform.Android then
		return "<b>" .. v2 .. "</b>"
	end

	return nil
end
