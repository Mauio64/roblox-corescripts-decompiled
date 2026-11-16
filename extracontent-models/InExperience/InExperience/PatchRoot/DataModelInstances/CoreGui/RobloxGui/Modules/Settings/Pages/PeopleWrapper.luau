local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui.Modules

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local FFlagRefactorPeoplePage = require(Modules.Settings.Flags.FFlagRefactorPeoplePage)
local FFlagRelocateMobileMenuButtons = require(Modules.Settings.Flags.FFlagRelocateMobileMenuButtons)
local FIntRelocateMobileMenuButtonsVariant = require(Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)

local Chrome = RobloxGui.Modules.Chrome
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome2.Enabled()
local LocalStore

if enabled then
	LocalStore = require(Chrome.ChromeShared.Service.LocalStore)
else
	LocalStore = nil
end

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local localization = Localization.new(LocalizationService.RobloxLocaleId)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local BlockingModalScreen = require(Modules.Settings.Components.Blocking.BlockingModalScreen)
local uiblox = BuilderIcons.Migration.uiblox
local PeopleService = require(CorePackages.Workspace.Packages.PeopleService)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local FFlagSideSheetOpenPeoplePage = InExperienceSideSheet.Flags.FFlagSideSheetOpenPeoplePage

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local constants

if FFlagRefactorPeoplePage() then
	local PeopleReactView = require(CorePackages.Workspace.Packages.PeopleReactView)
	constants = PeopleReactView.Constants
else
	constants = nil
end

local service = PeopleService.getService("Flags")
local getFFlagAddPeoplePageCardLayout = service.GetFFlagAddPeoplePageCardLayout
local getFFlagPeoplePageLazyRenderCards = service.GetFFlagPeoplePageLazyRenderCards
local fFlagEnablePeopleListLazyRender = service.FFlagEnablePeopleListLazyRender
local fFlagPeopleCardsEnableVirtualizedGrid = service.FFlagPeopleCardsEnableVirtualizedGrid

local fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView = service.FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView

local fFlagPeoplePageFlipVolumePopoverToFitViewport = service.FFlagPeoplePageFlipVolumePopoverToFitViewport

local fFlagPeoplePageDismissCardMenuOnScrollOutOfView = service.FFlagPeoplePageDismissCardMenuOnScrollOutOfView

local v = nil
local signal, v2 = Signals.createSignal(false)

local function PeopleFocusRoot(p)
	return React.createElement(
		FocusRoot,
		{
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView,
			isAutoFocusRoot = false
		},
		p.children
	)
end

