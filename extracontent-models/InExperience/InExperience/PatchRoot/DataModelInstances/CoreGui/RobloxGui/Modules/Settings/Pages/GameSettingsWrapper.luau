local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local modules = CoreGui:WaitForChild("RobloxGui").Modules

local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local Flags = require(modules.Settings.Flags)
local SettingsPageFactory = require(modules.Settings.SettingsPageFactory)

local FFlagRefactorInExpSettingsInDevelopment = Flags.FFlagRefactorInExpSettingsInDevelopment
local utils, constants

if FFlagRefactorInExpSettingsInDevelopment then
	local Integrations = require(modules.Settings.Integrations)
	utils = Integrations.Utils
	constants = Integrations.Constants
else
	constants = nil
	utils = nil
end

local FoundationProvider = Foundation.FoundationProvider
local Migration = BuilderIcons.Migration

local function createGameSettings()
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.TabHeader.Name = constants.GAMESETTINGS.TAB_HEADER.NAME
	local iconscommonsettings = Migration.uiblox["icons/common/settings"]
	newPage.TabHeader.TabLabel.Icon.Text = iconscommonsettings.name
	newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[iconscommonsettings.variant]
	newPage.TabHeader.TabLabel.Title.Text = constants.GAMESETTINGS.TAB_HEADER.TEXT

	newPage.Page:ClearAllChildren()

	newPage.PageOpen = false
	function newPage.OpenSettingsPage()
		newPage.PageOpen = true
	end
	function newPage.CloseSettingsPage()
		newPage.PageOpen = false
	end

	local element = React.createElement(
		FoundationProvider,
		{ colorMode = Foundation.Enums.ColorMode.Dark, device = utils.getDeviceType() },
		{}
	)

	ReactRoblox.createRoot(newPage.Page):render(element)

	return newPage
end

if FFlagRefactorInExpSettingsInDevelopment then
	return createGameSettings()
end

return require(modules.Settings.Pages.GameSettings)
