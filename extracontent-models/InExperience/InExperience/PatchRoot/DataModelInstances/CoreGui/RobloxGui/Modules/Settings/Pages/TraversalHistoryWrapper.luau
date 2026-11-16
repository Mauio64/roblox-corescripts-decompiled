local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Settings = script:FindFirstAncestor("Settings")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local Constants = require(Settings.Integrations.Constants)
local TraversalHistoryPage = require(Settings.Components.Traversal.TraversalHistoryPage)
local SettingsPageFactory = require(Settings.SettingsPageFactory)
local Utils = require(Settings.Integrations.Utils)

local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)

local function createTraversalHistoryWrapper()
	local localization = Localization.new(LocalizationService.RobloxLocaleId)

	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.Page:ClearAllChildren()
	newPage.Page.Name = "TraversalHistoryPage"
	newPage.TabHeader.Name = Constants.TRAVERSAL_HISTORY.TAB_HEADER.NAME
	newPage.TabHeader.TabLabel.Title.AutoLocalize = false
	newPage.TabHeader.TabLabel.Title.Text = localization:Format(Constants.TRAVERSAL_HISTORY.TAB_HEADER.TEXT_KEY)

	newPage.PageListLayout.Parent = nil
	newPage.ShouldShowBottomBar = not isSideSheetEnabled
	newPage.ShouldShowHubBar = true

	newPage.Page.Size = UDim2.fromScale(1, 0)

	ReactRoblox.createRoot(newPage.Page):render(React.createElement(
		FoundationProvider,
		{ colorMode = Foundation.Enums.ColorMode.Dark, device = Utils.getDeviceType() },
		{
			Localization = React.createElement(LocalizationProvider, { localization = localization }, {
				Page = React.createElement(TraversalHistoryPage)
			})
		}
	))

	return newPage
end

return createTraversalHistoryWrapper
