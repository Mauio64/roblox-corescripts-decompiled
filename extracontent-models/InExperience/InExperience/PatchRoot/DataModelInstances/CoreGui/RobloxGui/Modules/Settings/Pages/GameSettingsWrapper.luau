local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui:WaitForChild("RobloxGui").Modules
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Flags = require(Modules.Settings.Flags)
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)
local FFlagRefactorInExpSettingsInDevelopment = Flags.FFlagRefactorInExpSettingsInDevelopment
local Utils = nil
local Constants = nil

if FFlagRefactorInExpSettingsInDevelopment then
	local Integrations = require(Modules.Settings.Integrations)

	Utils = Integrations.Utils
	Constants = Integrations.Constants
end

local FoundationProvider = Foundation.FoundationProvider
local Migration = BuilderIcons.Migration

local function createGameSettings() -- line: 27
	-- upvalues: SettingsPageFactory (copy), Constants (ref), Migration (copy), BuilderIcons (copy), React (copy), FoundationProvider (copy), Foundation (copy), Utils (ref), ReactRoblox (copy)
	local v17 = SettingsPageFactory:CreateNewPage()

	v17.TabHeader.Name = Constants.GAMESETTINGS.TAB_HEADER.NAME

	local v18 = Migration.uiblox["icons/common/settings"]

	v17.TabHeader.TabLabel.Icon.Text = v18.name
	v17.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v18.variant]
	v17.TabHeader.TabLabel.Title.Text = Constants.GAMESETTINGS.TAB_HEADER.TEXT
	v17.Page:ClearAllChildren()
	v17.PageOpen = false

	function v17.OpenSettingsPage() -- line: 41
		-- upvalues: v17 (copy)
		v17.PageOpen = true
	end
	function v17.CloseSettingsPage() -- line: 44
		-- upvalues: v17 (copy)
		v17.PageOpen = false
	end

	local v19 = React.createElement(FoundationProvider, {
		theme = Foundation.Enums.Theme.Dark,
		device = Utils.getDeviceType()
	}, {})

	ReactRoblox.createRoot(v17.Page):render(v19)

	return v17
end

if FFlagRefactorInExpSettingsInDevelopment then
	return (createGameSettings())
end

return require(Modules.Settings.Pages.GameSettings)
