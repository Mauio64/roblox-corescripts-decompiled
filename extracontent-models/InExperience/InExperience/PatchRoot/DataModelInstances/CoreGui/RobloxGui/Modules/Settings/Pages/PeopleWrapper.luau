local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local FFlagRefactorPeoplePage = require(Modules.Settings.Flags.FFlagRefactorPeoplePage)
local v9 = game:DefineFastFlag("RenderPeoplePageOnTabSwitch", false)
local FFlagRelocateMobileMenuButtons = require(Modules.Settings.Flags.FFlagRelocateMobileMenuButtons)
local FIntRelocateMobileMenuButtonsVariant = require(Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
local FFlagIEMFocusNavPeoplePageToButtons = require(CorePackages.Workspace.Packages.SharedFlags).FFlagIEMFocusNavPeoplePageToButtons
local Chrome = RobloxGui.Modules.Chrome
local v14 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v15 = if not v14 then nil else require(Chrome.ChromeShared.Service.LocalStore)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local v22 = Localization.new(LocalizationService.RobloxLocaleId)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local BlockingModalScreen = require(Modules.Settings.Components.Blocking.BlockingModalScreen)
local uiblox = BuilderIcons.Migration.uiblox
local PeopleService = require(CorePackages.Workspace.Packages.PeopleService)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local useRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry
local Constants = nil

if FFlagRefactorPeoplePage() then
	Constants = require(CorePackages.Workspace.Packages.PeopleReactView).Constants
end

local v33 = PeopleService.getService("Flags")
local GetFFlagAddPeoplePageCardLayout = v33.GetFFlagAddPeoplePageCardLayout
local GetFFlagPeoplePageLazyRenderCards = v33.GetFFlagPeoplePageLazyRenderCards
local FFlagEnablePeopleListLazyRender = v33.FFlagEnablePeopleListLazyRender
local FFlagPeopleCardsEnableVirtualizedGrid = v33.FFlagPeopleCardsEnableVirtualizedGrid
local FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView = v33.FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView
local FFlagPeoplePageFlipVolumePopoverToFitViewport = v33.FFlagPeoplePageFlipVolumePopoverToFitViewport
local FFlagPeoplePageDismissCardMenuOnScrollOutOfView = v33.FFlagPeoplePageDismissCardMenuOnScrollOutOfView
local u41 = nil
local v42, v43 = Signals.createSignal(false)

local function PeopleFocusRoot(p1) -- line: 71
	-- upvalues: useRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), React (copy), FocusRoot (copy), FFlagIEMFocusNavPeoplePageToButtons (copy)
	local v47 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.CentralOverlay) == nil

	return React.createElement(FocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView,
		isAutoFocusRoot = not FFlagIEMFocusNavPeoplePageToButtons and v47
	}, p1.children)
