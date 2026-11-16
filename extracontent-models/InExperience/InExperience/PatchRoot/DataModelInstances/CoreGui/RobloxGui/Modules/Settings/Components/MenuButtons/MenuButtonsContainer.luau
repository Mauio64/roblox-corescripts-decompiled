local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.Signals)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local MenuButtons = require(script.Parent.MenuButtons)

local function Container(p)
	local localization = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(LocalizationProvider, { localization = localization }, {
		FoundationProvider = React.createElement(FoundationProvider, {
			colorMode = Foundation.Enums.ColorMode.Dark
		}, {
			MenuButtons = React.createElement(MenuButtons, p)
		})
	})
end

return Container
