local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization

local v5 = nil
local success, result = pcall(function()
	local LocalizationService = game:GetService("LocalizationService")
	return LocalizationService.RobloxLocaleId
end)

return {
	LocStringUA = function(self, p3)
		v5 = if success and not v5 then localization.new(result) else localization.new("en-us")

		return v5.localizationContext:getString(result, p3) or p3
	end
}