end
local function createPeoplePage() -- line: 83
	-- upvalues: CorePackages (copy), SettingsPageFactory (copy), Constants (ref), uiblox (copy), BuilderIcons (copy), v22 (copy), FFlagRelocateMobileMenuButtons (copy), FIntRelocateMobileMenuButtonsVariant (copy), u41 (ref), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView (copy), FFlagPeoplePageFlipVolumePopoverToFitViewport (copy), FFlagPeoplePageDismissCardMenuOnScrollOutOfView (copy), SignalsReact (copy), v42 (copy), React (copy), CoreScriptsRootProvider (copy), LocalizationProvider (copy), PeopleFocusRoot (copy), BlockingModalScreen (copy), v14 (copy), GetFFlagAddPeoplePageCardLayout (copy), v15 (copy), ReactRoblox (copy), v9 (copy), v43 (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), SettingsShowSignal (copy)
	local PeopleReactView = require(CorePackages.Workspace.Packages.PeopleReactView).PeopleReactView
	local PeopleService2 = require(CorePackages.Workspace.Packages.PeopleService)
	local v50 = SettingsPageFactory:CreateNewPage()

	v50.TabHeader.Name = Constants.PEOPLEPAGE.TAB_HEADER.NAME
	v50.Page.Name = Constants.PEOPLEPAGE.PAGE_ID

	local v51 = uiblox[Constants.PEOPLEPAGE.TAB_HEADER.ICON]

	v50.TabHeader.TabLabel.Icon.Text = v51.name
	v50.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v51.variant]
	v50.TabHeader.TabLabel.Title.Text = v22:Format(Constants.PEOPLEPAGE.TAB_HEADER.TEXT)

	local v52 = PeopleService2.getService("SettingsHubService")

	v52.register(v50)

	function v50.CreateMenuButtonsContainer(_) -- line: 100
		-- upvalues: v52 (copy)
		v52.setShowMenuButtonsContainer(true)
	end

	if FFlagRelocateMobileMenuButtons and FIntRelocateMobileMenuButtonsVariant == 2 then
		function v50.UnmountMenuButtonsContainer(_) -- line: 105
			-- upvalues: v52 (copy)
			v52.setShowMenuButtonsContainer(false)
		end
	end

	local function createReactTree() -- line: 111
		-- upvalues: u41 (ref), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView (copy), FFlagPeoplePageFlipVolumePopoverToFitViewport (copy), FFlagPeoplePageDismissCardMenuOnScrollOutOfView (copy), v50 (copy), SignalsReact (copy), v42 (copy), React (copy), CoreScriptsRootProvider (copy), LocalizationProvider (copy), v22 (copy), PeopleFocusRoot (copy), PeopleReactView (copy), BlockingModalScreen (copy), v14 (copy), GetFFlagAddPeoplePageCardLayout (copy), v15 (copy), ReactRoblox (copy)
		if u41 then
			return
		end

		local v56 = if not GetFFlagPeoplePageLazyRenderCards() and (not FFlagEnablePeopleListLazyRender and (not FFlagPeopleCardsEnableVirtualizedGrid and (not FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView and (not FFlagPeoplePageFlipVolumePopoverToFitViewport and not FFlagPeoplePageDismissCardMenuOnScrollOutOfView)))) then nil else v50.Page:FindFirstAncestorWhichIsA("ScrollingFrame")

		local function PeopleConditionalView() -- line: 125
			-- upvalues: SignalsReact (copy), v42 (copy), React (copy), CoreScriptsRootProvider (copy), LocalizationProvider (copy), v22 (copy), PeopleFocusRoot (copy), PeopleReactView (copy), BlockingModalScreen (copy), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView (copy), FFlagPeoplePageFlipVolumePopoverToFitViewport (copy), FFlagPeoplePageDismissCardMenuOnScrollOutOfView (copy), v56 (copy), v14 (copy), GetFFlagAddPeoplePageCardLayout (copy), v15 (copy)
			if SignalsReact.useSignalState(v42) then
				return (React.createElement(CoreScriptsRootProvider, {}, {
					LocalizationProvider = React.createElement(LocalizationProvider, {
						localization = v22
					}, {
						FocusRoot = React.createElement(PeopleFocusRoot, {}, {
							PeopleReactView = React.createElement(PeopleReactView, {
								blockingModalScreen = BlockingModalScreen,
								blockingFlags = {},
								scrollingFrame = if not GetFFlagPeoplePageLazyRenderCards() and (not FFlagEnablePeopleListLazyRender and (not FFlagPeopleCardsEnableVirtualizedGrid and (not FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView and (not FFlagPeoplePageFlipVolumePopoverToFitViewport and not FFlagPeoplePageDismissCardMenuOnScrollOutOfView)))) then nil else v56,
								chromeEnabled = v14,
								getUniversesExposedTo = if not GetFFlagAddPeoplePageCardLayout() or not v15 then nil else v15.getUniversesExposedTo,
								addUniverseToExposureList = if not GetFFlagAddPeoplePageCardLayout() or not v15 then nil else v15.addUniverseToExposureList
							})
						})
					})
				}))
			end

			return nil
		end

		u41 = ReactRoblox.createRoot(v50.Page)

		if u41 then
			u41:render(React.createElement(PeopleConditionalView))
		end
	end

	v50.Displayed.Event:Connect(function() -- line: 168
		-- upvalues: v9 (copy), v42 (copy), createReactTree (copy), v43 (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), v50 (copy)
		if not v9 or not v42(false) then
			createReactTree()
			v43(true)
		end

		if FFlagIEMFocusNavPeoplePageToButtons then
			local MenuContainer = v50.Page:FindFirstAncestor("MenuContainer")

			if MenuContainer then
				local BottomButtonFrame = MenuContainer:FindFirstChild("BottomButtonFrame", true)

				if BottomButtonFrame then
					BottomButtonFrame.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
				end
			end
		end
	end)

	if v9 then
		SettingsShowSignal:connect(function(p4) -- line: 186
			-- upvalues: v43 (copy)
			if not p4 then
				v43(false)
			end
		end)
	else
		v50.Hidden.Event:Connect(function() -- line: 192
			-- upvalues: v43 (copy)
			v43(false)
		end)
	end

	v50.Page.Size = UDim2.new(1, 0, 0, 0)
	v50.Page.AutomaticSize = Enum.AutomaticSize.Y

	return v50
end

if FFlagRefactorPeoplePage() then
	return (createPeoplePage())
end

return require(Modules.Settings.Pages.Players)