local function createPeoplePage()
	local PeopleReactView = require(CorePackages.Workspace.Packages.PeopleReactView)
	local peopleReactView = PeopleReactView.PeopleReactView
	local sideSheetFocusContext = PeopleReactView.SideSheetFocusContext
	local PeopleService2 = require(CorePackages.Workspace.Packages.PeopleService)
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.TabHeader.Name = constants.PEOPLEPAGE.TAB_HEADER.NAME
	newPage.Page.Name = constants.PEOPLEPAGE.PAGE_ID
	local v3 = uiblox[constants.PEOPLEPAGE.TAB_HEADER.ICON]
	newPage.TabHeader.TabLabel.Icon.Text = v3.name
	newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v3.variant]
	newPage.TabHeader.TabLabel.Title.Text = localization:Format(constants.PEOPLEPAGE.TAB_HEADER.TEXT)

	local service2 = PeopleService2.getService("SettingsHubService")
	service2.register(newPage)

	function newPage.CreateMenuButtonsContainer(_)
		service2.setShowMenuButtonsContainer(true)
	end

	if FFlagRelocateMobileMenuButtons and FIntRelocateMobileMenuButtonsVariant == 2 then
		function newPage.UnmountMenuButtonsContainer(_)
			service2.setShowMenuButtonsContainer(false)
		end
	end

	local function createReactTree()
		if v then
			return
		end

		local scrollingFrame

		if
			getFFlagPeoplePageLazyRenderCards()
			or fFlagEnablePeopleListLazyRender
			or fFlagPeopleCardsEnableVirtualizedGrid
			or fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView
			or fFlagPeoplePageFlipVolumePopoverToFitViewport
			or fFlagPeoplePageDismissCardMenuOnScrollOutOfView
		then
			scrollingFrame = newPage.Page:FindFirstAncestorWhichIsA("ScrollingFrame")
		else
			scrollingFrame = nil
		end

		local function PeopleConditionalView()
			local v4 = SignalsReact.useSignalState(signal)
			local v5

			if FFlagSideSheetOpenPeoplePage then
				v5 = SignalsReact.useSignalState(InExperienceSideSheet.getSideSheetVisibility)
			else
				v5 = false
			end

			local v6

			if FFlagSideSheetOpenPeoplePage then
				v6 = SignalsReact.useSignalState(InExperienceSideSheet.getDidSideSheetOpenWithPeoplePage)
			else
				v6 = false
			end

			local people

			if v4 then
				local createElement = React.createElement
				local createElement2 = React.createElement

				local createElement3 = React.createElement
				local createElement4 = React.createElement
				local v7 = {
					blockingModalScreen = BlockingModalScreen,
					blockingFlags = {},
					scrollingFrame = 0,
					chromeEnabled = 0,
					getUniversesExposedTo = 0,
					addUniverseToExposureList = 0,
					minimumCardWidth = 0
				}
				local scrollingFrame2

				if
					getFFlagPeoplePageLazyRenderCards()
					or fFlagEnablePeopleListLazyRender
					or fFlagPeopleCardsEnableVirtualizedGrid
					or fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView
					or fFlagPeoplePageFlipVolumePopoverToFitViewport
					or fFlagPeoplePageDismissCardMenuOnScrollOutOfView
				then
					scrollingFrame2 = scrollingFrame
				end

				v7.scrollingFrame = scrollingFrame2

				v7.chromeEnabled = enabled
				local getUniversesExposedTo

				if getFFlagAddPeoplePageCardLayout() and LocalStore then
					getUniversesExposedTo = LocalStore.getUniversesExposedTo
				end

				v7.getUniversesExposedTo = getUniversesExposedTo
				local addUniverseToExposureList

				if getFFlagAddPeoplePageCardLayout() and LocalStore then
					addUniverseToExposureList = LocalStore.addUniverseToExposureList
				end

				v7.addUniverseToExposureList = addUniverseToExposureList
				local minimumCardWidth

				if FFlagSideSheetOpenPeoplePage and v5 and v6 then
					minimumCardWidth = constants.PEOPLEPAGE.PEOPLE_CARDS.SIDE_SHEET_MINIMUM_CARD_WIDTH
				end

				v7.minimumCardWidth = minimumCardWidth
				people = createElement(CoreScriptsRootProvider, {}, {
					LocalizationProvider = createElement2(LocalizationProvider, {
						localization = localization
					}, {
						FocusRoot = createElement3(PeopleFocusRoot, {}, {
							PeopleReactView = createElement4(peopleReactView, v7)
						})
					})
				})
			end

			if FFlagSideSheetOpenPeoplePage then
				return people and React.createElement(sideSheetFocusContext.Provider, {
					value = v5 and v6
				}, { People = people })
			end

			return people
		end

		v = ReactRoblox.createRoot(newPage.Page)

		if v then
			v:render(React.createElement(PeopleConditionalView))
		end
	end

	newPage.Displayed.Event:Connect(function()
		if not signal(false) then
			createReactTree()
			v2(true)
		end

		local menuContainer = newPage.Page:FindFirstAncestor("MenuContainer")

		local bottomButtonFrame = menuContainer and menuContainer:FindFirstChild("BottomButtonFrame", true)

		if bottomButtonFrame then
			bottomButtonFrame.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
		end
	end)
	SettingsShowSignal:connect(function(p)
		if not p then
			v2(false)
		end
	end)

	newPage.Page.Size = UDim2.new(1, 0, 0, 0)
	newPage.Page.AutomaticSize = Enum.AutomaticSize.Y

	return newPage
end

if FFlagRefactorPeoplePage() then
	return createPeoplePage()
end

return require(Modules.Settings.Pages.Players)
