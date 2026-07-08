local LocalizationService = game:GetService("LocalizationService")
local ParentParent = script.Parent.Parent.Parent
local Localization = require(ParentParent.Localization)
local NumberLocalization = Localization.NumberLocalization
local RoundingBehaviour = Localization.RoundingBehaviour

return function(p1) -- line: 12
	-- upvalues: NumberLocalization (copy), LocalizationService (copy), RoundingBehaviour (copy)
	if p1 == nil then
		return "-"
	end

	if type(p1) == "number" then
		if tostring(p1):len() >= 7 then
			return NumberLocalization.abbreviate(p1, LocalizationService.RobloxLocaleId, RoundingBehaviour.Truncate)
		end

		return NumberLocalization.localize(p1, LocalizationService.RobloxLocaleId)
	end

	return (tostring(p1))
end
