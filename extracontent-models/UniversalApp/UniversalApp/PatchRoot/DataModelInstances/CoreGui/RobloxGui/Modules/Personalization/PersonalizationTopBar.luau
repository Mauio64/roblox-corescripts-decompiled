local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local useUserExperiment = RoactAppExperiment.useUserExperiment
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local VerticalEfficiencyExperimentation = require(CorePackages.Workspace.Packages.DiscoveryUtils).VerticalEfficiencyExperimentation
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local TopBarConstants = require(Modules.LuaApp.Components.TopBar.TopBarConstants)
local UserInfo = require(Modules.LuaApp.Components.GridHome.Header.UserInfo)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppMoveProfileIntoTopBar = SharedFlags.FFlagLuaAppMoveProfileIntoTopBar
local FFlagLuaAppMoveProfileIntoTopBarIXP = SharedFlags.FFlagLuaAppMoveProfileIntoTopBarIXP
local FFlagSearchTopResultsTabEnabledForAll = SharedFlags.FFlagSearchTopResultsTabEnabledForAll
local FFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local FFlagLuaAppChartsStickyHeader = SharedFlags.FFlagLuaAppChartsStickyHeader

local function makePadding(p1) -- line: 37
	-- upvalues: React (copy)
	return function() -- line: 38
		-- upvalues: React (copy), p1 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, p1, 1, 0)
		})
	end
end

local u23 = nil

if FFlagLuaAppEnableChartsPageProfileLink then
	function u23(s1: string?) -- line: 48
		-- upvalues: React (copy), UserInfo (copy)
		return function(_) -- line: 49
			-- upvalues: React (copy), UserInfo (copy), s1 (copy)
			return React.createElement(UserInfo, {
				source = s1
			})
		end
	end
end

return function(t1: {[any]: any}) -- line: 60
	-- upvalues: useUserExperiment (copy), AppUserLayers (copy), FFlagSearchTopResultsTabEnabledForAll (copy), useSelector (copy), FFlagLuaAppEnableChartsPageProfileLink (copy), u23 (ref), UserInfo (copy), React (copy), TopBar (copy), TopBarConstants (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FFlagLuaAppMoveProfileIntoTopBarIXP (copy), VerticalEfficiencyExperimentation (copy), FFlagLuaAppChartsStickyHeader (copy), FFlagEnableFlyoutSidePanel (copy), FFlagEnableHomeRobloxLogo (copy), SearchTypes (copy)
	local v27, v28 = useUserExperiment({ AppUserLayers.OmniSearchResultsPageUXExposureLayer }, function(p3) -- line: 63
		-- upvalues: AppUserLayers (copy), FFlagSearchTopResultsTabEnabledForAll (copy)
		local v41 = p3[AppUserLayers.OmniSearchResultsPageUXExposureLayer] or {}
		local isSearchTypeAuto = v41.isSearchTypeAuto

		if not FFlagSearchTopResultsTabEnabledForAll then
			return isSearchTypeAuto, v41.isTopPageEnabled
		end

		return isSearchTypeAuto, nil
	end, false)
	local v29 = nil
	local v30 = useSelector(function(p4) -- line: 77
		return p4.ScreenSize
	end)
	local t2

	if t1.useGridPageLayout then
		t2 = {}

		local v32 = if not FFlagLuaAppEnableChartsPageProfileLink then UserInfo else u23(t1.profileSource)
		local n1 = 0

		local function v34() -- line: 38
			-- upvalues: React (copy), n1 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, n1, 1, 0)
			})
		end

		local SearchButton = TopBar.SearchButton
		local BuyRobuxButton = TopBar.BuyRobuxButton
		local NotificationsButton = TopBar.NotificationsButton

		t2[1] = v32
		t2[2] = v34
		t2[3] = SearchButton
		t2[4] = BuyRobuxButton
		t2[5] = NotificationsButton
		v29 = v30.X < TopBarConstants.COMPACT_WIDTH_BREAKPOINT
	else
		t2 = {
			TopBar.SearchButton,
			TopBar.BuyRobuxButton,
			TopBar.NotificationsButton
		}
	end

	local v38 = nil

	if FFlagLuaAppMoveProfileIntoTopBar then
		v38 = not t1.useGridPageLayout and (not FFlagLuaAppMoveProfileIntoTopBarIXP or VerticalEfficiencyExperimentation.getIsProfileMovedToTopBar())
	end

	return React.createElement(TopBar.Container, {
		tag = t1.tag,
		titleText = t1.titleText,
		ZIndex = (not FFlagLuaAppChartsStickyHeader or not t1.zIndexOverride) and 2 or t1.zIndexOverride,
		forceCompactMode = v29,
		leftItem = if not (not not FFlagLuaAppMoveProfileIntoTopBar and v38) and (not FFlagEnableFlyoutSidePanel and not FFlagEnableHomeRobloxLogo) then TopBar.BackButton else TopBar.PersonalizationLeftItem,
		rightItems = t2,
		searchType = if not FFlagSearchTopResultsTabEnabledForAll and not v28 then if not v27 then nil else SearchTypes.Auto else SearchTypes.TopResults,
		sideMarginOverride = t1.sideMarginOverride
	})
end
