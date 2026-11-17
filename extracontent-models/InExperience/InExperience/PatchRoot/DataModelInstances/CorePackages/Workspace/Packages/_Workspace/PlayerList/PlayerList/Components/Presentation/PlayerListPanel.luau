local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)
local ReactOtter = require(parent2.ReactOtter)
local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap
require(parent2.LeaderboardStore)

local View = Foundation.View
local ScrollView = Foundation.ScrollView
local useTokens = Foundation.Hooks.useTokens

local PanelContentHeightStore = require(parent.Common.PanelContentHeightStore)
local useReportPanelContentHeight = require(parent.Hooks.useReportPanelContentHeight)
local usePreferredBackgroundStyle = require(parent.Hooks.usePreferredBackgroundStyle)

local useLeaderboardStore = require(parent.Hooks.useLeaderboardStore)
local usePanelLayout = require(parent.Hooks.usePanelLayout)
local usePlatformLeaderboard = require(parent.Hooks.usePlatformLeaderboard)
local useSlideOpenCloseAnimation = require(parent.Hooks.useSlideOpenCloseAnimation)
local useSlideOpenCloseAnimation2 = useSlideOpenCloseAnimation.useSlideOpenCloseAnimation
local PANEL_SLIDE_CONFIG = useSlideOpenCloseAnimation.PANEL_SLIDE_CONFIG
local PANEL_ZOOM_CONFIG = useSlideOpenCloseAnimation.PANEL_ZOOM_CONFIG
local MOBILE_ZOOM_SPRING = useSlideOpenCloseAnimation.MOBILE_ZOOM_SPRING
local MENU_ZOOM_CLOSED_SCALE = useSlideOpenCloseAnimation.MENU_ZOOM_CLOSED_SCALE
local PANEL_RECESS_SCALE = useSlideOpenCloseAnimation.PANEL_RECESS_SCALE
local PANEL_RECESS_TRANSPARENCY = useSlideOpenCloseAnimation.PANEL_RECESS_TRANSPARENCY
local computeStatColumns = require(parent.Common.computeStatColumns)
local PlayerListVisibilityStore = require(parent.Common.PlayerListVisibilityStore)
local PlayerContextualMenuStore = require(parent.Common.PlayerContextualMenuStore)
local toggleContextMenu = PlayerContextualMenuStore.toggleContextMenu
local Constants = require(parent.Common.Constants)

local PanelHeader = require(parent.Components.Presentation.PanelHeader)
local ColumnHeaderRow = require(parent.Components.Presentation.ColumnHeaderRow)
local TeamListView = require(parent.Components.Presentation.TeamListView)
local ConsoleFocusScrollView = require(parent.Components.Presentation.ConsoleFocusScrollView)
local EntryView = require(parent.Components.Presentation.EntryView)
local TabbedLeaderboardBody = require(parent.Components.Presentation.TabbedLeaderboardBody)

local FFlagPlayerListReskin = require(parent.Flags.FFlagPlayerListReskin)

local FallbackSignals = require(parent.Common.FallbackSignals)

local signalMap = createSignalMap()
local signalMap2 = createSignalMap()

local function wrapWithSlide(panelContent, position, p: number, p2: number)
	if position == nil then
		return panelContent
	end

	return React.createElement(View, { Size = UDim2.fromOffset(p, p2) }, {
		SlideOffset = React.createElement(View, { tag = "size-full", Position = position }, {
			PanelContent = panelContent
		})
	})
end

local function createZoomDecorations(scale, transparency, p)
	if scale == nil then
		return nil
	end

	local v = {
		UIScale = React.createElement("UIScale", { Scale = scale })
	}

	if transparency ~= nil then
		v.UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = p.Color.Stroke.Default.Color3,
			Transparency = transparency,
			Thickness = p.Stroke.Standard
		})
	end

	return v
end

local function renderWithSlideAndZoomDecorations(p, p2, p3, slidePosition, panelWidth: number, panelHeight: number, zoomDecorations)
	if zoomDecorations ~= nil then
		p3 = Cryo.Dictionary.join(p3, zoomDecorations)
	end

	return wrapWithSlide(React.createElement(p, p2, p3), slidePosition, panelWidth, panelHeight)
end

