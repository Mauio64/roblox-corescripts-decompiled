local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("AdPlayer").Parent
local React = require(Parent.React)
local FoundationProvider = require(Parent.Foundation).FoundationProvider
local Localization = require(Parent.InExperienceLocales).Localization
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local v7 = Localization.new(LocalizationService.RobloxLocaleId)

return function(p1) -- line: 14
	-- upvalues: React (copy), LocalizationProvider (copy), v7 (copy), FoundationProvider (copy)
	return React.createElement(LocalizationProvider, {
		localization = v7
	}, {
		foundationProvider = React.createElement(FoundationProvider, {}, p1.children)
	})
end
