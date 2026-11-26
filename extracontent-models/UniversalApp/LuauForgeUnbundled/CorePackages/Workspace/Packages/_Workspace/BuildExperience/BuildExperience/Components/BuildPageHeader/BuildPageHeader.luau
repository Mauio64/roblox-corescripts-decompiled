local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Display")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local fFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local FFlagAppThemeHalloween2026BuildBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagAppThemeHalloween2026BuildBackground")
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ThemeBackground").useThemeBackground

local headerBar = UIBlox.App.Bar.HeaderBar
local button = Foundation.Button
local iconButton = Foundation.IconButton
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedExperimentDefinition").FlyoutSidePanelIXP
local flyoutLeftHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FlyoutSidePanel").Components.FlyoutLeftHeader
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchBar/SearchBarContainer")
local GetSearchQueryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore/createSearchQueryStore")

local defineFastInt = game:DefineFastInt("BuildSearchBarWidth", 400)

local function renderFlyoutLeftHeader(title)
	local createElement = React.createElement

	local v7 = if fFlagEnableHomeRobloxLogo then flyoutSidePanelIXP.isFlyoutSidePanelEnabled() else nil
	return createElement(flyoutLeftHeader, {
		titleText = title,
		isRobloxLogoEnabled = false,
		isFlyoutEntrypointEnabled = v7,
		isAlternateEntryPointEnabled = flyoutSidePanelIXP.isAlternateEntryPointEnabled()
	})
end

local function renderEmptyRight(): nil
	return nil
end

local function HeaderSearch(p2)
	local v5 = useScaledValue(defineFastInt)
	local size_2200 = useTokens().Size.Size_2200
	local searchQueryStore = p2.searchQueryStore
	local v6 = searchQueryStore.useIsSearchActive()
	local v7 = SignalsReact.useSignalBinding(searchQueryStore.getDraftQuery)
	local v8 = useLocalization({
		searchbarPlaceholder = "Feature.Build.Label.SearchGames",
		cancelText = "Feature.Build.Action.Cancel"
	})

	React.useEffect(function()
		return function()
			searchQueryStore.setIsSearchActive(false)
		end
	end, { searchQueryStore })

	local createElement = React.createElement

	local v11 = {
		LeftSpacer = React.createElement(view, {
			LayoutOrder = 1,
			tag = "fill size-0-full"
		}),
		SearchBarContainer = React.createElement(
			view,
			{
				LayoutOrder = 2,
				Size = UDim2.new(0, v5, 1, 0),
				tag = "row align-y-center shrink"
			},
			{
				SearchBar = React.createElement(module9, {
					clear = searchQueryStore.clear,
					onDismiss = searchQueryStore.endSearch,
					onFocusGained = searchQueryStore.beginSearch,
					onFocusLost = searchQueryStore.endSearchIfEmpty,
					placeholder = v8.searchbarPlaceholder,
					query = v7,
					setQuery = searchQueryStore.setQuery
				})
			}
		),
		RightContainer = 0
	}

	local createElement2 = React.createElement

	local v15 = if v6 then React.createElement(button, {
		width = UDim.new(0, size_2200),
		text = v8.cancelText,
		variant = buttonVariant.Utility,
		size = inputSize.Medium,
		onActivated = searchQueryStore.endSearch,
		testId = "BuildPageHeader.SearchCancelButton"
	}) else nil
	v11.RightContainer = createElement2(
		view,
		{ LayoutOrder = 3, tag = "row align-y-center fill size-0-full" },
		{ Cancel = v15 }
	)
	return createElement(
		view,
		{
			tag = "row align-y-center gap-small size-full",
			testId = "BuildPageHeader.CenterSearchContainer"
		},
		v11
	)
end

local function HeaderCenter(p2)
	local displayStore = Display.GetDisplayStore(false)

	if SignalsReact.useSignalState(displayStore.getDisplaySize) == Enum.DisplaySize.Small then
		return nil
	end

	return React.createElement(HeaderSearch, {
		searchQueryStore = p2.searchQueryStore or GetSearchQueryStore()
	})
end

local function BuildPageHeader(props)
	local title = useLocalization({ title = LocalizationStrings.BUILD_HEADER_TITLE }).title

	local v5 = if FFlagAppThemeHalloween2026BuildBackground then useThemeBackground() ~= nil else false

	local flyoutSidePanelEnabled = flyoutSidePanelIXP.isFlyoutSidePanelEnabled()

	local displayStore = Display.GetDisplayStore(false)
	local v6 = SignalsReact.useSignalState(displayStore.getDisplaySize)
	local searchQueryStore = props.searchQueryStore or GetSearchQueryStore()
	local v7 = v6 ~= Enum.DisplaySize.Small
	local v9 = v6 == Enum.DisplaySize.Small and props.onOpenSearch ~= nil

	local fn = v7 and function()
		return React.createElement(HeaderCenter, {
			searchQueryStore = searchQueryStore
		})
	end or nil
	local v10

	if v9 then
		v10 = function()
			local createElement = React.createElement

			local v14 = if v9 then React.createElement(iconButton, {
				LayoutOrder = 1,
				icon = iconName.MagnifyingGlass,
				isCircular = true,
				onActivated = props.onOpenSearch,
				size = inputSize.Medium,
				testId = "BuildPageHeader.SearchButton",
				variant = buttonVariant.Utility
			}) else nil
			return createElement(
				view,
				{
					tag = "row align-y-center gap-medium auto-xy",
					testId = "BuildPageHeader.RightActions"
				},
				{ Search = v14 }
			)
		end
	else
		v10 = renderEmptyRight
	end

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		ZIndex = 3,
		tag = "composition-content-header size-full-0 auto-y",
		Size = UDim2.new(1, 0, 0, props.height),
		testId = "BuildPageHeader"
	}, {
		HeaderBar = React.createElement(headerBar, {
			barHeight = props.height,
			isTitleCentered = false,
			paddingLeft = UDim.new(0, 0),
			paddingRight = UDim.new(0, 0),
			renderLeft = flyoutSidePanelEnabled and function()
				return renderFlyoutLeftHeader(title)
			end or nil,
			title = if not flyoutSidePanelEnabled then title else nil,
			renderCenter = fn,
			renderRight = v10,
			backgroundTransparency = v5 and 1 or nil
		})
	})
end

return BuildPageHeader
