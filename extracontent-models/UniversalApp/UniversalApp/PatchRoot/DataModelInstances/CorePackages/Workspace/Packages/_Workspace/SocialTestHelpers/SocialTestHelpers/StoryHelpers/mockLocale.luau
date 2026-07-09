local SocialTestHelpers = script:FindFirstAncestor("SocialTestHelpers")
local dependencies = require(SocialTestHelpers.dependencies)
local Localization = dependencies.RobloxAppLocales.Localization
local LocalizationProvider = dependencies.LocalizationProvider
local Roact = dependencies.Roact
local v6 = Localization.new("en-us")

return function(p1, p2) -- line: 9
	-- upvalues: v6 (copy), Roact (copy), LocalizationProvider (copy)
	if p2 and (p2.controls and p2.controls.langauge) then
		v6:SetLocale(p2.controls.language)
	end

	return Roact.createElement(LocalizationProvider, {
		localization = v6
	}, {
		TestElement1 = Roact.createElement(p1, p2)
	})
end
