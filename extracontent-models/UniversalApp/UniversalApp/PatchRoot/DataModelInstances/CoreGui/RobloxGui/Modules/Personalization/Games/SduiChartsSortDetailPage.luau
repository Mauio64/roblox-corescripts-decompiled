local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local CompositionTags = require(CorePackages.Workspace.Packages.AppComposition).CompositionTags
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local PersonalizationTopBar = require(Modules.Personalization.PersonalizationTopBar)
local useChartsTitleText = require(Modules.Personalization.Games.useChartsTitleText)
local useLogSduiChartsExposure = require(Modules.Personalization.Games.useLogSduiChartsExposure)
local ChartsSortDetailPage = require(CorePackages.Workspace.Packages.Charts).ChartsSortDetailPage

require(CorePackages.Workspace.Packages.SduiSharedUtilities)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure
local FFlagLuaAppCompositionHome = SharedFlags.FFlagLuaAppCompositionHome
local FFlagLuaAppCompositionCharts = SharedFlags.FFlagLuaAppCompositionCharts
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local v19 = FFlagLuaAppCompositionHome or (FFlagLuaAppCompositionCharts or FFlagLuaAppCompositionAlways)

local function SduiChartsSortDetailPage(t1: {[any]: any}) -- line: 41
	-- upvalues: FFlagLuaAppLogChartsAppPageExposure (copy), useLogSduiChartsExposure (copy), useUiModeInfo (copy), UiMode (copy), useChartsTitleText (copy), useSelector (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), React (copy), PersonalizationTopBar (copy), v19 (copy), CompositionTags (copy), ChartsSortDetailPage (copy)
	if FFlagLuaAppLogChartsAppPageExposure then
		useLogSduiChartsExposure()
	end

	local v22 = useUiModeInfo().uiMode ~= UiMode.TenFoot
	local v23 = useChartsTitleText()
	local v24 = useSelector(function(p1) -- line: 51
		return p1.TopBar.topBarHeight
	end)
	local v25 = FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled()
	local v26 = if not v25 then UDim2.fromOffset(0, v24) else UDim2.fromOffset(0, 0)
	local v27 = if not v25 then UDim2.new(1, 0, 1, -v24) else UDim2.new(1, 0, 1, 0)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		TopBar = if not v22 then nil else React.createElement(PersonalizationTopBar, {
			titleText = v23,
			tag = if not v19 then nil else CompositionTags.ContentRegion.Header,
			sideMarginOverride = if not v19 then nil else 0
		}),
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
			Position = v26,
			Size = v27
		}, {
			ChartsSortDetailPage = React.createElement(ChartsSortDetailPage, {
				sortId = t1.sortId,
				pageContext = t1.pageContext,
				pageTimer = t1.pageTimer,
				pageTopPadding = if not v25 then nil else v24
			})
		})
	})
end

return SduiChartsSortDetailPage
