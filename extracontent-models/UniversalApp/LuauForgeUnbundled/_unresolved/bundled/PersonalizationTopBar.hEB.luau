local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local useUserExperiment = RoactAppExperiment.useUserExperiment
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local verticalEfficiencyExperimentation = require("@luauforge/bundled/edc").VerticalEfficiencyExperimentation

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local module2 = require("@luauforge/bundled/fox")
local module3 = require("@luauforge/bundled/fsX")
local module4 = require("@luauforge/bundled/hEC")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppMoveProfileIntoTopBar = SharedFlags.FFlagLuaAppMoveProfileIntoTopBar
local fFlagLuaAppMoveProfileIntoTopBarIXP = SharedFlags.FFlagLuaAppMoveProfileIntoTopBarIXP
local fFlagSearchTopResultsTabEnabledForAll = SharedFlags.FFlagSearchTopResultsTabEnabledForAll
local fFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local fFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local module6 = require("@luauforge/bundled/dHC")
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local fFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground
local fFlagAppThemeHalloween2026HomeBackground = SharedFlags.FFlagAppThemeHalloween2026HomeBackground

local module7 = require("@luauforge/bundled/hEE")
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay
local splitPaneStore, v5, v6

if fFlagEnableSplitPane then
	splitPaneStore = require("@luauforge/bundled/dFR").SplitPaneStore
	v5 = require("@luauforge/bundled/dDG")
	v6 = require("@luauforge/bundled/dHu")
else
	splitPaneStore = nil
	v6 = nil
	v5 = nil
end

local v7 = if fFlagEnableSplitPaneAvatarOverlay then require("@luauforge/bundled/hEF") else nil

local function makePadding(p2)
	return function()
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, p2, 1, 0)
		})
	end
end

local fn = fFlagLuaAppEnableChartsPageProfileLink and function(p2)
	return function(p3)
		return React.createElement(module4, { source = p2 })
	end
end or nil

local function usePersonalizationTopBarLayout(useGridPageLayout, x)
	local store = splitPaneStore.getStore()
	local v8 = SignalsReact.useSignalState(store.getSupportPaneModeIfActive)
	local v9 = SignalsReact.useSignalState(store.getSupportWidthFraction)
	local v10 = v6.useNavBarPlacement()
	local v11 = v6.useNavBarSize()
	local v12 = v10 ~= v6.Placement.Left and 0 or v11

	local v13 = useGridPageLayout and v8 == v5.Enums.SupportPaneMode.Collapsed

	if v8 == nil or v8 == v5.Enums.SupportPaneMode.Collapsed then
		return {
			showUserInfo = v13,
			forceCompactMode = useGridPageLayout and x < module3.COMPACT_WIDTH_BREAKPOINT
		}
	end

	local v14 = v8 ~= v5.Enums.SupportPaneMode.Normal and 0 or x * v9
	return {
		showUserInfo = v13,
		forceCompactMode = x - v12 - v14 < module3.COMPACT_WIDTH_BREAKPOINT_WITHOUT_USER_INFO
	}
end

local function PersonalizationTopBar(props)
	local v8, v9 = useUserExperiment({ appUserLayers.OmniSearchResultsPageUXExposureLayer }, function(p2)
		local v10 = p2[appUserLayers.OmniSearchResultsPageUXExposureLayer] or {}
		local isSearchTypeAuto = v10.isSearchTypeAuto

		if fFlagSearchTopResultsTabEnabledForAll then
			return isSearchTypeAuto, nil
		end

		return isSearchTypeAuto, v10.isTopPageEnabled
	end, false)

	local v10 = nil

	local v11 = useSelector(function(p2)
		return p2.ScreenSize
	end)
	local v12

	if fFlagEnableSplitPane then
		local v13 = usePersonalizationTopBarLayout(props.useGridPageLayout or false, v11.X)
		v12 = v13.showUserInfo
		v10 = v13.forceCompactMode
	else
		v12 = props.useGridPageLayout
	end

	local v13

	if v12 then
		local v14 = if fFlagLuaAppEnableChartsPageProfileLink then fn(props.profileSource) else module4
		local v15 = 0
		v13 = {
			v14,
			function()
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, v15, 1, 0)
				})
			end,
			module2.SearchButton,
			module2.BuyRobuxButton,
			module2.NotificationsButton
		}

		if not fFlagEnableSplitPane then
			v10 = v11.X < module3.COMPACT_WIDTH_BREAKPOINT
		end
	else
		v13 = { module2.SearchButton, module2.BuyRobuxButton, module2.NotificationsButton }
	end

	if fFlagEnableSplitPaneAvatarOverlay then
		table.insert(v13, v7)
	end

	local v14

	if fFlagLuaAppMoveProfileIntoTopBar then
		v14 = not props.useGridPageLayout
			and (not fFlagLuaAppMoveProfileIntoTopBarIXP or verticalEfficiencyExperimentation.getIsProfileMovedToTopBar())
	end

	local createElement = React.createElement
	local container = module2.Container
	local v15 = {
		tag = props.tag,
		titleText = props.titleText,
		ZIndex = not props.zIndexOverride and 2 or props.zIndexOverride,
		forceCompactMode = v10,
		leftItem = 0,
		rightItems = 0,
		searchType = 0,
		sideMarginOverride = 0,
		enableHeaderImageBackground = 0,
		transparentBackground = 0,
		backgroundSlot = 0
	}

	local v16 = if fFlagLuaAppMoveProfileIntoTopBar and v14 or module6 or fFlagEnableHomeRobloxLogo then module2.PersonalizationLeftItem else module2.BackButton
	v15.leftItem = v16

	v15.rightItems = v13
	local v17

	if fFlagSearchTopResultsTabEnabledForAll or v9 then
		v17 = searchTypes.TopResults
	elseif v8 then
		v17 = searchTypes.Auto
	end

	v15.searchType = v17

	v15.sideMarginOverride = props.sideMarginOverride

	local v18 = if fFlagEnableClassicThemeHeaderBackground then props.enableHeaderImageBackground else nil
	v15.enableHeaderImageBackground = v18

	local v19 = if fFlagAppThemeHalloween2026HomeBackground and not module7 then props.transparentBackground else nil
	v15.transparentBackground = v19

	local v20 = if fFlagAppThemeHalloween2026HomeBackground and not module7 then props.backgroundSlot else nil
	v15.backgroundSlot = v20
	return createElement(container, v15)
end

if fFlagSignalsNavP3fGameDetails then
	PersonalizationTopBar = React.memo(PersonalizationTopBar)
end

return PersonalizationTopBar
