local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/gRW")
local module2 = require("@luauforge/bundled/dKz")
local gameSortGroups = require("@luauforge/bundled/cBc").GameSortGroups
local React = require(CorePackages.Packages.React)
require("@luauforge/bundled/dXB")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking

local refreshExpiringSortTokens = require("@luauforge/bundled/dtb").Modules.LuaApp.Thunks.Games.RefreshExpiringSortTokens

local homeSortDetailPage = require("@luauforge/bundled/fzZ").HomeSortDetailPage
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateBack
local module3 = require("@luauforge/bundled/hPC")

local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaScrollAway

local module4 = require("@luauforge/bundled/hPK")
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground

local compositionTags = module.CompositionTags

local function SduiHomeSortDetailPage(props)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)
	local v7 = useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)

	local v8 = fFlagAppIaScrollAway and module2.getScrollAwayEnabled()

	local udim = if v8 then UDim2.fromOffset(0, 0) else UDim2.fromOffset(0, v7)
	local udim2 = if v8 then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 1, -v7)

	if not v8 then
		v7 = nil
	end

	local v9 = React.useCallback(function()
		v5(navigateBack())
	end, { v5 })
	local v10

	if module4 then
		local v11 = useThemeBackground()
		v10 = React.useMemo(function()
			if v11 then
				return { Color3 = v11.baseColor, Transparency = 1 }
			end

			return nil
		end, { v11 })
	end

	React.useEffect(function()
		v5(refreshExpiringSortTokens(v6, { gameSortGroups.GamesList }))
	end, { v5, v6 })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			TopBar = React.createElement(module3, {
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
				HomeSortDetailPage = React.createElement(homeSortDetailPage, {
					sortId = props.sortId,
					sortIndex = props.sortIndex,
					pageContext = props.pageContext,
					pageTimer = props.pageTimer,
					pageTopPadding = v7,
					onSortUnavailable = v9,
					backgroundStyle = v10
				})
			})
		}
	)
end

return SduiHomeSortDetailPage
