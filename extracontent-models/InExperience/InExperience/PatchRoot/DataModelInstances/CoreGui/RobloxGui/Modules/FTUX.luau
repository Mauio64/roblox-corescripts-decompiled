local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Roact = require(CorePackages.Packages.Roact)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local FTUXPanel = require(script.Components.FTUXPanel)
local GetFeatures = require(script.Features.GetFeatures)

require(script.Enums.PlatformEnum)

return {
	mountFtuxMenu = function(platform)
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		local StarterGui = game:GetService("StarterGui")
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
		local element = Roact.createElement(
			LocalizationProvider,
			{
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			},
			{
				FTUXMenu = Roact.createElement("ScreenGui", {}, {
					ThemeProvider = renderWithCoreScriptsStyleProvider({
						FtuxPanel = Roact.createElement(FTUXPanel, { platform = platform }, {})
					})
				})
			}
		)

		GetFeatures(platform)
		Roact.mount(element, CoreGui, "FTUXMenu")
	end
}
