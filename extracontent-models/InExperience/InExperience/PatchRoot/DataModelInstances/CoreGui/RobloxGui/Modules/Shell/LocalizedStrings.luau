local CorePackages = game:GetService("CorePackages")
local RobloxAppLocales = require(CorePackages.Workspace.Packages.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization

local v = nil
local success, result = pcall(function()
	local LocalizationService = game:GetService("LocalizationService")
	return LocalizationService.RobloxLocaleId
end)

return {
	LocStringUA = function(_, p)
		if success and not v then
			v = Localization.new(result)
		else
			v = Localization.new("en-us")
		end

		return v.localizationContext:getString(result, p) or p
	end
}
