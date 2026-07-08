local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local RoundingBehaviour = require(CorePackages.Workspace.Packages.Localization).RoundingBehaviour

return function(p1) -- line: 9
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
