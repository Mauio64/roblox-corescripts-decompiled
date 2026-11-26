local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local module = require("@luauforge/bundled/dKz")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local gameSortGroups = require("@luauforge/bundled/cBc").GameSortGroups
local refreshExpiringSortTokens = require("@luauforge/bundled/dtb").Modules.LuaApp.Thunks.Games.RefreshExpiringSortTokens

local module2 = require("@luauforge/bundled/hPC")
local module3 = require("@luauforge/deferred/hPI")
local module4 = require("@luauforge/deferred/hPJ")

local chartsSortDetailPage = require("@luauforge/bundled/gfF").ChartsSortDetailPage

require("@luauforge/bundled/dXB")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure

local module6 = require("@luauforge/bundled/hPK")
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground

local function SduiChartsSortDetailPage(props)
	if fFlagLuaAppLogChartsAppPageExposure then
		module4()
	end

	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)

	React.useEffect(function()
		v5(refreshExpiringSortTokens(v6, { gameSortGroups.GamesList }))
	end, { v5, v6 })

	local v7 = module3()
	local v8

	if module6 then
		local v9 = useThemeBackground()
		v8 = React.useMemo(function()
			if v9 then
				return { Color3 = v9.baseColor, Transparency = 1 }
			end

			return nil
		end, { v9 })
	end

	local v9 = useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)

	local v10 = fFlagAppIaScrollAway and module.getScrollAwayEnabled()

	local udim = if v10 then UDim2.fromOffset(0, 0) else UDim2.fromOffset(0, v9)
	local udim2 = if v10 then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 1, -v9)

	if not v10 then
		v9 = nil
	end

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			TopBar = React.createElement(module2, {
				titleText = v7,
				tag = compositionTags.ContentRegion.Header,
				sideMarginOverride = 0
			}),
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
					pageTopPadding = v9,
					backgroundStyle = v8
				})
			})
		}
	)
end

return SduiChartsSortDetailPage
