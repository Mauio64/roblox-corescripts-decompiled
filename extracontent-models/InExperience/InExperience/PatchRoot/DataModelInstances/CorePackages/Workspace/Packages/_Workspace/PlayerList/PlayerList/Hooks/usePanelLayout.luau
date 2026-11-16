local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local SignalsReact = require(parent2.SignalsReact)
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local Constants = require(parent.Common.Constants)
local computeMobilePanelSize = require(parent.Common.computeMobilePanelSize)
local computeDesktopPanelHeight = require(parent.Common.computeDesktopPanelHeight)
local PanelContentHeightStore = require(parent.Common.PanelContentHeightStore)
local LayoutValuesContext = require(parent.Common.LayoutValuesContext)
local getDeviceBottomInset = require(parent.Common.getDeviceBottomInset)
local useViewportSize = require(parent.Hooks.useViewportSize)

local FFlagPlayerListReskin = require(parent.Flags.FFlagPlayerListReskin)
local FFlagPlayerListFixPlatformLeaderboardSizing = require(parent.Flags.FFlagPlayerListFixPlatformLeaderboardSizing)

local function usePanelLayout(flag: boolean, p: number, flag2: boolean?)
	local v = useViewportSize()
	local v2 = useTokens()
	local scale = v2.Config.UI.Scale

	local topBarOffset = React.useContext(LayoutValuesContext).TopBarOffset or 0

	local v3 = SignalsReact.useSignalState(PanelContentHeightStore.getBodyContentHeight)

	local headerHeight = Constants.HEADER_HEIGHT * scale
	local columnHeaderHeight = Constants.COLUMN_HEADER_HEIGHT * scale
	local rowHeight = Constants.PLATFORM_ROW_HEIGHT * scale
	local v4 = Constants.ROW_PITCH * scale
	local statWidth = Constants.STAT_COLUMN_WIDTH * scale
	local v5 = Constants.PEOPLE_MIN_WIDTH * scale
	local size_200 = v2.Size.Size_200
	local v6 = useScaledValue(Constants.PANEL_SIZE_MIN_CAP)
	local v7 = useScaledValue(Constants.PANEL_SIZE_MAX_CAP)
	local maxStatColumns

	if flag then
		maxStatColumns = Constants.MOBILE_MAX_STAT_COLUMNS
	else
		maxStatColumns = Constants.DESKTOP_MAX_STAT_COLUMNS
	end

	local v8 = v5 + math.min(p, maxStatColumns) * statWidth
	local panelWidth, panelHeight

	if flag then
		local v9 = math.max(Constants.MOBILE_EDGE_GAP, Constants.MOBILE_EDGE_GAP * scale)
		local v10 = computeMobilePanelSize(v, v6, v7, topBarOffset + v9 + getDeviceBottomInset() + v9)
		panelWidth = v10.X
		panelHeight = v10.Y
	else
		if flag2 then
			panelWidth = Constants.PLATFORM_PANEL_WIDTH * scale
		else
			panelWidth = 2 * size_200 + v8
		end

		local v9 = headerHeight + Constants.PANEL_HEADER_DIVIDER_HEIGHT * scale

		if FFlagPlayerListReskin and flag2 then
			v9 += Constants.PANEL_TABS_HEIGHT * scale
		end

		local v10 = v9 + v3
		local v11 = columnHeaderHeight + Constants.DESKTOP_MIN_VISIBLE_ROWS * v4

		if FFlagPlayerListFixPlatformLeaderboardSizing and flag2 then
			v11 = math.max(v11, Constants.PLATFORM_BODY_MIN_HEIGHT * scale)
		end

		local v12 = v9 + v11
		panelHeight = computeDesktopPanelHeight(v.Y, v10, v12)
	end

	return {
		panelWidth = panelWidth,
		panelHeight = panelHeight,
		headerHeight = headerHeight,
		columnHeaderHeight = columnHeaderHeight,
		rowHeight = rowHeight,
		statWidth = statWidth,
		maxStatColumns = maxStatColumns
	}
end

return usePanelLayout
