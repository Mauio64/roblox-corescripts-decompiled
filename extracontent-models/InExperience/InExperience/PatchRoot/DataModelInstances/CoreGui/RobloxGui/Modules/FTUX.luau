local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Roact = require(CorePackages.Packages.Roact)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local FTUXPanel = require(script.Components.FTUXPanel)
local GetFeatures = require(script.Features.GetFeatures)

require(script.Enums.PlatformEnum)

return {
	mountFtuxMenu = function(p1) -- line: 22
		-- upvalues: Roact (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), renderWithCoreScriptsStyleProvider (copy), FTUXPanel (copy), GetFeatures (copy), CoreGui (copy)
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

		local v12 = Roact.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			FTUXMenu = Roact.createElement("ScreenGui", {}, {
				ThemeProvider = renderWithCoreScriptsStyleProvider({
					FtuxPanel = Roact.createElement(FTUXPanel, {
						platform = p1
					}, {})
				})
			})
		})

		GetFeatures(p1)
		Roact.mount(v12, CoreGui, "FTUXMenu")
	end
}
