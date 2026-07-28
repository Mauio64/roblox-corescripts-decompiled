local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Settings = script:FindFirstAncestor("Settings")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Constants = require(Settings.Integrations.Constants)
local TraversalHistoryPage = require(Settings.Components.Traversal.TraversalHistoryPage)
local SettingsPageFactory = require(Settings.SettingsPageFactory)
local Utils = require(Settings.Integrations.Utils)
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet

local function createTraversalHistoryWrapper() -- line: 24
	-- upvalues: Localization (copy), LocalizationService (copy), SettingsPageFactory (copy), Constants (copy), FFlagEnableSideSheet (copy), ReactRoblox (copy), React (copy), FoundationProvider (copy), Foundation (copy), Utils (copy), LocalizationProvider (copy), TraversalHistoryPage (copy)
	local v17 = Localization.new(LocalizationService.RobloxLocaleId)
	local v18 = SettingsPageFactory:CreateNewPage()

	v18.Page:ClearAllChildren()
	v18.Page.Name = "TraversalHistoryPage"
	v18.TabHeader.Name = Constants.TRAVERSAL_HISTORY.TAB_HEADER.NAME
	v18.TabHeader.TabLabel.Title.AutoLocalize = false
	v18.TabHeader.TabLabel.Title.Text = v17:Format(Constants.TRAVERSAL_HISTORY.TAB_HEADER.TEXT_KEY)
	v18.PageListLayout.Parent = nil
	v18.ShouldShowBottomBar = not FFlagEnableSideSheet
	v18.ShouldShowHubBar = true
	v18.Page.Size = UDim2.fromScale(1, 0)
	ReactRoblox.createRoot(v18.Page):render(React.createElement(FoundationProvider, {
		theme = Foundation.Enums.Theme.Dark,
		device = Utils.getDeviceType()
	}, {
		Localization = React.createElement(LocalizationProvider, {
			localization = v17
		}, {
			Page = React.createElement(TraversalHistoryPage)
		})
	}))

	return v18
end

return createTraversalHistoryWrapper
