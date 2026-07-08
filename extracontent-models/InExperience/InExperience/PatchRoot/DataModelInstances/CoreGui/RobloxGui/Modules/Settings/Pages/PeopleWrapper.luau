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
local u38 = nil
local v39, v40 = Signals.createSignal(false)

local function PeopleFocusRoot(p1) -- line: 65
	-- upvalues: useRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), React (copy), FocusRoot (copy), FFlagIEMFocusNavPeoplePageToButtons (copy)
	local v44 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.CentralOverlay) == nil

	return React.createElement(FocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView,
		isAutoFocusRoot = not FFlagIEMFocusNavPeoplePageToButtons and v44
	}, p1.children)
end
local function createPeoplePage() -- line: 77
	-- upvalues: CorePackages (copy), SettingsPageFactory (copy), Constants (ref), uiblox (copy), BuilderIcons (copy), v22 (copy), FFlagRelocateMobileMenuButtons (copy), FIntRelocateMobileMenuButtonsVariant (copy), u38 (ref), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), SignalsReact (copy), v39 (copy), React (copy), CoreScriptsRootProvider (copy), LocalizationProvider (copy), PeopleFocusRoot (copy), BlockingModalScreen (copy), v14 (copy), GetFFlagAddPeoplePageCardLayout (copy), v15 (copy), ReactRoblox (copy), v9 (copy), v40 (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), SettingsShowSignal (copy)
	local PeopleReactView = require(CorePackages.Workspace.Packages.PeopleReactView).PeopleReactView
	local PeopleService2 = require(CorePackages.Workspace.Packages.PeopleService)
	local v47 = SettingsPageFactory:CreateNewPage()

	v47.TabHeader.Name = Constants.PEOPLEPAGE.TAB_HEADER.NAME
	v47.Page.Name = Constants.PEOPLEPAGE.PAGE_ID

	local v48 = uiblox[Constants.PEOPLEPAGE.TAB_HEADER.ICON]

	v47.TabHeader.TabLabel.Icon.Text = v48.name
	v47.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v48.variant]
	v47.TabHeader.TabLabel.Title.Text = v22:Format(Constants.PEOPLEPAGE.TAB_HEADER.TEXT)

	local v49 = PeopleService2.getService("SettingsHubService")

	v49.register(v47)

	function v47.CreateMenuButtonsContainer(_) -- line: 94
		-- upvalues: v49 (copy)
		v49.setShowMenuButtonsContainer(true)
	end

	if FFlagRelocateMobileMenuButtons and FIntRelocateMobileMenuButtonsVariant == 2 then
		function v47.UnmountMenuButtonsContainer(_) -- line: 99
			-- upvalues: v49 (copy)
			v49.setShowMenuButtonsContainer(false)
		end
	end

	local function createReactTree() -- line: 105
		-- upvalues: u38 (ref), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), v47 (copy), SignalsReact (copy), v39 (copy), React (copy), CoreScriptsRootProvider (copy), LocalizationProvider (copy), v22 (copy), PeopleFocusRoot (copy), PeopleReactView (copy), BlockingModalScreen (copy), v14 (copy), GetFFlagAddPeoplePageCardLayout (copy), v15 (copy), ReactRoblox (copy)
		if u38 then
			return
		end

		local v53 = if not GetFFlagPeoplePageLazyRenderCards() and (not FFlagEnablePeopleListLazyRender and not FFlagPeopleCardsEnableVirtualizedGrid) then nil else v47.Page:FindFirstAncestorWhichIsA("ScrollingFrame")

		local function PeopleConditionalView() -- line: 116
			-- upvalues: SignalsReact (copy), v39 (copy), React (copy), CoreScriptsRootProvider (copy), LocalizationProvider (copy), v22 (copy), PeopleFocusRoot (copy), PeopleReactView (copy), BlockingModalScreen (copy), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), v53 (copy), v14 (copy), GetFFlagAddPeoplePageCardLayout (copy), v15 (copy)
			if SignalsReact.useSignalState(v39) then
				return (React.createElement(CoreScriptsRootProvider, {}, {
					LocalizationProvider = React.createElement(LocalizationProvider, {
						localization = v22
					}, {
						FocusRoot = React.createElement(PeopleFocusRoot, {}, {
							PeopleReactView = React.createElement(PeopleReactView, {
								blockingModalScreen = BlockingModalScreen,
								blockingFlags = {},
								scrollingFrame = if not GetFFlagPeoplePageLazyRenderCards() and (not FFlagEnablePeopleListLazyRender and not FFlagPeopleCardsEnableVirtualizedGrid) then nil else v53,
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

		u38 = ReactRoblox.createRoot(v47.Page)

		if u38 then
			u38:render(React.createElement(PeopleConditionalView))
		end
	end

	v47.Displayed.Event:Connect(function() -- line: 156
		-- upvalues: v9 (copy), v39 (copy), createReactTree (copy), v40 (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), v47 (copy)
		if not v9 or not v39(false) then
			createReactTree()
			v40(true)
		end

		if FFlagIEMFocusNavPeoplePageToButtons then
			local MenuContainer = v47.Page:FindFirstAncestor("MenuContainer")

			if MenuContainer then
				local BottomButtonFrame = MenuContainer:FindFirstChild("BottomButtonFrame", true)

				if BottomButtonFrame then
					BottomButtonFrame.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
				end
			end
		end
	end)

	if v9 then
		SettingsShowSignal:connect(function(p4) -- line: 174
			-- upvalues: v40 (copy)
			if not p4 then
				v40(false)
			end
		end)
	else
		v47.Hidden.Event:Connect(function() -- line: 180
			-- upvalues: v40 (copy)
			v40(false)
		end)
	end

	v47.Page.Size = UDim2.new(1, 0, 0, 0)
	v47.Page.AutomaticSize = Enum.AutomaticSize.Y

	return v47
end

if FFlagRefactorPeoplePage() then
	return (createPeoplePage())
end

return require(Modules.Settings.Pages.Players)
