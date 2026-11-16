local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Localization = require(CorePackages.Workspace.Packages.Localization)
local NumberLocalization = Localization.NumberLocalization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local RoundingBehaviour = Localization2.RoundingBehaviour

return function(value)
	if value == nil then
		return "-"
	end

	if type(value) ~= "number" then
		return (tostring(value))
	end

	if tostring(value):len() >= 7 then
		return NumberLocalization.abbreviate(value, LocalizationService.RobloxLocaleId, RoundingBehaviour.Truncate)
	end

	return NumberLocalization.localize(value, LocalizationService.RobloxLocaleId)
end
