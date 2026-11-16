local CorePackages = game:GetService("CorePackages")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RestartOnMicAccessChange")

return function(object)
	if object:GetPlatform() == Enum.Platform.Android then
		return "<b>" .. formatByKey .. "</b>"
	end

	return nil
end
