local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Display = require(parent.Display)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local FFlagAppThemeHalloween2026BuildBackground = require(BuildExperience.Flags.FFlagAppThemeHalloween2026BuildBackground)
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground

local HeaderBar = UIBlox.App.Bar.HeaderBar
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP
local FlyoutSidePanel = require(parent.FlyoutSidePanel)
local FlyoutLeftHeader = FlyoutSidePanel.Components.FlyoutLeftHeader
local SearchBarContainer = require(BuildExperience.Components.SearchBar.SearchBarContainer)
local GetSearchQueryStore = require(BuildExperience.Stores.GetSearchQueryStore)
require(BuildExperience.Stores.GetSearchQueryStore.createSearchQueryStore)

local defineFastInt = game:DefineFastInt("BuildSearchBarWidth", 400)

local function renderFlyoutLeftHeader(title: string?)
	local createElement = React.createElement
	local isFlyoutEntrypointEnabled

	if FFlagEnableHomeRobloxLogo then
		isFlyoutEntrypointEnabled = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
	end

	return createElement(FlyoutLeftHeader, {
		titleText = title,
		isRobloxLogoEnabled = false,
		isFlyoutEntrypointEnabled = isFlyoutEntrypointEnabled,
		isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
	})
end

local function renderEmptyRight(): nil
	return nil
end

local function HeaderSearch(p)
	local v = useScaledValue(defineFastInt)
	local size_2200 = useTokens().Size.Size_2200
	local searchQueryStore = p.searchQueryStore
	local v2 = searchQueryStore.useIsSearchActive()
	local query = SignalsReact.useSignalBinding(searchQueryStore.getDraftQuery)
	local v3 = useLocalization({
		searchbarPlaceholder = "Feature.Build.Label.SearchGames",
		cancelText = "Feature.Build.Action.Cancel"
	})

	React.useEffect(function()
		return function()
			searchQueryStore.setIsSearchActive(false)
		end
	end, { searchQueryStore })

	local createElement = React.createElement

	local v4 = {
		LeftSpacer = React.createElement(View, { LayoutOrder = 1, tag = "fill size-0-full" }),
		SearchBarContainer = React.createElement(
			View,
			{ LayoutOrder = 2, Size = UDim2.new(0, v, 1, 0), tag = "row align-y-center shrink" },
			{
				SearchBar = React.createElement(SearchBarContainer, {
					clear = searchQueryStore.clear,
					onDismiss = searchQueryStore.endSearch,
					onFocusGained = searchQueryStore.beginSearch,
					onFocusLost = searchQueryStore.endSearchIfEmpty,
					placeholder = v3.searchbarPlaceholder,
					query = query,
					setQuery = searchQueryStore.setQuery
				})
			}
		),
		RightContainer = 0
	}

	local createElement2 = React.createElement
	local cancel

	if v2 then
		cancel = React.createElement(Button, {
			width = UDim.new(0, size_2200),
			text = v3.cancelText,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			onActivated = searchQueryStore.endSearch,
			testId = "BuildPageHeader.SearchCancelButton"
		})
	end

	v4.RightContainer = createElement2(View, {
		LayoutOrder = 3,
		tag = "row align-y-center fill size-0-full"
	}, {
		Cancel = cancel
	})
	return createElement(
		View,
		{
			tag = "row align-y-center gap-small size-full",
			testId = "BuildPageHeader.CenterSearchContainer"
		},
		v4
	)
end

local function HeaderCenter(p)
	local displayStore = Display.GetDisplayStore(false)

	if SignalsReact.useSignalState(displayStore.getDisplaySize) == Enum.DisplaySize.Small then
		return nil
	end

	return React.createElement(HeaderSearch, {
		searchQueryStore = p.searchQueryStore or GetSearchQueryStore()
	})
end

local function BuildPageHeader(props)
	local title = useLocalization({ title = LocalizationStrings.BUILD_HEADER_TITLE }).title
	local v

	if FFlagAppThemeHalloween2026BuildBackground then
		v = useThemeBackground() ~= nil
	else
		v = false
	end

	local flyoutSidePanelEnabled = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()

	local displayStore = Display.GetDisplayStore(false)
	local v2 = SignalsReact.useSignalState(displayStore.getDisplaySize)
	local searchQueryStore = props.searchQueryStore or GetSearchQueryStore()
	local v3 = v2 ~= Enum.DisplaySize.Small
	local v4 = v2 == Enum.DisplaySize.Small and props.onOpenSearch ~= nil

	local fn = v3 and function()
		return React.createElement(HeaderCenter, { searchQueryStore = searchQueryStore })
	end or nil
	local renderRight

	if v4 then
		renderRight = function()
			local createElement = React.createElement
			local search

			if v4 then
				search = React.createElement(IconButton, {
					LayoutOrder = 1,
					icon = IconName.MagnifyingGlass,
					isCircular = true,
					onActivated = props.onOpenSearch,
					size = InputSize.Medium,
					testId = "BuildPageHeader.SearchButton",
					variant = ButtonVariant.Utility
				})
			end

			return createElement(
				View,
				{
					tag = "row align-y-center gap-medium auto-xy",
					testId = "BuildPageHeader.RightActions"
				},
				{ Search = search }
			)
		end
	else
		renderRight = renderEmptyRight
	end

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.LayoutOrder,
		ZIndex = 3,
		tag = "composition-content-header size-full-0 auto-y",
		Size = UDim2.new(1, 0, 0, props.height),
		testId = "BuildPageHeader"
	}

	local createElement2 = React.createElement
	local v6 = {
		barHeight = props.height,
		isTitleCentered = false,
		paddingLeft = UDim.new(0, 0),
		paddingRight = UDim.new(0, 0),
		renderLeft = flyoutSidePanelEnabled and function()
			return renderFlyoutLeftHeader(title)
		end or nil,
		title = 0,
		renderCenter = 0,
		renderRight = 0,
		backgroundTransparency = 0
	}
	local title2

	if not flyoutSidePanelEnabled then
		title2 = title
	end

	v6.title = title2
	v6.renderCenter = fn
	v6.renderRight = renderRight
	v6.backgroundTransparency = v and 1 or nil
	return createElement(View, v5, { HeaderBar = createElement2(HeaderBar, v6) })
end

return BuildPageHeader
