local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local LocalizationService = game:GetService("LocalizationService")
local Modules = RobloxGui.Modules

local HelpPage = require(CorePackages.Workspace.Packages.HelpPage)
local HelpReactView = HelpPage.HelpReactView
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local FFlagRefactorHelpPage = HelpPage.Flags.FFlagRefactorHelpPage
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameHelpToControls = SharedFlags.FFlagRenameHelpToControls
local utils, constants

if FFlagRefactorHelpPage then
	local Integrations = require(Modules.Settings.Integrations)
	utils = Integrations.Utils
	constants = HelpPage.Constants
else
	utils = nil
	constants = nil
end

local v = nil
local signal, v2 = Signals.createSignal(false)

local function fn()
	if SignalsReact.useSignalState(signal) then
		return (React.createElement(
			FoundationProvider,
			{ colorMode = Foundation.Enums.ColorMode.Dark, device = utils.getDeviceType() },
			{
				Child = React.createElement(LocalizationProvider, { localization = localization }, {
					Root = React.createElement(HelpReactView)
				})
			}
		))
	end

	return nil
end

local function createReactTree(page) -- 1 equivalent call inferred from this helper
	if v then
		return
	end

	v = ReactRoblox.createRoot(page)

	if v then
		v:render(React.createElement(fn))
	end
end

local function createHelpPage()
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.TabHeader.Name = constants.HELP_PAGE.TAB_HEADER.NAME
	newPage.Page.Name = "Help"

	if FFlagRenameHelpToControls then
		newPage.TabHeader.TabLabel.Icon.Text = IconName.Controller
		newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[IconVariant.Regular]
	else
		local v3 = uiblox[constants.HELP_PAGE.TAB_HEADER.ICON]
		newPage.TabHeader.TabLabel.Icon.Text = v3.name
		newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v3.variant]
	end

	newPage.TabHeader.TabLabel.Title.Text = localization:Format(constants.HELP_PAGE.TAB_HEADER.TEXT)

	newPage.Page:ClearAllChildren()

	newPage.Displayed.Event:Connect(function()
		createReactTree(newPage.Page) -- inferred equivalent call
		v2(true)

		if newPage.HubRef.VersionContainer then
			newPage.HubRef.VersionContainer.Visible = true
		end
	end)

	newPage.Hidden.Event:Connect(function()
		v2(false)

		if newPage.HubRef.VersionContainer then
			newPage.HubRef.VersionContainer.Visible = false
		end
	end)

	newPage.Page.Size = UDim2.fromScale(1, 0)
	newPage.Page.AutomaticSize = Enum.AutomaticSize.Y

	return newPage
end

if FFlagRefactorHelpPage then
	return createHelpPage()
end

return require(Modules.Settings.Pages.Help)
