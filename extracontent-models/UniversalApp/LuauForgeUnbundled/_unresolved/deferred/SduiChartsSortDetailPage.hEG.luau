local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local compositionTags = require("@luauforge/bundled/gns").CompositionTags
local module = require("@luauforge/bundled/dHu")
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local gameSortGroups = require("@luauforge/bundled/cyO").GameSortGroups
local refreshExpiringSortTokens = require("@luauforge/bundled/dpZ").Modules.LuaApp.Thunks.Games.RefreshExpiringSortTokens

local module2 = require("@luauforge/bundled/hEB")
local module3 = require("@luauforge/deferred/hEH")
local module4 = require("@luauforge/deferred/hEI")

local chartsSortDetailPage = require("@luauforge/bundled/fBm").ChartsSortDetailPage

require("@luauforge/bundled/dUe")

local defineFastFlag = game:DefineFastFlag("LuaAppSduiSortDetailTenFootGapFix", false)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure

local module6 = require("@luauforge/bundled/hEJ")
local useThemeBackground = require("@luauforge/bundled/eeu").useThemeBackground

local function SduiChartsSortDetailPage(props)
	if fFlagLuaAppLogChartsAppPageExposure then
		module4()
	end

	local v5 = useUiModeInfo()
	local v6 = defineFastFlag or v5.uiMode ~= uiMode.TenFoot

	local v7 = useDispatch()
	local v8 = useRoactService(roactNetworking)

	React.useEffect(function()
		v7(refreshExpiringSortTokens(v8, { gameSortGroups.GamesList }))
	end, { v7, v8 })

	local v9 = module3()
	local v10

	if module6 then
		local v11 = useThemeBackground()
		v10 = React.useMemo(function()
			if v11 then
				return { Color3 = v11.baseColor, Transparency = 1 }
			end

			return nil
		end, { v11 })
	end

	local v11 = useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)

	local v12 = fFlagAppIaScrollAway and module.getScrollAwayEnabled()

	local udim = if v12 then UDim2.fromOffset(0, 0) else UDim2.fromOffset(0, v11)
	local udim2 = if v12 then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 1, -v11)

	if not v12 then
		v11 = nil
	end

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v16 = if v6 then React.createElement(module2, {
		titleText = v9,
		tag = compositionTags.ContentRegion.Header,
		sideMarginOverride = 0
	}) else nil
	return createElement("Frame", v14, {
		TopBar = v16,
		Content = React.createElement("Frame", {
			Position = udim,
			Size = udim2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1
		}, {
			ChartsSortDetailPage = React.createElement(chartsSortDetailPage, {
				sortId = props.sortId,
				pageContext = props.pageContext,
				pageTimer = props.pageTimer,
				pageTopPadding = v11,
				backgroundStyle = v10
			})
		})
	})
end

return SduiChartsSortDetailPage
