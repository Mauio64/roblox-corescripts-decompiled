local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("AdPlayer").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local localization = Localization.new(LocalizationService.RobloxLocaleId)

return function(p)
	return React.createElement(LocalizationProvider, { localization = localization }, {
		foundationProvider = React.createElement(FoundationProvider, {}, p.children)
	})
end
