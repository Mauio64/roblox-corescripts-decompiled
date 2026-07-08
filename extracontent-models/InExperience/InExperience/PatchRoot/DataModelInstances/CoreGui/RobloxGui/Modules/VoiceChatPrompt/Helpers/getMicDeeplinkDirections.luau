local CorePackages = game:GetService("CorePackages")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v3 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.AndroidWithDeeplink")
local v4 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.WindowsWithDeeplink")
local v5 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.AndroidWithoutDeeplink")
local v6 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.WindowsWithoutDeeplink")

return function(b1: boolean, t1: {[any]: any}) -- line: 12
	-- upvalues: v3 (copy), v5 (copy), v4 (copy), v6 (copy)
	local Platform = t1:GetPlatform()

	if Platform == Enum.Platform.Android then
		if b1 then
			return v3
		end

		return v5
	end

	if Platform == Enum.Platform.Windows then
		if b1 then
			return v4
		end

		return v6
	end

	return nil
end
