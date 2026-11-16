local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local LocalizationService = game:GetService("LocalizationService")

local renderWithCoreScriptsStyleProvider = require(script.Parent.Parent.Parent.Common.renderWithCoreScriptsStyleProvider)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

return function(p)
	return Roact.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			FTUXMock = Roact.createElement("ScreenGui", {}, {
				ThemeProvider = renderWithCoreScriptsStyleProvider({
					Frame = Roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0) }, p)
				})
			})
		}
	)
end
