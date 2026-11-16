local LocalizationService = game:GetService("LocalizationService")

local parent = script.Parent.Parent.Parent
local Localization = require(parent.Localization)

local NumberLocalization = Localization.NumberLocalization
local RoundingBehaviour = Localization.RoundingBehaviour

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