local function PlayerListPanelContent(props)
	local isSmallTouchDevice = props.isSmallTouchDevice == true
	local title = props.title
	local platformLeaderboardOverride = props.platformLeaderboardOverride
	local leaderboardStore = useLeaderboardStore()
	local v = props.localPlayerOverride

	if not v then
		local Players = game:GetService("Players")
		v = Players.LocalPlayer
	end

	local v2

	if leaderboardStore then
		v2 = leaderboardStore.getTeamList()
	else
		v2 = signalMap
	end

	local v3

	if leaderboardStore then
		v3 = leaderboardStore.getGameStatsList()
	else
		v3 = signalMap2
	end

	local allTeams = SignalsReact.useSignalState(v2.getAllData)
	local v4 = SignalsReact.useSignalState(v3.getAllData)
	local count = v3.getCount(false)
	local v5

	if FFlagPlayerListReskin then
		v5 = platformLeaderboardOverride or usePlatformLeaderboard()
	end

	local getHasActiveLeaderboard

	if v5 then
		getHasActiveLeaderboard = v5.getHasActiveLeaderboard
	else
		getHasActiveLeaderboard = FallbackSignals.getHasActiveLeaderboard
	end

	local v6

	if FFlagPlayerListReskin then
		v6 = SignalsReact.useSignalState(getHasActiveLeaderboard)
	else
		v6 = false
	end

	local v7 = usePanelLayout(isSmallTouchDevice, count, v6)

	local v8 = useTokens()
	local backgroundStyle = usePreferredBackgroundStyle(v8.Color.OverMedia.OverMedia_200)

	local v9 = SignalsReact.useSignalState(PlayerListVisibilityStore.getEffectiveVisible)

	local onClose = React.useCallback(function()
		if not PlayerListVisibilityStore.getEffectiveVisible(false) then
			return
		end

		PlayerContextualMenuStore.closeContextMenu()
		PlayerListVisibilityStore.setVisible(false)
	end, {})
	local onActivated

	if v9 then
		onActivated = toggleContextMenu
	end

	local v10 = SignalsReact.useSignalState(PlayerContextualMenuStore.getMenuData) ~= nil

	local v11, v12 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		if not isSmallTouchDevice then
			return
		end

		v12(ReactOtter.spring(v10 and 1 or 0, MOBILE_ZOOM_SPRING))
	end, { v10, isSmallTouchDevice })
	local openCloseOffset = props.openCloseOffset
	local v13 = isSmallTouchDevice and openCloseOffset ~= nil
	local scale = React.useMemo(function()
		if v13 and openCloseOffset ~= nil then
			return React.joinBindings({ openCloseOffset, v11 }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return (1 + (MENU_ZOOM_CLOSED_SCALE - 1) * item) * (1 - (1 - PANEL_RECESS_SCALE) * item2)
			end)
		end

		return nil
	end, { v13, openCloseOffset, v11 })
	local groupTransparency = React.useMemo(function()
		if v13 and openCloseOffset ~= nil then
			return React.joinBindings({ openCloseOffset, v11 }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return 1 - (1 - item) * (1 - PANEL_RECESS_TRANSPARENCY * item2)
			end)
		end

		return nil
	end, { v13, openCloseOffset, v11 })

	local transparency = React.useMemo(function()
		if groupTransparency == nil then
			return nil
		end

		local transparency = v8.Color.Stroke.Default.Transparency
		return groupTransparency:map(function(p: number)
			return transparency + (1 - transparency) * p
		end)
	end, { groupTransparency, v8.Color.Stroke.Default.Transparency })
	local zoomDecorations = createZoomDecorations(scale, transparency, v8)

	local scrollingFrameRef = useReportPanelContentHeight(v7.columnHeaderHeight)

	React.useEffect(function()
		return function()
			PanelContentHeightStore.reset()
		end
	end, {})
	local v14

	if isSmallTouchDevice and v ~= nil and leaderboardStore ~= nil then
		v14 = v2.getCount(false) > 0 or count > 0
	else
		v14 = false
	end

	local maxStatColumns = v7.maxStatColumns

	local statColumns = React.useMemo(function()
		return computeStatColumns(v3, maxStatColumns)
	end, { v4, v3, maxStatColumns })

	local hasNonNeutralTeams = false

	if leaderboardStore then
		for k, v15 in pairs(allTeams) do
			if v15 and k ~= "Neutral" then
				hasNonNeutralTeams = true
				break
			end
		end
	end

	local scrollViewProps = {
		LayoutOrder = 2,
		tag = "fill size-full-0",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		},
		scroll = { AutomaticCanvasSize = nil, ScrollingDirection = Enum.ScrollingDirection.Y },
		scrollingFrameRef = scrollingFrameRef,
		selectionGroup = Constants.CONSOLE_FOCUS_SCROLL_ESCAPE_UP,
		selection = Constants.NOT_SELECTABLE
	}
	local playerRows

	if leaderboardStore then
		playerRows = React.createElement(ConsoleFocusScrollView, {
			allTeams = allTeams,
			hasNonNeutralTeams = hasNonNeutralTeams,
			leaderboardStore = leaderboardStore,
			statColumns = statColumns,
			statWidth = v7.statWidth,
			rowHeight = v7.rowHeight,
			columnHeaderHeight = v7.columnHeaderHeight,
			localPlayer = v,
			scrollViewProps = scrollViewProps,
			onActivated = onActivated
		})
	else
		local children = {}

		if leaderboardStore then
			for k, teamEntry in pairs(allTeams) do
				if teamEntry then
					children[`Team_{tostring(k)}`] = React.createElement(TeamListView, {
						teamEntry = teamEntry,
						isNeutral = k == "Neutral",
						hasNonNeutralTeams = hasNonNeutralTeams,
						leaderboardStore = leaderboardStore,
						statColumns = statColumns,
						statWidth = v7.statWidth,
						rowHeight = v7.rowHeight,
						columnHeaderHeight = v7.columnHeaderHeight,
						onActivated = onActivated,
						localPlayer = v
					})
				end
			end
		end

		playerRows = React.createElement(ScrollView, scrollViewProps, children)
	end

	local stickySelfRow

	if v14 then
		stickySelfRow = React.createElement(EntryView, {
			player = v,
			leaderboardStore = leaderboardStore,
			statColumns = statColumns,
			statWidth = v7.statWidth,
			rowHeight = v7.rowHeight,
			onActivated = onActivated,
			isCurrentUser = true,
			layoutOrder = 0
		})
	end

	local v15 = {
		StickySelfRow = stickySelfRow,
		ColumnHeaders = React.createElement(ColumnHeaderRow, {
			statColumns = statColumns,
			statWidth = v7.statWidth,
			headerHeight = v7.columnHeaderHeight,
			layoutOrder = 1
		}),
		PlayerRows = playerRows
	}
	local strokestandardstrokedefault = transparency == nil
	local panelProps = React.useMemo(function()
		return {
			Size = UDim2.fromOffset(v7.panelWidth, v7.panelHeight),
			tag = {
				["col radius-medium"] = true,
				["stroke-standard stroke-default"] = strokestandardstrokedefault
			},
			backgroundStyle = backgroundStyle,
			Visible = true,
			GroupTransparency = groupTransparency,
			selectionGroup = Constants.CONSOLE_FOCUS_ISOLATE,
			selection = Constants.NOT_SELECTABLE
		}
	end, {
		v7.panelWidth,
		v7.panelHeight,
		strokestandardstrokedefault,
		backgroundStyle,
		groupTransparency
	})

	local element = React.createElement(PanelHeader, {
		onClose = onClose,
		isDisabled = not v9,
		height = v7.headerHeight,
		title = title,
		layoutOrder = 1
	})

	local element2 = React.createElement(Foundation.Divider, { LayoutOrder = 2 })

	if not FFlagPlayerListReskin then
		return renderWithSlideAndZoomDecorations(View, panelProps, {
			Header = element,
			HeaderDivider = element2,
			LeaderboardBody = React.createElement(View, {
				LayoutOrder = 3,
				tag = "col fill size-full-0"
			}, v15)
		}, props.slidePosition, v7.panelWidth, v7.panelHeight, zoomDecorations)
	end

	return renderWithSlideAndZoomDecorations(TabbedLeaderboardBody, {
		serverBody = React.createElement(View, { LayoutOrder = 4, tag = "col fill size-full-0" }, v15),
		panelHeader = element,
		panelDivider = element2,
		panelProps = panelProps
	}, {}, props.slidePosition, v7.panelWidth, v7.panelHeight, zoomDecorations)
end

local function PlayerListPanel(props)
	local v = SignalsReact.useSignalState(PlayerListVisibilityStore.getEffectiveVisible)
	local isSmallTouchDevice = props.isSmallTouchDevice == true
	local v2

	if isSmallTouchDevice then
		v2 = PANEL_ZOOM_CONFIG
	else
		v2 = PANEL_SLIDE_CONFIG
	end

	local v3 = useSlideOpenCloseAnimation2(v, v2)

	if not v3.shouldMount then
		return nil
	end

	local createElement = React.createElement
	local v4 = {
		isSmallTouchDevice = props.isSmallTouchDevice,
		title = props.title,
		localPlayerOverride = props.localPlayerOverride,
		platformLeaderboardOverride = props.platformLeaderboardOverride,
		slidePosition = 0,
		openCloseOffset = 0
	}
	local slidePosition

	if not isSmallTouchDevice then
		slidePosition = v3.position
	end

	v4.slidePosition = slidePosition
	local openCloseOffset

	if isSmallTouchDevice then
		openCloseOffset = v3.offset
	end

	v4.openCloseOffset = openCloseOffset
	return createElement(PlayerListPanelContent, v4)
end

return React.memo(PlayerListPanel)
