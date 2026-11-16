local CorePackages = game:GetService("CorePackages")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.AndroidWithDeeplink")
local formatByKey2 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.WindowsWithDeeplink")
local formatByKey3 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.AndroidWithoutDeeplink")
local formatByKey4 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.WindowsWithoutDeeplink")

return function(flag: boolean, object)
	local platform = object:GetPlatform()

	if platform == Enum.Platform.Android then
		return if flag then formatByKey else formatByKey3
	end

	if platform ~= Enum.Platform.Windows then
		return nil
	end

	return if flag then formatByKey2 else formatByKey4
end
