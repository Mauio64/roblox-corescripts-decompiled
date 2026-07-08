local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.Signals)

local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local MenuButtons = require(script.Parent.MenuButtons)

local function Container(t1: {[any]: any}) -- line: 27
	-- upvalues: Localization (copy), LocalizationService (copy), React (copy), LocalizationProvider (copy), FoundationProvider (copy), Foundation (copy), MenuButtons (copy)
	local v11 = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(LocalizationProvider, {
		localization = v11
	}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			MenuButtons = React.createElement(MenuButtons, t1)
		})
	})
end

return Container
